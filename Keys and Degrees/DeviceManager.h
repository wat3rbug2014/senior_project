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

#define TI_TMP_SERVICE @"F000AA00-0451-4000-B000-000000000000"
#define TI_TMP_CHARACTERISTIC_TMP @"F000AA01-0451-4000-B000-000000000000"
#define TI_TMP_CHARACTERISTIC_ON_OFF @"F000AA02-0451-4000-B000-000000000000"

#define TX_PWR_SERVICE @"0x1804"
#define TEMP_SENSOR_SERVICE @"0x1809"



@interface DeviceManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>


@property CBCentralManager *btManager;
@property (strong) BTDeviceInfo *deviceInUse;
@property (strong) NSArray *discoveredDevices;
@property (strong) id managerDelegate;
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
