//
//  TickrX.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "WahooTickrX.h"
#import "DeviceConnection.h"

@implementation WahooTickrX

@synthesize batteryLevel;
@synthesize device;
@synthesize batteryLvlChar;
@synthesize batteryService;

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        device = peripheral;
        device.delegate = self;
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
    
    return self.type;
}

-(void) setType:(NSInteger)type {
    
    self.type = type;
}

-(NSString*) name {
    
    return [device name];
}

-(void) getTableInformation {
    
    
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

-(void) shouldMonitor: (BOOL) monitor {
    
    
}
@end
