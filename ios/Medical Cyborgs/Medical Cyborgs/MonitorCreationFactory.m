//
//  MonitorCreationFactory.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "MonitorCreationFactory.h"
#import "DeviceConnection.h"
#import "FitBitFlex.h"
#import "JawboneUP24.h"
#import "PolarH7.h"
#import "WahooTickrX.h"

@implementation MonitorCreationFactory


+(id<DeviceConnection>) createFromPeripheral: (CBPeripheral*) peripheral {
    
    id result = nil;
    if ([[peripheral name] rangeOfString:@"Flex"].location != NSNotFound) {
        result = [[FitBitFlex alloc] initWithPeripheral:peripheral];
    }
    // The information for these devices is not known yet
    
//    if ([[peripheral name] rangeOfString:@"Jawbone"].location != NSNotFound) {
//        result = [[JawboneUP24 alloc] initWithPeripheral:peripheral];
//    }
//    if ([[peripheral name] rangeOfString:@"Flex"].location != NSNotFound) {
//        result = [[WahooTickrX alloc] initWithPeripheral:peripheral];
//    }
//    if ([[peripheral name] rangeOfString:@"Flex"].location != NSNotFound) {
//        result = [[PolarH7 alloc] initWithPeripheral:peripheral];
//    }
    return result;
}

@end
