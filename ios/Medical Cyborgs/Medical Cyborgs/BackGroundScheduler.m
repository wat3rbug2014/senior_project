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
@synthesize allowMonitoring;

@synthesize runLoop;
@synthesize devicePollInterval;
@synthesize serverPollInterval;
@synthesize app;
@synthesize devicePollTimer;
@synthesize serverPollTimer;

-(id) init {
    
    // this makes me nervous since patientID may not be known yet
    
    if (self = [super init]) {
        
        
        // setup the other managers
        
        patient = [[PersonalInfo alloc] init];
        deviceManager = [BTDeviceManager sharedManager];
        database = [[DBManager alloc] initWithpatientID:[patient patientID]];
        devicePoller = [[DevicePollManager alloc] initWithDataStore:database andDevicemanager:deviceManager];
        serverPoller = [[RemoteDBConnectionManager alloc] initWithDatabase:database];
        allowMonitoring = NO;
        devicePollInterval = 5.0;
        serverPollInterval = 60.0;
    }
    return self;
}

-(void)startMonitoringWithPatientID:(NSInteger)identifier {
    
    // make sure there is patientID before starting
    // just extra precaution
    
    [patient setPatientID:identifier];
    [patient saveInformation];
    if ([patient patientID] == NO_ID_SET && patient != nil) {
        [patient loadInformation];
        if ([patient patientID] == NO_ID_SET) {
            allowMonitoring = NO;
            return;
        } else {
            allowMonitoring = YES;
        }
    } else {
        allowMonitoring = YES;
    }
    [devicePoller setPatientID:[patient patientID]];
    [serverPoller setPatientID:[patient patientID]];
    [self performScan];
}

-(void)stopMonitoring {
    
    [runLoop cancelPerformSelectorsWithTarget:self];
    [serverPoller pushDataToRemoteServer];
    [devicePollTimer invalidate];
    [serverPollTimer invalidate];
    [devicePoller stopMonitoring];
}

-(void)performScan {
    
    if (!allowMonitoring) {
        return;
    }
    if ([app applicationState] == UIApplicationStateBackground) {
        NSLog(@"Background mode");
    } else {
        NSLog(@"Foreground mode");
        devicePollTimer = [NSTimer scheduledTimerWithTimeInterval:devicePollInterval target:devicePoller
            selector:@selector(pollDevicesForData) userInfo:nil repeats:YES];
        serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:serverPollInterval target:serverPoller
            selector:@selector(pushDataToRemoteServer) userInfo:nil repeats:YES];
        [runLoop addTimer:devicePollTimer forMode:NSDefaultRunLoopMode];
        [runLoop addTimer:serverPollTimer forMode:NSDefaultRunLoopMode];
    }
}

-(UIApplication*) app {
    
    return [UIApplication sharedApplication];
}

@end
