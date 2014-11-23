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

/**
 * The device type as an enum of DeviceType.  See DeviceTypes.h for details.
 */

@property NSInteger type;


/**
 * The CBService reference for use in detecting the battery level of the device.
 */

@property (retain) CBService *batteryService;


/**
 * The CBCharacteristic reference for use in reading the battery level of the device.
 */

@property (retain) CBCharacteristic *batteryLvlChar;

/**
 * The CBService reference for use in reading the heart rate detected by the device.
 */

@property (retain) CBService *heartRateService;


/**
 * The CBCharacteristic reference for use in reading the heart rate value from the device.
 */

@property (retain) CBCharacteristic *heartRateChar;


/**
 * The last known integer value of the battery percentage.  The default is 0 if the battery level is not
 * read.
 */

@property int batteryLevel;


/**
 * The CBPeripheral device that was discovered and used with this class.
 */

@property (retain) CBPeripheral *device;


/**
 * The NSString value of the manufacturer as read from the device.
 */

@property (retain) NSString *deviceManufacturer;


/**
 * The value of the last heart rate that was read.  Default is 0 if the heart rate has not been acquired.
 */

@property NSInteger currentHeartRate;

@end
