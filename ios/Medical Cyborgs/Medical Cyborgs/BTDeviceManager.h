//
//  BTDummyData.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FitBitFlex.h"
#import "JawboneUP24.h"
#import "PolarH7.h"
#import "WahooTickrX.h"
#import "DeviceTypes.h"

#define DEVICE_NUM 3


@interface BTDeviceManager : NSObject <CBCentralManagerDelegate>


@property NSArray *heartDevices;
@property NSArray *activityDevices;
@property NSInteger selectedIndexForHeartMonitor;
@property NSInteger selectedIndexForActivityMonitor;
@property BOOL heartMonitorIsConnected;
@property BOOL activityMonitorIsConnected;
@property BOOL isActive;
@property NSInteger searchType;
@property (retain) CBCentralManager *manager;

-(NSInteger) discoveredDevicesForType: (NSInteger) type;
-(id) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type;

-(BOOL) isActiveMeasurementReceived;
-(void) discoverDevicesForType: (NSInteger) type;
-(void) stopScan;
-(void) disconnectDevicesForType: (NSInteger) type;

@end
