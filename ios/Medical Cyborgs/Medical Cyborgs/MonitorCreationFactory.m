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


/*
 * Creates a device object based on the peripheral supplied.  There are a few assumptions.
 * The first assumption is that there is a class for the type of device to be created.  The
 * second assumption is that this method properly identifies the type of device that fits the class
 * and finally that the class is in the import section above this comment.  This method does NOT
 * always produce an object and so a check to see if the return is nil is needed.  This is to
 * prevent the false positives sometimes created from the scanning process.
 *
 * @param peripheral is the device bluetooth device peripheral object that is passed from the device
 *          manager.
 * @return The return is an object of the class that fits in the DeviceConnection protocol.  All devices
 *          must follow the protocol for proper utilization and to prevent runtime crashes.  The return value
 *          must be checked for nil cases.
 **/

+(id<DeviceConnection>) createFromPeripheral: (CBPeripheral*) peripheral {
    
    id result = nil;
    
    // gets rid of dummy items
    
    if ([peripheral name] == nil) {
        return nil;
    }
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
