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
@synthesize batteryLevel;
@synthesize type;
@synthesize batteryLvlChar;
@synthesize device;
@synthesize deviceManufacturer;

#pragma mark DeviceConnection protocol methods


-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        device = peripheral;
        [device setDelegate:self];
        type = ACTIVITY_MONITOR;
    }
    return self;
}

-(BOOL)isConnected {

    BOOL result = true;
    if (device == nil || [device state] != CBPeripheralStateConnected) {
        return false;
    }
    return result;
}

-(NSData*) getData {
    
    // This function is not filled out
    
    NSData *results = nil;
    return results;
}

-(void) discoverBatteryLevel {
    
    if ([self isConnected]) {
        NSLog(@"getting battery level");
        
        // perform discovery for the battery
        
        if (batteryLvlChar == nil || batteryService == nil) {
            NSLog(@"discovering battery stuff");
            [device discoverServices:nil];
        } else {
            
            // battery services already discovered, just need to be read
            
            NSLog(@"battery already discovered");
            [device readValueForCharacteristic:batteryLvlChar];
        }
    } else {
        NSLog(@"device not connected");
    }
}

-(NSInteger) type {
    
    return type;
}

-(void) setType:(NSInteger) newType {
    
    self.type = newType;
}

-(NSString*) name {
    
    return [device name];
}

-(NSString*) manufacturer {
    
    return [self deviceManufacturer];
}

-(void) getTableInformation {
    
    [self discoverBatteryLevel];
}

-(void) shouldMonitor:(BOOL)monitor {
    
    if (monitor) {
        [device readValueForCharacteristic:batteryLvlChar];
        //[device setNotifyValue:YES forCharacteristic:<#(CBCharacteristic *)#>]
    } else {
        [device setNotifyValue:NO forCharacteristic:batteryLvlChar];
        //[device setNotifyValue:YES forCharacteristic:<#(CBCharacteristic *)#>]
    }

}

-(BOOL) discoveryComplete {
    
    BOOL result = YES;
    if (batteryLvlChar == nil || batteryService == nil) {
        result = NO;
    }
    return result;
}

#pragma mark ActivityMonitorProtocol methods


-(NSInteger)getActivityLevel {
    
    return RESTING;
}

#pragma mark CBPeripheralDelegate protocol methods


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error != nil) {
        batteryLevel = 0;
    }
    if ([characteristic isEqual:batteryLvlChar]) {
        uint8_t rawBattery = 0;
        [[batteryLvlChar value] getBytes:&rawBattery length:1];
        NSLog(@"Battery read is %d", rawBattery);
        batteryLevel = rawBattery;
    }
    if ([[NSString stringWithFormat:@"%@",[characteristic UUID]] rangeOfString:@"Manufacturer"].location != NSNotFound) {
        deviceManufacturer = [[NSString alloc] initWithData:[characteristic value] encoding:NSUTF8StringEncoding];
        NSLog(@"Manufacturer is %@", deviceManufacturer);
        
    }
    NSNotification *readValueNotification = [[NSNotification alloc] initWithName:DEVICE_READ_VALUE object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:readValueNotification];
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    // figure out the possibilities so that we can handle them.
    
    NSLog(@"discovered services");
    if (error != nil) {
        NSLog(@"Error %@", [error description]);
    }
    for (CBService *service in [peripheral services]) {
        NSLog(@"Service: %@", [service UUID]);
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
        // read manufacturer
        
        if ([currentServiceStr rangeOfString:@"Device Info"].location != NSNotFound) {
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
                NSLog(@"found characterisitic for battery");
                if (batteryLvlChar == nil) {
                    batteryLvlChar = currentChar;
                    [peripheral setNotifyValue:YES forCharacteristic:currentChar];
                }
            }
        }
    }
    if ([[NSString stringWithFormat:@"%@",[service UUID]] rangeOfString:@"Device Info"].location != NSNotFound) {
        for (CBCharacteristic *currentChar in [service characteristics]) {
            if ([[NSString stringWithFormat:@"%@",currentChar] rangeOfString:@"Manufacturer"].location != NSNotFound) {
                [peripheral readValueForCharacteristic:currentChar];
            }
        }
    }
}

@end
