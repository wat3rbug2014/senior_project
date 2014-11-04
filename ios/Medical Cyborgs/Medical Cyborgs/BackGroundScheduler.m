//
//  BackGroundScheduler.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BackgroundScheduler.h"

@implementation BackgroundScheduler

@synthesize deviceManager;
@synthesize devicePoller;
@synthesize serverPoller;
@synthesize database;
@synthesize patient;

-(id) init {
    
    // this makes me nervous since patientID may not be known yet
    
    if (self = [super init]) {
        deviceManager = [BTDeviceManager sharedManager];
        patient = [[PersonalInfo alloc] init];
        database = [[DBManager alloc] initWithpatientID:[patient patientID]];
        devicePoller = [[DevicePollManager alloc] initWithDataStore:database andDevicemanager:deviceManager];
        serverPoller = [[RemoteDBConnectionManager alloc] initWithDatabase:database];
    }
    return self;
}
@end
