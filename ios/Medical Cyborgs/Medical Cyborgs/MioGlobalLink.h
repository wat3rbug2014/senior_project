//
//  MioGlobalLink.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/1/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeartMonitorProtocol.h"
#import "ActivityMonitorProtocol.h"
#import "DeviceCommonInfoInterface.h"

@interface MioGlobalLink : NSObject <DeviceCommonInfoInterface, HeartMonitorProtocol, ActivityMonitorProtocol>

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
