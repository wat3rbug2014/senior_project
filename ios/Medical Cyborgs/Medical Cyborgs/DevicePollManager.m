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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotificationDeviceConnected) name: BTHeartConnected object:deviceManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotificationDeviceConnected) name: BTActivityConnected object:deviceManager];
    }
    return self;
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) stopMonitoring {
    
    [deviceManager disconnectDevicesForType:HEART_MONITOR];
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

-(void)didReceiveNotificationDeviceConnected {
  
    // determine heart or activity and flag appropriate one is connected
    
    heartMonitor = [[deviceManager heartDevices] objectAtIndex:
                    [deviceManager selectedIndexForHeartMonitor]];
    activityMonitor = [[deviceManager activityDevices] objectAtIndex:
                       [deviceManager selectedIndexForActivityMonitor]];
    if ([heartMonitor isConnected]) {
        [self setIsHeartMonitorReady:YES];
        NSLog(@"heart monitor connected\nContinue polling");
        [heartMonitor shouldMonitor:YES];
    }
    if ([activityMonitor isConnected]) {
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
