//
//  DevicePollManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/20/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DevicePollManager.h"

@implementation DevicePollManager

@synthesize database;
@synthesize heartMonitor;
@synthesize activityMonitor;
@synthesize patientInfo;
@synthesize patientID;


-(id) initWithDataStore:(NSData *)dataStore heartMonitor:(id)newHeartMonitor activityMonitor:(id)newActivityMonitor {
    
    if (self = [super init]) {
        heartMonitor = newHeartMonitor;
        activityMonitor = newActivityMonitor;
        database = dataStore;
        patientInfo = [[PersonalInfo alloc] init];
        patientID = (NSInteger)[patientInfo patientID]; // make sure this works
    }
    return self;
}

-(void) pollDevicesForData {
    
    // getting setup information

    NSLog(@"verifying input before poll");
    if (heartMonitor == nil || activityMonitor == nil || database == nil) {
        return;
    }
    // check the patient id, if bad retrieve it again and then check
    
    if (patientID == NO_ID_SET) {
        [patientInfo loadInformation];
        patientID = (NSInteger)[patientInfo patientID];
        if (patientID == NO_ID_SET) {
            
            // post a notification or something that we cannot monitor because patient info
            // is not set
            
            return;
        }
    }
    // get device data
    
    NSLog(@"getting data from heart monitor");
    NSInteger heartRate = [heartMonitor getHeartRate];
    NSLog(@"getting data from activity monitor");
    NSData *activityData = [activityMonitor getData];
    
    // setup insert statement to local store
    
    NSLog(@"storing data in database");
    
    
    // getting battery level
    
    NSLog(@"getting battery levels");
    [heartMonitor updateBatteryLevel];
    [activityMonitor updateBatteryLevel];
    if([heartMonitor updatedBatteryLevel] < 20 && [heartMonitor updatedBatteryLevel] !=  NO_BATTERY_VALUE) {
        NSLog(@"posting notification for heart monitor");
        NSNotification *batteryNotification =
            [NSNotification notificationWithName:BATTERY_LOW_NOTIFCATION_STR object:heartMonitor userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:batteryNotification];
    }
    if ([activityMonitor updatedBatteryLevel] < 20 && [activityMonitor updatedBatteryLevel] != NO_BATTERY_VALUE) {
        NSLog(@"posting notification for activity monitor");
        NSNotification *batteryNotification =
            [NSNotification notificationWithName:BATTERY_LOW_NOTIFCATION_STR object:activityMonitor userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:batteryNotification];
    }
    NSLog(@"finished poll");
}
@end