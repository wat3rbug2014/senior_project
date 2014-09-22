//
//  BTDummyData.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DummyDevice.h"

#define DEVICE_NUM 3
#define HEART_MONITOR 1
#define ACTIVITY_MONITOR 2

@interface BTDeviceManager : NSObject


@property NSArray *heartDevices;
@property NSArray *activityDevices;
@property NSInteger selectedIndexForHeartMonitor;
@property NSInteger selectedIndexForActivityMonitor;
@property BOOL heartMonitorIsConnected;
@property BOOL activityMonitorIsConnected;
@property NSInteger heartRate;
@property BOOL isActive;

-(NSInteger) discoveredDevicesForType: (NSInteger) type;
-(id) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type;

-(NSInteger) receivedHeartRateMeasurement;
-(BOOL) isActiveMeasurementReceived;

@end
