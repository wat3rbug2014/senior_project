//
//  DeviceList.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DeviceList.h"

@implementation DeviceList

@synthesize devices;

-(NSInteger) count {
    
    return [devices count];
}

-(void) addDevice:(BTDeviceInfo *)device {
    
    // see if this is the way to change an array -- been a while
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp addObject:device];
    devices = temp;
    [self updateDataStore];
}

-(void) removeDevice:(NSString *)name {
    
    int index = 0;
    for (int i = 0; i < [devices count]; i++) {
        BTDeviceInfo *currentDevice = [devices objectAtIndex:i];
        if ([[currentDevice name] isEqualToString:name]) {
            index = i;
        }
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp removeObjectAtIndex:index];
    devices = temp;
    [self updateDataStore];
}

-(void) updateDataStore {
    
    
}
@end
