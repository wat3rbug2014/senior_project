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

@synthesize batteryService;
@synthesize batteryLvl;
@synthesize type;
@synthesize batteryLvlChar;

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        type = ACTIVITY_MONITOR;
        NSLog(@"Scanning services");
        [self.peripheral discoverServices:nil];
    }
    return self;
}

#pragma mark DeviceConnection protocol methods


-(BOOL)isConnected {
    
    return ([_peripheral state] == CBPeripheralStateConnected) ? TRUE : FALSE;
}

-(NSData*) getData {
    
    // This function is not filled out
    
    NSData *results = nil;
    return results;
}

-(NSInteger) batteryLevel {
    
    // This method needs to be thought out.  There is device response lag which will
    // give inaccurate readings.
    
    if ([self isConnected]) {
        if (batteryService != nil) {
            
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

-(NSString*) manufacturer {
    
    return nil;
}

#pragma mark CBPeripheralDelegate protocol methods


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error != nil) {
        batteryLvl = 0;
        return;
    }
    if ([characteristic isEqual:batteryLvlChar]) {
        uint8_t rawBattery = 0;
        [[batteryLvlChar value] getBytes:&rawBattery length:1];
        NSLog(@"Battery read is %d", rawBattery);
        [self setBatteryLvl:(NSInteger) [NSNumber numberWithInt:rawBattery]];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    // figure out the possibilities so that we can handle them.
    
    if (error != nil) {
        NSLog(@"Error %@", [error description]);
    }
    for (CBService *service in [peripheral services]) {
        NSLog(@"Discovered %@", [service UUID]);
    }
    for (CBService *currentService in [peripheral services]) {
        NSString *currentServiceStr = [NSString stringWithFormat:@"%@",[currentService UUID]];
        
        // check for battery level
        
        if ([currentServiceStr rangeOfString:BATTERY].location != NSNotFound) {
            if (batteryService == nil) {
                batteryService = currentService;
            }
            [peripheral discoverCharacteristics:nil forService:currentService];
        }
        // do the other services also
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    // figure out the possibilities so that we can handle them.
    
    if (error != nil) {
        NSLog(@"Error %@", [error description]);
    }
    if ([service isEqual:batteryService]) {
        for (CBCharacteristic *currentChar in [service characteristics]) {
            NSString *currentCharStr = [NSString stringWithFormat:@"%@", [currentChar UUID]];
            if ([currentCharStr rangeOfString:BATTERY_LVL].location != NSNotFound) {
                if (batteryLvlChar == nil) {
                    batteryLvlChar = currentChar;
                }
                [peripheral readValueForCharacteristic:currentChar];
            }
        }
    }
}

@end
