//
//  DeviceList.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDeviceInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceList : NSObject

@property (retain) NSArray *devices;

-(void) addDevice: (CBPeripheral*)device;
-(NSInteger) count;
-(BTDeviceInfo*) deviceAtIndex: (NSInteger) index;
-(void) loadDataStore;
-(void) removeDevice: (NSString*)name;
-(void) removeDeviceAtIndex: (NSInteger) index;
-(void) saveDataStore;
-(void) updateDataStore;
-(void) useDevices: (NSArray*) newDevices;

@end
