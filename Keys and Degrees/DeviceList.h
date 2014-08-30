//
//  DeviceList.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDeviceInfo.h"

@interface DeviceList : NSObject

@property (retain) NSArray *devices;

-(NSInteger) count;
-(void) addDevice: (BTDeviceInfo*)device;
-(void) removeDevice: (NSString*)name;
-(void) updateDataStore;
@end
