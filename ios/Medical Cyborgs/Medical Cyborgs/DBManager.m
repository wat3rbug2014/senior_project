//
//  DBManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/25/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DBManager.h"
#import "PersonalInfo.h"

@implementation DBManager

@synthesize documentsDirectory;
@synthesize databaseFilename;
@synthesize patientID;
@synthesize moreRowsToRetrieve;
@synthesize sqlInsertStatement;
@synthesize hrmeasurement;
@synthesize latitude;
@synthesize longitude;
@synthesize database;
@synthesize databasePath;
@synthesize timestamp;

-(instancetype)init {
    
    NSString *dbFilename = @"project.sql";
    if (self= [super init]) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
        self.patientID = NO_ID_SET;
        databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    }
    return self;
}

-(instancetype) initWithpatientID: (NSInteger) currentPatient {
    
    if (self = [self init]) {
        self.patientID = currentPatient;
    }
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory {
    
    // Check if the database file exists in the documents directory.
    
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        // copy to working directory from template
        
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)insertDataIntoDB {
    
    NSString *insertStatement = [NSString stringWithFormat:@"INSERT INTO MEASUREMENTS (patientID, longitude, latitude, heart_rate, time_measurement) VALUES ('%d','%f','%f', '%d', '%@')", patientID, longitude, latitude, hrmeasurement,[self timeStampAsString]];
    [self didPrepAndExecuteQuery:insertStatement];
}

-(NSString *)retrieveRow {
    
    NSString *result = nil;
    
    return result;
}

-(void) deleteRowAtTimeStamp: (NSString*) oldTimeStamp {
    
    NSString *deleteStatement = [NSString stringWithFormat:@"DELETE FROM MEASUREMENTS WHERE patientID = '%d' AND time_measurement = '%@'", patientID, oldTimeStamp];
    [self didPrepAndExecuteQuery:deleteStatement];
}

- (BOOL) isDatabaseEmpty {
    
    NSString *countString = @"SELECT COUNT(*) FROM MEASUREMENTS";
    [self didPrepAndExecuteQuery:countString];
    return !moreRowsToRetrieve;
}

-(NSString*) didPrepAndExecuteQuery:(NSString *)query {
    
    NSString *result = nil;
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &database);
    if(openDatabaseResult == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        BOOL prepareStatementResult = sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            if(sqlite3_step(compiledStatement) == SQLITE_ERROR) {
                NSLog(@"error working %@:\n\n%s", query, sqlite3_errmsg(database));
            } else {
                NSLog(@"query success");
                int rows = sqlite3_column_int(compiledStatement, 0);
                if ( rows > 0) {
                    moreRowsToRetrieve = YES;
                } else {
                    moreRowsToRetrieve = NO;
                }
            }
        }
    }
    sqlite3_close(database);
    return result;
}

-(NSString*) timeStampAsString {
    
    NSDateComponents *timeStampComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:timestamp];
    int month = [timeStampComponents month];
    int year = [timeStampComponents year];
    int day = [timeStampComponents day];
    int hour =[timeStampComponents hour];
    int minute = [timeStampComponents minute];
    int seconds = [timeStampComponents second];
    NSString *result = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", year, month, day, hour, minute, seconds];
    return result;
}

@end
