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
@synthesize updatedBatteryLevel;

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        device = peripheral;
        [device setDelegate:self];
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

-(void) updateBatteryLevel {
    
    
}

-(void) getTableInformation {
    
    
}

@end
