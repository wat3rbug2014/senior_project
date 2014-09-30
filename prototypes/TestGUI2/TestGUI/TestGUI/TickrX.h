//
//  TickrX.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceConnection.h"

@interface TickrX : CBPeripheral <CBPeripheralDelegate, DeviceConnection>

@end
