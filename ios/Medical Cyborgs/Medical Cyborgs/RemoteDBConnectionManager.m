//
//  RemoteDBConnectionManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "RemoteDBConnectionManager.h"
#import "LocalDBResult.h"
#import "DatabaseConstants.h"

@implementation RemoteDBConnectionManager


@synthesize database;
@synthesize patientID;
@synthesize _serverResponseData;
@synthesize currentRow;
@synthesize failedAttempts;
@synthesize remoteUnreachable;

-(id) initWithDatabase: (DBManager*) datastore {
    
    if (self = [super init]) {
        if (datastore == nil) {
            database = [[DBManager alloc] init];
        } else {
            database = datastore;
        }
        patientID = NO_ID_SET;
        failedAttempts = 0;
        remoteUnreachable = NO;
    }
    return self;
}

-(void) pushDataToRemoteServer {
    
    if (database == nil) {
        NSLog(@"There is no database\nShutting down");
        return;
    }
    NSLog(@"connecting to database");
    if(!remoteUnreachable && ![database isDatabaseEmpty]) {
        NSLog(@"rows in database to push: %d", (int)[database rowCount]);
        [self sendRowToServer];
    } else {
        if ([database isDatabaseEmpty]) {
            NSLog(@"database is empty");
        } else {
            NSLog(@"Unable to reach server");
        }
    }
}

-(void)sendRowToServer {
    
    if (database == nil) {
        NSLog(@"database failure occurred");
        return;
    }
    currentRow = [database retrieveRow];
    
    // put the data into a URL
    
    NSString *patientStr = [NSString stringWithFormat:@"patientID=%d", (int)patientID];
    NSString *heartRateStr = [NSString stringWithFormat:@"heart_rate=%d", (int)[currentRow heartRate]];
    NSString *latStr = [NSString stringWithFormat:@"latitude=%f", [currentRow latitude]];
    NSString *longStr = [NSString stringWithFormat:@"longitude=%f", [currentRow longitude]];


    NSString *timeStr = [NSString stringWithFormat:@"time_measurement=%@",[currentRow timeStamp]];
    NSString *rawUserUrl = [NSString stringWithFormat:@"&%@&%@&%@&%@&%@", patientStr, heartRateStr, latStr,
        longStr, timeStr];
    NSString *userUrl = [self URLEncodedString:rawUserUrl];
    NSURL *databaseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", INSERT_DB_BASE_URL, userUrl]];
    NSLog(@"url: %@",databaseUrl);
    
    // go to server and add row of data
    
    NSTimeInterval requestTime = 15.0;
    NSURLRequest *dbRequest = [NSURLRequest requestWithURL:databaseUrl cachePolicy:
        NSURLRequestReloadIgnoringCacheData timeoutInterval:requestTime];
    NSURLConnection *connector = [[NSURLConnection alloc] initWithRequest: dbRequest delegate:
        self startImmediately: YES];
    [connector start];
}

-(void) removeCurrentRowInLocalDB {
    
    [database setPatientID:patientID]; // not sure why this changed
    [database deleteRowAtTimeStamp:[currentRow timeStamp]];
    [self pushDataToRemoteServer];
}

-(NSString*) URLEncodedString: (NSString*) utfString {
    
    // setup a c string
    
    NSMutableString * output = [NSMutableString string];
    const char * source = [utfString UTF8String];
    int sourceLen = (int)strlen(source);
    
    // walk through string and change characters when found
    
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = (const unsigned char)source[i];
        if (false && thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9') ||
                   thisChar == '&' || thisChar == '?' ||
                   thisChar == '=') {
            
            // place characters in NSString
            
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

#pragma NSURLConnectDataDelegate methods


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"couldn't reach: see %@", error);
    failedAttempts++;
    if (failedAttempts < 3) {
        [self sendRowToServer];
    } else {
        remoteUnreachable = YES;
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _serverResponseData = [[NSMutableData alloc] init];
    NSLog(@"got a response");
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_serverResponseData appendData:data];
    NSLog(@"got data %d bytes", (int)[_serverResponseData length]);
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    /**
     * WARNING:  The expected response from the server is just UTF8 text representing the integer value of
     * the patient of the success code.  If this should change, this method needs to be altered to parse the information
     * correctly.
     */
    
    NSString *patientIDResponseString = [[NSString alloc] initWithData: _serverResponseData encoding: NSUTF8StringEncoding];
    NSLog(@"raw data is %@", patientIDResponseString); // starbucks login found one time
    NSInteger receivedInt = [patientIDResponseString integerValue];
    NSLog(@"Data is now %d", (int)receivedInt);
    if (![database isDatabaseEmpty]) {
        remoteUnreachable = NO;
        failedAttempts = 0;
        [self removeCurrentRowInLocalDB];
    }
}

@end
