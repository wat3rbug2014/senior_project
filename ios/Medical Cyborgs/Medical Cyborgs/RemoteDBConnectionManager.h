//
//  RemoteDBConnectionManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/** 
 * This class performs updates to the remote database.  It manages the connection
 * and updates the local database with the changes that have been made.  It is assumed
 * that address to the server and the name of the scripts in the DataConstants.h file
 * are correct.  NOTE:  Each time a request to push data to the server the manager makes
 * 3 attempts to contact the server before giving up.  It has a 15 second timeout interval
 * so there may be the need to do some better reachability checks if battery consumption
 * is too much.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PersonalInfo.h"
#import "DBManager.h"
#import "LocalDBResult.h"

@interface RemoteDBConnectionManager : NSObject <NSURLSessionDelegate>


/**
 * The database manager that will be used to retrieve data and send to the remote server.
 */

@property DBManager *database;


/**
 * The patientID that is used for removing rows from the local database as they are sent.
 * It is also used for the transmission of data to the remote server.
 */

@property NSInteger patientID;


/**
 * The first row selected from the database as a result of a SQL statement.  It contains
 * the data needed for transmission to the server.
 */

@property (nonatomic) LocalDBResult* currentRow;


/**
 * The data buffer for the response from the server.  Used for determining the status
 * message from the server.
 */

@property (retain) NSMutableData *_serverResponseData;


/**
 * The counter for the number of failed attempts.  The current limit is 3 times.
 */

@property NSInteger failedAttempts;


/**
 * The flag used to determine if any more attempts should be made to the server after
 * the failedAttempts count has reached three times.
 */

@property BOOL remoteUnreachable;


/**
 * This method creates an instance using the database manager that is passed to it.
 * This is the preferred method.  If no database is given it will attempt to to
 * open the database and assign it.
 *
 * @param datastore The database manager that is to be the source of data to send to
 * the server.
 *
 * @return An instance of the remote server manager.
 */

-(id) initWithDatabase: (DBManager*) datastore;


/**
 * This method is the wrapper method for the class.  It checks to see if the remote is 
 * still reachable and that there is something to send to the server.  If the server
 * has been unreachable it ends.  If the server is reachable and the database is empty 
 * it ends, otherwise it continues going through the database and pushing.
 */

-(void) pushDataToRemoteServer;


/**
 * This method is the workhorse of the class. It retrieves the first first row from the 
 * database.  Then it creates a URL based on the data it retrieved.  Then it makes a 
 * URL request to the server.  After that the NSURLConnection delete methods handle the
 * calls and continue the loop.
 */

-(void) sendRowToServer;

/**
 * This method removes the current row from the database.  It is called after a successful
 * push to the remote server.  For our purposes, the local database essentially functions
 * as a queue with an additional save state.  In case of application crash or phone crash,
 * etc the data is not lost and seemed easier to implement than a persistent data store.
 */

-(void) removeCurrentRowInLocalDB;

/**
 * This is probably a bad hack.  This method is used to encode the string
 * into a URL suitable for the server.  It does not escape the ? = & _ - / symbols.
 * It has been put into place because the default apple method for url encoding
 * a string with %encoding does not encode :'s.  Unfortunately the datetime response
 * from the local database includes colons.  Using the search and replace method
 * appears to has some undefined behavior and places extra escape sequences where none
 * are wanted or needed.
 *
 * @param utfString The incoming string that will be utf8 encoded and then converted to a URL.
 *
 * @return A NSString that is a new URL with % encoding.
 */

-(NSString*) URLEncodedString: (NSString*) utfString;

@end
