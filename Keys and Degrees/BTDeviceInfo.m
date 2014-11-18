//
//  BTDeviceInfo.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceInfo.h"

@implementation BTDeviceInfo

@synthesize deviceID;
@synthesize temp;
@synthesize useTemp;

-(id) initWithDevice:(CBPeripheral *)newDevice {
    
    if (self = [super init]) {
        deviceID = newDevice;
    }
    return self;
}
@end
