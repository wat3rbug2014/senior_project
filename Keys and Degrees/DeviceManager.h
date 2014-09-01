//
//  DicoveryController.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDeviceInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>


@property CBCentralManager *btManager;
@property (strong) BTDeviceInfo *deviceInUse;
@property (strong) NSArray *discoveredDevices;
@property NSTimer  *monitoringTimer;
@property (strong) NSArray *selectedDevices;
@property NSNumber *signalStrength;
@property float timeInterval;

-(BTDeviceInfo*) discoveredDeviceAtIndex: (NSInteger) index;
-(NSInteger) discoveredDeviceCount;
-(void) addDevice: (BTDeviceInfo*) newDevice;
-(void) getDeviceUpdates;
-(void) removeDeviceAtIndex: (NSInteger) index;
-(BTDeviceInfo*) selectedDeviceAtIndex: (NSInteger) index;
-(NSInteger) selectedDeviceCount;
-(void) selectDiscoveredDeviceAtIndex: (NSInteger) index;
-(void) startMonitoring;
-(void) startScan;
-(void) stopMonitoring;
-(void) stopScan;

@end
