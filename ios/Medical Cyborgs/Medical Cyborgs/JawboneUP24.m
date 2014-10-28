//
//  Jawbone.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "JawboneUP24.h"

@implementation JawboneUP24

@synthesize updatedBatteryLevel;
@synthesize device;

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
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
    
    return [self.peripheral name];
}

-(void) updateBatteryLevel {
    
    
}

-(void) getTableInformation {
    
    
}
-(void) shouldMonitor: (BOOL) monitor {
    
    
}

@end
