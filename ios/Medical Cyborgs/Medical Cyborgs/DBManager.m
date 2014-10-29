//
//  DBManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/25/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DBManager.h"
#import "PersonalInfo.h"
#import "LocalDBConstants.h"

@implementation DBManager

@synthesize documentsDirectory;
@synthesize databaseFilename;
@synthesize patientID;
@synthesize moreRowsToRetrieve;
@synthesize hrmeasurement;
@synthesize latitude;
@synthesize longitude;
@synthesize database;
@synthesize databasePath;
@synthesize timestamp;
@synthesize sqlStatement;

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
    
    NSString *insertStatement = [NSString stringWithFormat:@"INSERT INTO MEASUREMENTS (patientID, longitude, latitude, heart_rate, time_measurement) VALUES (%d, %f, %f, %d, '%@')", (int)patientID, longitude, latitude, (int)hrmeasurement,[self timeStampAsString]];
    NSLog(@"SQL: %@", insertStatement);
    if ([self openLocalDBWithSQLQueryIsSuccessful:insertStatement]) {
        NSLog(@"Insert prep successful");
        if(sqlite3_step(sqlStatement) == SQLITE_DONE) {
            NSLog(@"insert execute successful");
        } else {
            NSLog(@"insert execute failed");
        }
    } else {
        NSLog(@"insert prep failed");
    }
}

-(DBResult)retrieveRow {
    
    DBResult result;
    NSString *retrieveStatement = @"SELECT heart_rate, latitude, longitude, time_measurement FROM MEASUREMENTS";
    if ([self openLocalDBWithSQLQueryIsSuccessful:retrieveStatement]) {
        int row_result = sqlite3_step(sqlStatement);
        if (row_result == SQLITE_ROW) {
            result.heartRate = sqlite3_column_int(sqlStatement, 0);
            result.latitude = (float)sqlite3_column_double(sqlStatement, 1);
            result.longitude = (float)sqlite3_column_double(sqlStatement, 2);
            result.timestamp = sqlite3_column_double(sqlStatement, 3);
        } else {
            NSLog(@"retrieve row execute failed");
            [self closeLocalDBConnection];
        }
    } else {
        NSLog(@"retrieve row prep failed");
        [self closeLocalDBConnection];
    }
    return result;
}

-(void) deleteRowAtTimeStamp: (NSString*) oldTimeStamp {
    
    NSString *deleteStatement = [NSString stringWithFormat:
        @"DELETE FROM MEASUREMENTS WHERE patientID = '%d' AND time_measurement = '%@'",
        (int)patientID, oldTimeStamp];
    NSLog(@"SQL: %@", deleteStatement);
    if ([self openLocalDBWithSQLQueryIsSuccessful:deleteStatement]) {
        if (sqlite3_step(sqlStatement) == SQLITE_DONE) {
            NSLog(@"delete execute successful");
        } else {
            NSLog(@"delete execute failed");
        }
        [self closeLocalDBConnection];
    } else {
        NSLog(@"delete prep failed");
    }
}

- (BOOL) isDatabaseEmpty {
    
    // test this cause decision tree is hairy
    
    NSString *countString = @"SELECT COUNT(*) FROM MEASUREMENTS";
    NSLog(@"SQL: %@", countString);
    if ([self openLocalDBWithSQLQueryIsSuccessful:countString]) {
        NSLog(@"count prep successful");
        if (sqlite3_step(sqlStatement) == SQLITE_ROW) {
            int count = sqlite3_column_int(sqlStatement, 0);
            NSLog(@"count is %d", count);
            if (count > 0 ) {
                [self setMoreRowsToRetrieve:YES];
            } else {
                [self setMoreRowsToRetrieve:NO];
            }
        } else {
            NSLog(@"count failed step");
        }
        [self closeLocalDBConnection];
    } else {
        NSLog(@"count failed prep");
    }
    return !moreRowsToRetrieve;
}

-(NSString*) timeStampAsString {
    
    NSDateComponents *timeStampComponents = [[NSCalendar currentCalendar] components:
        NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour
        | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:timestamp];
    int month = (int)[timeStampComponents month];
    int year = (int)[timeStampComponents year];
    int day = (int)[timeStampComponents day];
    int hour = (int)[timeStampComponents hour];
    int minute = (int)[timeStampComponents minute];
    int seconds = (int)[timeStampComponents second];
    NSString *result = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", year, month, day,
        hour, minute, seconds];
    return result;
}

-(BOOL) openLocalDBWithSQLQueryIsSuccessful:(NSString *)query {
    
    BOOL success = NO;
    success = sqlite3_open([databasePath UTF8String], &database);
    sqlStatement = nil;
    if(success == SQLITE_OK) {
        int prepareStatementResult = sqlite3_prepare_v2(database, [query UTF8String], -1,
            &sqlStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {
            success = YES;
        } else {
            success = NO;
            NSLog(@"error working %@:\n\n%s", query, sqlite3_errmsg(database));
            NSLog(@"error code: %d", sqlite3_errcode(database));
        }
    } else {
        success = NO;
        NSLog(@"error working %@:\n\n%s", query, sqlite3_errmsg(database));
        NSLog(@"error code: %d", sqlite3_errcode(database));
    }
    return success;
}

-(void)closeLocalDBConnection {
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(database);
}
@end
