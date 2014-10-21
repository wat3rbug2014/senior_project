//
//  RemoteDBConnectionManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalInfo.h"

@interface RemoteDBConnectionManager : NSObject <NSURLConnectionDataDelegate>

@property NSData *database;

-(id) initWithDatabase: (NSData*) datastore;
-(void) pushDataToRemoteServer;
-(void) flushDatabaseToRemoteServer;

@end
