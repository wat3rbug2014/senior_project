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
@synthesize locationAllowed;
@synthesize locationManager;
@synthesize bigLocationChanges;
@synthesize runLoop;
@synthesize devicePollInterval;
@synthesize serverPollInterval;
@synthesize app;
@synthesize devicePollTimer;
@synthesize serverPollTimer;

-(id) init {
    
    // this makes me nervous since patientID may not be known yet
    
    if (self = [super init]) {
        
        // setup for location changes
        
        locationManager = nil;
        bigLocationChanges = NO;
        NSInteger status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            locationAllowed = NO;
        } else {
            locationAllowed = YES;
        }
        if (locationAllowed) {
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [locationManager requestWhenInUseAuthorization];
            } else {
                bigLocationChanges = [CLLocationManager significantLocationChangeMonitoringAvailable];
            }
        }
        // setup the other managers
        
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

-(void)startMonitoring {
    
    // make sure there is patientID before starting
    // just extra precaution
    
    if ([patient patientID] == NO_ID_SET) {
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
    [self performScan];
}

-(void)stopMonitoring {
    
    [runLoop cancelPerformSelectorsWithTarget:self];
    [serverPoller flushDatabase];
    [devicePollTimer invalidate];
    [serverPollTimer invalidate];
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

#pragma mark CLLocationManagerDelegate methods


-(void) locationManager:(CLLocationManager*) manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status {
    
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        locationAllowed = NO;
        if (locationManager != nil) {
            locationManager = nil;
        }
    } else {
        locationAllowed = YES;
    }
}

-(void) locationManager: (CLLocationManager*) manager didUpdateLocations: (NSArray*) locations {
    
    CLLocation *currentLocation = [locations objectAtIndex: [locations count] - 1];
    [database setLongitude:[currentLocation coordinate].longitude];
    [database setLatitude:[currentLocation coordinate].latitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // not sure what to do at this moment.  Database will be using last recording
    // and I haven't done research on how to reset after error.
}
@end
