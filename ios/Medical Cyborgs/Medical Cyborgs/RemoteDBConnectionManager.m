//
//  RemoteDBConnectionManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "RemoteDBConnectionManager.h"

@implementation RemoteDBConnectionManager


@synthesize database;

-(id) initWithDatabase: (NSData*) datastore {
    
    if (self = [super init]) {
        database = datastore;
    }
    return self;
}

-(void) pushDataToRemoteServer {
    
    NSLog(@"connecting to database");
    // connect to database
    
    while (database != nil) { // this needs to be fixed for data store
        NSLog(@"pushing to server");
    }
    // push data to server
    // close connection
    NSLog(@"End of server update");
}

-(void) flushDatabaseToRemoteServer {
    
    
}

@end
