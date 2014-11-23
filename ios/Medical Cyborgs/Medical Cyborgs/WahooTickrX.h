//
//  TickrX.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This class is for the Wahoo Tickr X chest device.  Device specific UUIDs for services
 * and characteristics are here along with the execution path to obtain the desired data for the
 * application.  Service and Characteristic UUIDs are defined in this header instead of gobally in
 * an effort to reduce mental noise when reading the code.  The CBPeripheralDelegate is implemented
 * so that the class can perform all the operations needed to maintain connection status and
 * retrieval of the data.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceCommonInfoInterface.h"
#import "HeartMonitorProtocol.h"

@interface WahooTickrX : NSObject <DeviceCommonInfoInterface, HeartMonitorProtocol>

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
