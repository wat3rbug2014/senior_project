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


-(id) initWithDataStore:(DBManager *)dataStore andDevicemanager:(BTDeviceManager *)newDeviceManager {
    
    if (self = [super init]) {
        deviceManager = newDeviceManager;
        database = dataStore;
        patientID = [database patientID];
        ableToPoll = YES;
        batteryAlertGiven = NO;
        isHeartMonitorReady = NO;
        isActivityMonitorReady = NO;
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
    //[deviceManager connectMonitors];
    [self continuePollAfterDevicesConnect]; // remove after test
}

-(void)didReceiveNotificationDeviceConnected:(NSNotification *)notification {
  
//    id connectDevice = [notification object];
//    
//    // if object is not a device it means it failed
//    
//    if (![connectDevice conformsToProtocol: @protocol(DeviceConnection) ]) {
//        NSLog(@"The fail portion is caught here.\nStopping poll");
//        return;
//    }
//    // determine heart or activity and flag appropriate one is connected
//    
//    if ([[notification object] conformsToProtocol: @protocol(HeartMonitorProtocol)]) {
//        [self setIsHeartMonitorReady:YES];
//        [self setHeartMonitor:[notification object]];
//        NSLog(@"heart monitor connected\nContinue polling");
//    } else {
//        [self setActivityMonitor:[notification object]];
//        [self setIsActivityMonitorReady:YES];
//        NSLog(@"activity monitor connected\nContinue polling");
//    }
    [self continuePollAfterDevicesConnect];
}

-(void)continuePollAfterDevicesConnect {
    
    // make sure both are connected before polling proceeds
    
//    if (![self isHeartMonitorReady]) {
//        NSLog(@"heart monitor is not ready\nStopping poll");
//        return;
//    }
//    if (![self isActivityMonitorReady]) {
//        NSLog(@"activity monitor is not ready\nStopping poll");
//        return;
//    }
    DummyData *testData = [[DummyData alloc] init];
    NSLog(@"getting data from heart monitor");
    //NSInteger heartRate = (NSInteger)[heartMonitor getHeartRate];
    NSInteger heartRate = [testData heartRate];

    NSLog(@"getting data from activity monitor");

    //float latitude = [activityMonitor getLatitude];
    float latitude = [testData latitude];
    //float longitude = [activityMonitor getLongitude];
    float longitude = [testData longitude];
    
    
    NSLog(@"storing data in database");
    
    [database setHrmeasurement:heartRate];
    [database setLatitude:latitude];
    [database setLongitude:longitude];
    [database setTimestamp:[NSDate date]];
    [database insertDataIntoDB];
    
    NSLog(@"finished poll");
}
@end
