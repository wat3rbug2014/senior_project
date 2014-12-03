//
//  DBManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/25/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This class handles the local SQLITE3 database.  All functions needed to
 * use this database are enclosed in the class.
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "LocalDBResult.h"
#import "PersonalInfo.h"


@interface DBManager : NSObject


/**
 * The directory where the SQLITE database will be stored.
 */

@property (nonatomic, strong) NSString *documentsDirectory;


/**
 * The actual database file name.
 */

@property (nonatomic, strong) NSString *databaseFilename;


/**
 * The patient ID.  This is used for every operation to the database since it is part
 * or the primary key for the database.  It is also a primary key in the remote server
 * patients table.
 */

@property NSInteger patientID;


/**
 * YES or NO value that there is data to push to remote server since this database is not empty.
 */

@property BOOL moreRowsToRetrieve;


/**
 * The SQLITE database reference.  Used for control of the database.
 */

@property sqlite3 *database;


/**
 * The last row count of the database.  Used for checking to see if there is a change in the size of
 * the database.
 */

@property NSInteger rowCount;


/**
 * The relative path in the file system where the database resides.
 */

@property (nonatomic, strong) NSString *databasePath;


/**
 * The current SQL statement to be executed on the database.
 */

@property sqlite3_stmt *sqlStatement;


/**
 * The last heart rate measurment given to the database.
 */

@property NSInteger hrmeasurement;


/**
 * The last latitude measurement that was given to the database.
 */

@property float latitude;


/**
 * The last longitude measurement given to the database.
 */

@property float longitude;


/**
 * The activity level expressed as an integer.  See DeviceConstantsAndStaticFunctions.h 
 * for the value.
 */

@property int activityLevel;


/**
 * The current timestamp given to the database.
 */

@property NSDate *timestamp;




/**
 * This method initializes the database.  It is noted, that the default patientID is
 * NO_ID_SET.  WARNING: adding data to the database with no patientID set will result
 * erroneous results to this database and the remote database, should any updates occur.
 * It is advised to the use the -(instancetype) initWithpatientID: (NSInteger) currentPatient
 * method instead.
 *
 * @return An instance of the database manager with no patientID set.
 */

-(instancetype) init;


/**
 * This method initializes the database and sets up the patientID which will be used
 * for almost every query to the database.  the patientID is part of the primary key
 * for the table.  The assumption is that the database is empty when patientID is changed,
 * otherwise queries will fail.
 *
 * @param currentPatient The patientID that is to be used for the database.
 *
 * @return An instance of the database manager with the patientID set.
 */

-(instancetype) initWithpatientID: (NSInteger) currentPatient;


/**
 * This method is used for first time use of the application.  It copies the master database
 * template to the applications Documents directory for use with the application.  WARNING:
 * do not use the origin for use as the database.
 */

-(void)copyDatabaseIntoDocumentsDirectory;


/**
 * This method returns the first row in a query for the items in the local database.  It is
 * used in conjuction with the network poller to push local data to the remote database.  The
 * data is comma separated with the following order of information:
 *
 * heart_rate (integer), latitude (float), longitude (float), timestamp 
 * (See -(NSString*) timeStampAsString for output).
 *
 * @return The string representation of the row returned.
 */

-(LocalDBResult*) retrieveRow;


/**
 * This method performs a count of the table and return true if there are no more rows in
 * the table to retrieve.  It is used primarily for the network poll portion to determine
 * that the local database has been flushed and there is no more data to transfer to the
 * remote server.
 *
 * @return YES if the database is empty.
 */

-(BOOL) isDatabaseEmpty;


/**
 * This method updates the database by adding the current values for the database manager.
 * In order to have new data to the database the timestamp, latitude, longitude, and heart rate
 * variables must be updated first.  Otherwise, the existing variables will be used and will
 * result in an error if the timestamp is the same.  Since the timestamp  is part of the primary 
 * key for the database it must be unique in conjunction with the patientID.  This decision
 * was made in an effort to keep database transactions and subsequent SQL statements contained
 * to this class for easier troubleshooting.
 */

-(void) insertDataIntoDB;


/**
 * This method takes the NSDate object stored in this class and converts it to a
 * format that is useable to databases.  The assumptions are that the date has been updated.
 * This method is called only from this class.
 *
 * @param selectedTime The NSDate given to convert to a string for insertion to the database.
 *
 * @return The result string is a parsed date.  An example is '1970-05-10 18:45:10'.  That is
 * May 10 1970 at 6:45 pm and 10 seconds.
 */

+(NSString*) timeStampAsString: (NSDate*) selectedTime;


/**
 * This method is used in conjunction with the remote database updates.  It is called to remove the 
 * row from the local database after a successful insert to the remote database.  It is assumed that 
 * the patientID was already added as it is part of the primary key for the table in this database.
 *
 * @param oldTimeStamp This is part of the primary key for the table and must be supplied, otherwise
 * no record deletion happens.
 */

-(void) deleteRowAtTimeStamp: (NSString*) oldTimeStamp;


/**
 * This method is used to open the database connection and prepare the database with the
 * the SQL statement provided.  It is meant to be private to this class only.  NOTE: since this
 * database is SQLITE not all ACID compliant functions are used.  Furthermore some contraints, such
 * as date have different syntaxes associated with them.  Please see https://www.sqlite.org/docs.html
 * for more details relating to SQLITE.
 *
 * @param query is the SQL statement to use on the database.
 *
 * @return Yes if the query is valid and the database is open.
 */

-(BOOL) openLocalDBWithSQLQueryIsSuccessful: (NSString*) query;


/**
 * This method is meant to be a private method.  It is meant to finalize the database and close the
 * database.  All results from the query will be lost as memory is freed during finalization.
 */

-(void) closeLocalDBConnection;


/**
 * This method is used to clean out the database before use.  It makes the assumption that the previous
 * instance of this application did not crash and that all data was updated to the remote server.
 *  It is used as a safety mechanism so that faulty patientID information is not used to update
 * remote tables.
 */

-(void) purgeDatabase;

@end
