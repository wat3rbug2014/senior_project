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
            NSLog(@"Location service denied");
            locationAllowed = NO;
        } else {
            NSLog(@"Location service allowed");
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
        
        patient = [[PersonalInfo alloc] init];
        deviceManager = [BTDeviceManager sharedManager];
        database = [[DBManager alloc] initWithpatientID:[patient patientID]];
        if ([patient dob] != nil) {
            [database setAge:[patient age]];
        }
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
    [locationManager startMonitoringSignificantLocationChanges];
    [self performScan];
}

-(void)stopMonitoring {
    
    [locationManager stopMonitoringSignificantLocationChanges];
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
    
    NSLog(@"location update happened");
    CLLocation *currentLocation = [locations objectAtIndex: [locations count] - 1];
    [database setLongitude:[currentLocation coordinate].longitude];
    [database setLatitude:[currentLocation coordinate].latitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Show a log entry for failure for now");
    // not sure what to do at this moment.  Database will be using last recording
    // and I haven't done research on how to reset after error.
}
@end
