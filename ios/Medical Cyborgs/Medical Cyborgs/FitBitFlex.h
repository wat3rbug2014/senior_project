//
//  FitBitFlex.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This class is for the FitBit Flex wristband device.  Device specific UUIDs for services
 * and characteristics are here along with the execution path to obtain the desired data for the
 * application.  Service and Characteristic UUIDs are defined in this header instead of gobally in
 * an effort to reduce mental noise when reading the code.  The CBPeripheralDelegate is implemented
 * so that the class can perform all the operations needed to maintain connection status and 
 * retrieval of the data.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceCommonInfoInterface.h"
#import "DeviceTypes.h"
#import "ActivityMonitorProtocol.h"

extern NSString * const FLEX_SERV_UUID;

@interface FitBitFlex : NSObject <DeviceCommonInfoInterface, ActivityMonitorProtocol>


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



@end
