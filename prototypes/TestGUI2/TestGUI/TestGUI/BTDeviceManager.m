//
//  BTDummyData.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceManager.h"
#import "DummyDevice.h"

@implementation BTDeviceManager

@synthesize heartDevices;
@synthesize activityDevices;
@synthesize selectedIndexForActivityMonitor;
@synthesize selectedIndexForHeartMonitor;
@synthesize heartMonitorIsConnected;
@synthesize activityMonitorIsConnected;
@synthesize heartRate;
@synthesize isActive;

-(id) init {
    
    if (self = [super init]) {
        NSMutableArray *deviceListBuild = [NSMutableArray arrayWithCapacity:DEVICE_NUM];
        for (int i = 0; i < DEVICE_NUM; i++) {
            DummyDevice *temp = [[DummyDevice alloc] init];
            [temp setName: [NSString stringWithFormat:@"Heart Test%d", i]];
            [deviceListBuild addObject:temp];
        }
        heartDevices = deviceListBuild;
        deviceListBuild = [NSMutableArray arrayWithCapacity:DEVICE_NUM];
        for (int i = 0; i < DEVICE_NUM; i++) {
            DummyDevice *temp = [[DummyDevice alloc] init];
            [temp setName: [NSString stringWithFormat:@"Activity Test%d", i]];
            [deviceListBuild addObject:temp];
        }
        activityDevices = deviceListBuild;
    }
    return self;
}

-(NSInteger) discoveredDevicesForType:(NSInteger)type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices count];
    } else {
        return  [activityDevices count];
    }
}

// this should change from id for compile time checks

-(id) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices objectAtIndex:index];
    } else {
        return  [activityDevices objectAtIndex:index];
    }
}

-(NSInteger) receivedHeartRateMeasurement {
    
    if ([self heartRate] < 60) {
        [self setHeartRate:60];
    }
    if ([self heartRate] > 180) {
        [self setHeartRate:60];
    }
    return  [self heartRate];
}

-(BOOL) isActiveMeasurementReceived {
    
    [self setIsActive:![self isActive]];
    return [self isActive];
}

@end
