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

-(id) init {
    
    if (self = [super init]) {
        [self loadDataStore];
    }
    return self;
}

-(NSInteger) count {
    
    return [devices count];
}

-(void) addDevice:(CBPeripheral *)device {
    
    // see if this is the way to change an array -- been a while
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp addObject:device];
    devices = temp;
    [self updateDataStore];
}

-(void) removeDeviceAtIndex: (NSInteger) index {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp removeObjectAtIndex:index];
    devices = temp;
}

-(void) removeDevice:(NSString *)name {
    
    int index = 0;
    for (int i = 0; i < [devices count]; i++) {
        CBPeripheral *currentDevice = [devices objectAtIndex:i];
        if ([[currentDevice name] isEqualToString:name]) {
            index = i;
        }
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:devices];
    [temp removeObjectAtIndex:index];
    devices = temp;
    [self updateDataStore];
}

-(CBPeripheral*) deviceAtIndex:(NSInteger)index {
    
    if (index >= 0 && index < [devices count]) {
        return [devices objectAtIndex:index];
    } else {
        return nil;
    }
}
-(void) useDevices:(NSArray *)newDevices {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:newDevices];
    self.devices = temp;
}

-(void) loadDataStore {
    
    
}

-(void) saveDataStore {
    
    
}

-(void) updateDataStore {
    
    
}
@end
