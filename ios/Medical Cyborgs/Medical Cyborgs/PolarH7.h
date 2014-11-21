//
//  PolarH7.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This class is for the Polar H7 wristband device.  The CBPeripheralDelegate is implemented
 * so that the class can perform all the operations needed to maintain connection status and
 * retrieval of the data.  Data retrieveal is dependent on the device type so these methods
 * are defined in this file to account for endianness and data type size as well as possible
 * UUID differences.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceCommonInfoInterface.h"
#import "DeviceTypes.h"
#import "HeartMonitorProtocol.h"



@interface PolarH7 : NSObject <DeviceCommonInfoInterface, HeartMonitorProtocol>

@property NSInteger type;
@property (retain) CBService *batteryService;
@property (retain) CBCharacteristic *batteryLvlChar;
@property (retain) CBService *heartRateService;
@property (retain) CBCharacteristic *heartRateChar;
@property int batteryLevel;
@property (retain) CBPeripheral *device;
@property (retain) NSString *deviceManufacturer;
@property NSInteger currentHeartRate;

@end
