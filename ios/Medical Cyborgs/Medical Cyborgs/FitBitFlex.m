//
//  FitBitFlex.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "FitBitFlex.h"

@implementation FitBitFlex

NSString * const FLEX_SERV_UUID = @"45C3";

@synthesize batteryCharacteristic;
@synthesize batteryLvl;
@synthesize type;


-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        type = ACTIVITY_MONITOR;
    }
    return self;
}

#pragma mark DeviceConnection protocol methods

-(BOOL)isConnected {
    
    return ([_peripheral state] == CBPeripheralStateConnected) ? TRUE : FALSE;
}

-(NSData*) getData {
    
    NSData *results = nil;
    
    
    return results;
}

-(NSInteger) batteryLevel {
    
    if ([self isConnected]) {
        if (batteryCharacteristic != nil) {
            [_peripheral readValueForCharacteristic:batteryCharacteristic];
        }
    }
    return batteryLvl;
}

-(NSInteger) type {
    
    return type;
}

-(void) setType:(NSInteger) newType {
    
    self.type = newType;
}

-(NSString*) name {
    
    return [self.peripheral name];
}

#pragma mark CBPeripheralDelegate protocol methods

-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    // default value is 0% if we cannot read the device.
    
    if (error != nil) {
        batteryLvl = 0;
        return;
    }
    // may need to check if that will really be equal
    
    if (characteristic == batteryCharacteristic) {
        
        // translate the data into something usable.
        // update the batteryLvl
    }

}
@end
