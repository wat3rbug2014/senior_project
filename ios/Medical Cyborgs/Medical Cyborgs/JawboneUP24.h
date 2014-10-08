//
//  Jawbone.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/*
 * This class is for the Jawbone UP24 wristband device.  Device specific UUIDs for services
 * and characteristics are here along with the execution path to obtain the desired data for the
 * application.  Service and Characteristic UUIDs are defined in this header instead of gobally in
 * an effort to reduce mental noise when reading the code.  The CBPeripheralDelegate is implemented
 * so that the class can perform all the operations needed to maintain connection status and
 * retrieval of the data.
 **/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceConnection.h"

@interface JawboneUP24 : NSObject <DeviceConnection>

@property NSInteger type;
@property (retain) CBPeripheral *device;
@property NSInteger updatedBatteryLevel;
@property (retain) CBPeripheral *peripheral;

@end
