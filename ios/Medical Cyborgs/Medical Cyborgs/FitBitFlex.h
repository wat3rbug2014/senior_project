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

@interface FitBitFlex : NSObject <DeviceCommonInfoInterface, CBPeripheralDelegate, ActivityMonitorProtocol>

@property (retain, strong) CBPeripheral *device;
@property (retain) CBService *batteryService;
@property (retain) CBCharacteristic *batteryLvlChar;
@property int batteryLevel;
@property NSInteger type;
@property (retain) NSString *deviceManufacturer;

@end
