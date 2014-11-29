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
    
    if (datastore == nil) {
        return nil;
    }
    if (self = [super init]) {
        if (datastore == nil) {
            database = [[DBManager alloc] init];
        } else {
            database = datastore;
        }
        patientID = [database patientID];
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
    NSString *activeStr = [NSString stringWithFormat:@"activity_level=%d",(int)[currentRow activityLevel]];
    NSString *rawUserUrl = [NSString stringWithFormat:@"&%@&%@&%@&%@&%@&%@", patientStr, heartRateStr, latStr,
        longStr, activeStr, timeStr];
    NSString *userUrl = [self URLEncodedString:rawUserUrl];
    NSURL *databaseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", INSERT_DB_BASE_URL, userUrl]];
    NSLog(@"url: %@",databaseUrl);
    
    // go to server and add row of data
    
    // setup config for background process of requests
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setNetworkServiceType:NSURLNetworkServiceTypeBackground];
    [config setTimeoutIntervalForRequest:15.0];
    [config setAllowsCellularAccess:YES];
    [config setHTTPMaximumConnectionsPerHost:1];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];

    NSURLRequest *request = [NSURLRequest requestWithURL:databaseUrl
        cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    NSURLSessionUploadTask *uploadData = [session uploadTaskWithRequest:request fromFile:databaseUrl
        completionHandler:^(NSData* data, NSURLResponse *response, NSError *error){
        
            NSString *patientIDResponseString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"raw data is %@", patientIDResponseString);
            NSInteger receivedInt = [patientIDResponseString integerValue];
            NSLog(@"Data is now %d", (int)receivedInt);
                                                          
            // this should check for value to resend or not
                                                          
            if (![database isDatabaseEmpty]) {
                remoteUnreachable = NO;
                failedAttempts = 0;
                [self removeCurrentRowInLocalDB];
            }
        }];
    [uploadData resume];
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

@end
