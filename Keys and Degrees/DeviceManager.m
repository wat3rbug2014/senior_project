//
//  DicoveryController.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

@synthesize btManager;
@synthesize deviceInUse;
@synthesize discoveredDevices;
@synthesize selectedDevices;
@synthesize state;

#pragma mark -
#pragma mark Super class methods


-(id) init {
    
    if (self = [super init]) {
        discoveredDevices = nil;
        
        // Custom initialization
        // load core data
        // get devices already saved
    }
    return self;
}

-(void) dealloc {
    
    if ([btManager state] == CBCentralManagerStateUnknown || [btManager state] == CBCentralManagerStatePoweredOn || [btManager state] == CBCentralManagerStateResetting) {
        [btManager stopScan];
        btManager = nil;
        NSLog(@"Scanning stopped");
    }
}

#pragma mark -
#pragma CBCentralManagerDelegate Protocol methods


-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if ([central state] == CBCentralManagerStatePoweredOn) { // may need check to see if in discovery mode or regular
        [btManager scanForPeripheralsWithServices:nil options:nil];
        state = DMscanning;
        NSLog(@"Starting scan...");
    }
    if ([central state] == CBCentralManagerStatePoweredOff || [central state] == CBCentralManagerStateResetting) {
        NSLog(@"Lost the manager...");
        state = DMnotInUse;
    }
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if ([peripheral name] != NULL) {
        NSMutableArray *existingDiscoveredDevices = [NSMutableArray arrayWithArray:discoveredDevices];
        BTDeviceInfo *newDevice = [[BTDeviceInfo alloc] initWithDevice:peripheral];
        [existingDiscoveredDevices addObject:newDevice];
        NSLog(@"Discovered %@", [peripheral name]);
        discoveredDevices = existingDiscoveredDevices;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BTDiscoveryChange" object:self];
    }
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Connected to %@", [peripheral name]);
    [peripheral setDelegate:self];
    
    // fix this so name and temp guage will be checked
    
    CBUUID *tempSrvID = [CBUUID UUIDWithString:@"0008"];
    [peripheral discoverServices:[NSArray arrayWithObject: tempSrvID]];
}

#pragma mark -
#pragma mark CBPeripheral methods


-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in [peripheral services]) {
        NSLog(@"Discovered %@", service);
    }
}

#pragma mark -
#pragma mark Custom methods


-(void) addDevice:(BTDeviceInfo *)newDevice {
    
    NSMutableArray *buffer = [NSMutableArray arrayWithArray:selectedDevices];
    [buffer addObject:newDevice];
    selectedDevices = buffer;
}

-(BTDeviceInfo*) discoveredDeviceAtIndex: (NSInteger) index {
    
    return [discoveredDevices objectAtIndex:index];
}

-(NSInteger) discoveredDeviceCount {
    
    return [discoveredDevices count];
}

-(void) removeDeviceAtIndex:(NSInteger)index {
    
    NSMutableArray *buffer = [NSMutableArray arrayWithArray:selectedDevices];
    [buffer removeObjectAtIndex:index];
    selectedDevices = buffer;
}

-(BTDeviceInfo*) selectedDeviceAtIndex:(NSInteger)index {
    
    return [selectedDevices objectAtIndex:index];
}

-(NSInteger) selectedDeviceCount {
    
    return [selectedDevices count];
}

-(void) selectDiscoveredDeviceAtIndex:(NSInteger)index {
    
    NSMutableArray *buffer = [NSMutableArray arrayWithArray:selectedDevices];
    [buffer addObject:[discoveredDevices objectAtIndex:index]];
    selectedDevices = buffer;
}

-(void) startMonitoring {
    
    if (deviceInUse != nil) {
        NSLog(@"start monitoring %@", [[deviceInUse deviceID] name]);
        [btManager connectPeripheral:[deviceInUse deviceID] options:nil];
        state = DMmonitoring;
    }
}

-(void) startScan {
    
    btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    if ([btManager state] == CBCentralManagerStatePoweredOn) {
        [btManager scanForPeripheralsWithServices:nil options:nil];
        deviceInUse = nil;
        NSLog(@"Starting scan...");
        state = DMscanning;
    }
    if ([btManager state] == CBCentralManagerStatePoweredOff || [btManager state] == CBCentralManagerStateResetting) {
        NSLog(@"Lost the manager...");
        state = DMnotInUse;
    }

}

-(void) stopScan {
    
    [btManager stopScan];
    NSLog(@"Stopping scan");
    state = DMnotInUse;
}

-(void) stopMonitoring {
    
    [btManager cancelPeripheralConnection:[deviceInUse deviceID]];
    NSLog(@"stop monitoring %@", [[deviceInUse deviceID] name]);
    state = DMnotInUse;
}

@end
