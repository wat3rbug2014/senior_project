//
//  BTDeviceInfo.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTDeviceInfo : NSObject

@property CBPeripheral *deviceID;
@property int temp;
@property BOOL useTemp;

-(id) initWithDevice:(CBPeripheral*) newDevice;
@end
