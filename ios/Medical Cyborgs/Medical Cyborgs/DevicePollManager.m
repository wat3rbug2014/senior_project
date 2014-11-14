//
//  DevicePollManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/20/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DevicePollManager.h"
#import "DummyData.h"
#import "HeartMonitorProtocol.h"

@implementation DevicePollManager

@synthesize database;
@synthesize deviceManager;
@synthesize patientInfo;
@synthesize patientID;
@synthesize ableToPoll;
@synthesize heartMonitor;
@synthesize activityMonitor;
@synthesize batteryAlertGiven;
@synthesize isActivityMonitorReady;
@synthesize isHeartMonitorReady;
@synthesize currentHeartRate;


-(id) initWithDataStore:(DBManager *)dataStore andDevicemanager:(BTDeviceManager *)newDeviceManager {
    
    if (dataStore == nil || newDeviceManager == nil) {
        return nil;
    }
    if (self = [super init]) {
        deviceManager = newDeviceManager;
        database = dataStore;
        patientID = [database patientID];
        ableToPoll = YES;
        batteryAlertGiven = NO;
        isHeartMonitorReady = NO;
        isActivityMonitorReady = NO;
        heartMonitor = [[deviceManager heartDevices] objectAtIndex:[deviceManager selectedIndexForHeartMonitor]];
        activityMonitor = [[deviceManager activityDevices] objectAtIndex:[deviceManager selectedIndexForActivityMonitor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotificationDeviceConnected:) name:@"HeartMonConnected" object:deviceManager];
    }
    return self;
}

-(void) pollDevicesForData {
    
    NSLog(@"verifying input before poll");
    if ([self patientID] == NO_ID_SET) {
        NSLog(@"No patient ID\nPolling stopped");
        return;
    }
    [database setPatientID:patientID];
    if (![heartMonitor isConnected]) {
        NSLog(@"Device poller attempt to connect to devices");
        [deviceManager connectMonitors];
        return;
    }
    NSLog(@"Device poller already has connected devices");
    
    NSLog(@"getting data from heart monitor");
    currentHeartRate = (int)[heartMonitor getHeartRate];
    
    NSLog(@"getting data from activity monitor");
    
    
    
    
    NSLog(@"storing data in database");
    
    [database setHrmeasurement:currentHeartRate];
    
    // check this
    
    [database setActivityLevel:[self activityLevelBasedOnHeartRate:currentHeartRate]];
    
    // end of check portion
    
    [database setTimestamp:[NSDate date]];
    [database insertDataIntoDB];
    
    NSLog(@"finished poll");
}

-(void)didReceiveNotificationDeviceConnected:(NSNotification *)notification {
  
    id connectDevice = [notification object];
    
    // if object is not a device it means it failed
    
    if (![connectDevice conformsToProtocol: @protocol(DeviceCommonInfoInterface) ]) {
        NSLog(@"The fail portion is caught here.\nStopping poll");
        return;
    }
    // determine heart or activity and flag appropriate one is connected
    
    if ([[notification object] conformsToProtocol: @protocol(HeartMonitorProtocol)]) {
        [self setIsHeartMonitorReady:YES];
        [self setHeartMonitor:[notification object]];
        NSLog(@"heart monitor connected\nContinue polling");
        [heartMonitor shouldMonitor:YES];
    }
    if ([[notification object] conformsToProtocol: @protocol(ActivityMonitorProtocol)]) {
        [self setActivityMonitor:[notification object]];
        [self setIsActivityMonitorReady:YES];
        NSLog(@"activity monitor connected\nContinue polling");
        [activityMonitor shouldMonitor:YES];
    }
}

-(int) activityLevelBasedOnHeartRate: (NSInteger) heartRate {
    
    int result = 0;
    NSInteger mhr = 208 - ((NSInteger)(.7 * [database age]));
    float percentOfMax = ((float)heartRate/ (float)mhr);
    if (percentOfMax < 0.4) {
        result =  SLEEPING;
    }
    if (percentOfMax >= 0.4 && percentOfMax < 0.5) {
        result = TROUBLE_SLEEP;
    }
    if (percentOfMax >= 0.5 && percentOfMax < 0.6) {
        result = TRAVEL;
    }
    if (percentOfMax >= 0.6) {
        result = ACTIVE;
    }
    return result;
}
@end
