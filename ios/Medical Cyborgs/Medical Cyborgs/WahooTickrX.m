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

@synthesize updatedBatteryLevel;
@synthesize device;

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        device = peripheral;
        device.delegate = self;
    }
    return self;
}

-(BOOL)isConnected {
    
    return ([device state] == CBPeripheralStateConnected) ? TRUE : FALSE;
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

-(void) updateBatteryLevel {
    
    
}

@end
