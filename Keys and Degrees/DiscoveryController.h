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

@interface DiscoveryController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property CBCentralManager *btManager;
@property (strong) NSArray *discoveredDevices;

@end
