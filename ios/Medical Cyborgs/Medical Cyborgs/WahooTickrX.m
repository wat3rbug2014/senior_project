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

-(id) initWithPeripheral: (CBPeripheral*) peripheral {
    
    if (self = [super init]) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
    }
    return self;
}

-(BOOL)isConnected {
    
    return ([_peripheral state] == CBPeripheralStateConnected) ? TRUE : FALSE;
}

-(NSData*) getData {
    
    NSData *results = nil;
    
    
    return results;
}

-(NSInteger) batteryLevel {
    
    return 100;
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

@end
