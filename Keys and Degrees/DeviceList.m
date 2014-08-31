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

#pragma mark -
#pragma Super class methods


-(id) init {
    
    if (self = [super init]) {
        [self loadDataStore];
    }
    return self;
}

#pragma mark -
#pragma mark Custom methods


-(void) addDevice:(CBPeripheral *)device {
    
    BTDeviceInfo *newDevice = [[BTDeviceInfo alloc] initWithDevice:device];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp addObject:newDevice];
    devices = temp;
    [self updateDataStore];
}

-(NSInteger) count {
    
    return [devices count];
}

-(BTDeviceInfo*) deviceAtIndex:(NSInteger)index {
    
    if (index >= 0 && index < [devices count]) {
        return [devices objectAtIndex:index];
    } else {
        return nil;
    }
}

-(void) loadDataStore {
    
    
}

-(void) removeDevice:(NSString *)name {
    
    int index = 0;
    for (int i = 0; i < [devices count]; i++) {
        BTDeviceInfo *currentDevice = [devices objectAtIndex:i];
        if ([[currentDevice deviceID].name isEqualToString:name]) {
            index = i;
        }
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp removeObjectAtIndex:index];
    devices = temp;
    [self updateDataStore];
}

-(void) removeDeviceAtIndex: (NSInteger) index {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp removeObjectAtIndex:index];
    devices = temp;
}

-(void) saveDataStore {
    
    
}

-(void) updateDataStore {
    
    
}

-(void) useDevices:(NSArray *)newDevices {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:newDevices];
    self.devices = temp;
}

@end
