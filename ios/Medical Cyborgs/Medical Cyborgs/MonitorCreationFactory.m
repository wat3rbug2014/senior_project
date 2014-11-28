//
//  MonitorCreationFactory.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This class is a device object factory to centralize creation and reduce
 * dependency complexities as much as possible.
 */
#import "MonitorCreationFactory.h"
#import "DeviceCommonInfoInterface.h"
#import "FitBitFlex.h"
#import "PolarH7.h"
#import "WahooTickrX.h"
#import "MioGlobalLink.h"
#import "JawboneUP24.h"

@implementation MonitorCreationFactory


+(id<DeviceCommonInfoInterface>) createFromPeripheral: (CBPeripheral*) peripheral {
    
    id result = nil;
    
    if ([peripheral name] == nil) {
        return nil;
    }
    if ([[peripheral name] rangeOfString:@"Flex"].location != NSNotFound) {
        result = [[FitBitFlex alloc] initWithPeripheral:peripheral];
    }
    if ([[peripheral name] rangeOfString:@"TICKR"].location != NSNotFound) {
        result = [[WahooTickrX alloc] initWithPeripheral:peripheral];
    }
    if ([[peripheral name] rangeOfString:@"MIO"].location!= NSNotFound) {
        result = [[MioGlobalLink alloc] initWithPeripheral:peripheral];
    }
    if ([[peripheral name] rangeOfString:@"Polar H7"].location != NSNotFound) {
        result = [[PolarH7 alloc] initWithPeripheral:peripheral];
    }
    if ([[peripheral name] rangeOfString:@"UP24"].location != NSNotFound) {
        result = [[JawboneUP24 alloc] initWithPeripheral:peripheral];
    }
    return result;
}

@end
