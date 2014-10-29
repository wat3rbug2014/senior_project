//
//  RemoteDBConnectionManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalInfo.h"
#import "DBManager.h"
#import "LocalDBResult.h"

@interface RemoteDBConnectionManager : NSObject <NSURLConnectionDataDelegate>

@property DBManager *database;
@property NSInteger patientID;
@property (nonatomic) LocalDBResult* currentRow;
@property (retain) NSMutableData *_serverResponseData;


-(id) initWithDatabase: (DBManager*) datastore;
-(void) pushDataToRemoteServer;
-(void) sendRowToServer;
-(void) removeCurrentRowInLocalDB;
-(NSString*) URLEncodedString: (NSString*) utfString;
@end
