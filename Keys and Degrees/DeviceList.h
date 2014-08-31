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

-(NSInteger) count;
-(void) addDevice: (CBPeripheral*)device;
-(void) useDevices: (NSArray*) newDevices;
-(void) removeDevice: (NSString*)name;
-(CBPeripheral*) deviceAtIndex: (NSInteger) index;
-(void) updateDataStore;
-(void) loadDataStore;
-(void) saveDataStore;
-(void) removeDeviceAtIndex: (NSInteger) index;
@end
