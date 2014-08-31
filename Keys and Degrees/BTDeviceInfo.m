//
//  BTDeviceInfo.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceInfo.h"

@implementation BTDeviceInfo

@synthesize temp;
@synthesize deviceID;
@synthesize useTemp;

-(id) initWithDevice:(CBPeripheral *)newDevice {
    
    if (self = [super init]) {
        deviceID = newDevice;
        //[newDevice discoverServices:nil];
    }
    return self;
}
@end
