//
//  DicoveryController.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DiscoveryController.h"

@implementation DiscoveryController


-(id) init {
    
    if (self = [super init]) {
        discoveredDevices = nil;
        // fix this to scan for temperature and proximity options
        
        btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        
    }
    return self;
}

@synthesize discoveredDevices;
@synthesize btManager;

-(BTDeviceInfo*) getDeviceAtIndex: (NSUInteger) index {
    
    BTDeviceInfo *currentDevice = [[BTDeviceInfo alloc] init];
    // some code to
    return currentDevice;
}

-(void) dealloc {
    
    if ([btManager state] == CBCentralManagerStateUnknown || [btManager state] == CBCentralManagerStatePoweredOn || [btManager state] == CBCentralManagerStateResetting) {
        [btManager stopScan];
        NSLog(@"Scanning stopped");
    }
}

#pragma mark -
#pragma CBCentralManagerDelegate Protocol methods

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        [btManager scanForPeripheralsWithServices:nil options:nil];
        NSLog(@"Starting scan...");
    }
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([peripheral name] != NULL) {
        NSMutableArray *existingDiscoveredDevices = [NSMutableArray arrayWithArray:discoveredDevices];
        [existingDiscoveredDevices addObject:peripheral];
        NSLog(@"Discovered %@", [peripheral name]);
        discoveredDevices = existingDiscoveredDevices;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BTDiscoveryChange" object:self];

    }
}

@end
