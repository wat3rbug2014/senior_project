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

-(id) init {
    
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    self = (FitBitFlex*)peripheral;
    self.delegate = self;
    return self;
}

#pragma mark DeviceConnection protocol methods

-(BOOL)isConnected {
    
    return ([super state] == CBPeripheralStateConnected) ? TRUE : FALSE;
}

-(NSData*) getData {
    
    NSData *results = nil;
    
    
    return results;
}

-(NSInteger) batteryLevel {
    
    if (batteryCharacteristic != nil) {
        [super readValueForCharacteristic:batteryCharacteristic];
    }
    return batteryLvl;
}

-(NSInteger) type {
    
    return self.type;
}

-(void) setType:(NSInteger)type {
    
    self.type = type;
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
