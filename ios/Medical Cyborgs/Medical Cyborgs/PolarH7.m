//
//  PolarH7.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "PolarH7.h"

@implementation PolarH7

@synthesize device;
@synthesize batteryService;
@synthesize batteryLvlChar;
@synthesize heartRateChar;
@synthesize heartRateService;
@synthesize batteryLevel;
@synthesize deviceManufacturer;
@synthesize type;
@synthesize currentHeartRate;




#pragma mark - DeviceCommonInfoInterface methods


-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        device = peripheral;
        [device setDelegate:self];
        type = HEART_MONITOR;
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
    
    NSData *results = nil;
    
    
    return results;
}

-(NSInteger) type {
    
    return type;
}

-(void) setType:(NSInteger)newType {
    
    type = newType;
}

-(NSString*) name {
    
    return [device name];
}

-(NSString*) manufacturer {
    
    return [self deviceManufacturer];
}

-(void) discoverBatteryLevel {
    
    if ([self isConnected]) {
        NSLog(@"%@ getting battery level", [device name]);
        
        // perform discovery for the battery
        
        if (batteryLvlChar == nil || batteryService == nil) {
            NSLog(@"%@ discovering battery stuff", [device name]);
            [device discoverServices:nil];
        } else {
            
            // battery services already discovered, just need to be read
            
            NSLog(@"%@ battery already discovered", [device name]);
            [device readValueForCharacteristic:batteryLvlChar];
        }
    } else {
        NSLog(@"%@ not connected", [device name]);
    }
}

-(void) getTableInformation {
    
    [self discoverBatteryLevel];
}

-(void) shouldMonitor:(BOOL)monitor {
    
    if (monitor) {
        [device setNotifyValue:YES forCharacteristic:heartRateChar];
    } else {
        [device setNotifyValue:NO forCharacteristic:heartRateChar];
    }
}

-(BOOL) discoveryComplete {
    
    BOOL result = YES;
    if (heartRateChar == nil || heartRateService == nil) {
        result = NO;
    }
    if (batteryLvlChar == nil || batteryService == nil) {
        result = NO;
    }
    return result;
}

#pragma mark - HeartMonitorProtocol methods


-(NSInteger) getHeartRate {
    
    return currentHeartRate;
}

#pragma mark  - CBPeripheralDelegate methods


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error != nil) {
        batteryLevel = 0;
    }
    // read heart rate
    
    if ([characteristic isEqual:heartRateChar]) {
        NSData *heartData = [heartRateChar value];
        const uint8_t *heartReg = [heartData bytes];
        uint16_t bpm = 0;
        if ((heartReg[0] & 0x01) == 0) {
            bpm = heartReg[1];
        } else {
            bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&heartReg[1]));
        }
        currentHeartRate = (NSInteger)bpm;
        NSLog(@"Current heart rate: %d", (int) currentHeartRate);
    }
    // read battery level
    
    if ([characteristic isEqual:batteryLvlChar]) {
        uint8_t rawBattery = 0;
        [[batteryLvlChar value] getBytes:&rawBattery length:1];
        NSLog(@"%@ Battery read is %d", [device name], rawBattery);
        batteryLevel = rawBattery;
    }
    // read manufacturer
    
    if ([[NSString stringWithFormat:@"%@",[characteristic UUID]] rangeOfString:@"Manufacturer"].location != NSNotFound) {
        deviceManufacturer = [[NSString alloc] initWithData:[characteristic value] encoding:NSUTF8StringEncoding];
        NSLog(@"Manufacturer is %@", deviceManufacturer);
        
    }
    NSNotification *readValueNotification = [[NSNotification alloc] initWithName:DEVICE_READ_VALUE object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:readValueNotification];
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    // figure out the possibilities so that we can handle them.
    
    NSLog(@"%@ discovered services", [peripheral name]);
    if (error != nil) {
        NSLog(@"Error %@", [error description]);
    }
    for (CBService *service in [peripheral services]) {
        NSLog(@"%@ Service: %@", [peripheral name], [service UUID]);
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
        // read heart rate
        
        if ([currentServiceStr rangeOfString:@"Heart Rate"].location != NSNotFound) {
            if (heartRateService == nil) {
                NSLog(@"checking heart rate");
                heartRateService = currentService;
            }
            [peripheral discoverCharacteristics:nil forService:currentService];
        }
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
                NSLog(@"%@: found characteristic for battery", [device name]);
                if (batteryLvlChar == nil) {
                    batteryLvlChar = currentChar;
                    [peripheral readValueForCharacteristic:currentChar];
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
    if ([service isEqual:heartRateService]) {
        for (CBCharacteristic *currentChar in [service characteristics]) {
            NSString *currentCharStr = [NSString stringWithFormat:@"%@", [currentChar UUID]];
            if ([currentCharStr rangeOfString:POLARH7_HRM_UUID].location != NSNotFound) {
                NSLog(@"found heart rate characteristic and reading...");
                if (heartRateChar == nil) {
                    heartRateChar = currentChar;
                    [peripheral setNotifyValue:YES forCharacteristic:currentChar];
                }
            }
        }
    }
    NSLog(@"characteristic is %@", [service UUID]);
}

@end
