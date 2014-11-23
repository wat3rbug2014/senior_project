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
@synthesize managerDelegate;
@synthesize monitoringTimer;
@synthesize selectedDevices;
@synthesize signalStrength;
@synthesize timeInterval;

#pragma mark -
#pragma mark Super class methods


-(id) init {
    
    if (self = [super init]) {
        discoveredDevices = nil;
        timeInterval = 1.0;
        signalStrength = 0;
        [[deviceInUse deviceID] setDelegate:self];
        // Custom initialization
        // load core data
        // get devices already saved
    }
    return self;
}

-(void) dealloc {
    
    if ([btManager state] == CBCentralManagerStateUnknown || [btManager state] == CBCentralManagerStatePoweredOn || [btManager state] == CBCentralManagerStateResetting) {
        [btManager stopScan];
        if (monitoringTimer != nil) {
            [monitoringTimer invalidate];
            monitoringTimer = nil;
        }
        NSLog(@"Scanning stopped");
    }
}

#pragma mark -
#pragma CBCentralManagerDelegate Protocol methods


-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
    // fix this so it accounts for all states
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        [btManager scanForPeripheralsWithServices:nil options:nil];
        NSLog(@"Starting scan...");
    }
    if ([central state] == CBCentralManagerStatePoweredOff || [central state] == CBCentralManagerStateResetting) {
        NSLog(@"Lost the manager...");
    }
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if ([peripheral name] != nil) {
        
        // check for duplicates and prevent them from being added to the list
        
        bool isNew = true;
        for (BTDeviceInfo *currentDevice in discoveredDevices) {
            if ([[currentDevice deviceID] identifier] == [peripheral identifier]) {
                isNew = false;
                NSLog(@"%@ is not new", [peripheral name]);
            }
        }
        // Add the new item to the list.
        
        if (isNew) {
            NSMutableArray *existingDiscoveredDevices = [NSMutableArray arrayWithArray:discoveredDevices];
            BTDeviceInfo *newDevice = [[BTDeviceInfo alloc] initWithDevice:peripheral];
            [existingDiscoveredDevices addObject:newDevice];
            NSLog(@"Discovered %@", [peripheral name]);
            discoveredDevices = existingDiscoveredDevices;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BTDiscoveryChange" object:self];
        }
    }
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Connected to %@", [peripheral name]);
    [peripheral setDelegate:self];
    
    // start discovery of services

    [peripheral discoverServices:nil];
    [peripheral readRSSI];

}

#pragma mark -
#pragma mark CBPeripheral methods


-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    for (CBCharacteristic *currentService in [service characteristics]) {
        NSLog(@"characteristic is %@", [currentService description]);
        
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error != nil) {
        NSLog(@"Error %@", [error description]);
    }
    // list the services - for debugging purposes because apparently correct UUIDs are hard to find.
    
    NSLog(@"Discovered services");
    for (CBService *service in [peripheral services]) {
        NSLog(@"Service: %@", service.UUID);
        [peripheral discoverCharacteristics: nil forService:service];
    }
}

-(void) peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
    // this needs to be fixed
    
    NSLog(@"previous RSSI %@\ttime: %f", signalStrength, timeInterval);
    if (signalStrength == 0) {
        signalStrength = [peripheral RSSI];
    }
    if ([peripheral RSSI] > signalStrength) {
        if (timeInterval > 0.0) {
            timeInterval += .25;
        }
    }
    if ([peripheral RSSI] < signalStrength) {
        timeInterval -= .25;
    }
    NSLog(@"current RSSI %@ \ttime: %f", [peripheral RSSI], timeInterval);
    signalStrength = [peripheral RSSI];
    monitoringTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(getDeviceUpdates)
                                                     userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BTMonitoringUpdate" object:self];
}

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    // do an alert because device is lost and then dismiss this controller.
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

-(void) getDeviceUpdates {
    
    [[deviceInUse deviceID] readRSSI];
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
    } else {
        NSLog(@"Failed to start monitoring");
    }
}

-(void) startScan {
    
    if (btManager == nil) {
        btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    if ([btManager state] == CBCentralManagerStatePoweredOn) {
        [btManager scanForPeripheralsWithServices:nil options:nil];
        deviceInUse = nil;
        NSLog(@"Starting scan...");
    }
    if ([btManager state] == CBCentralManagerStatePoweredOff || [btManager state] == CBCentralManagerStateResetting) {
        NSLog(@"Lost the manager...");
    }

}

-(void) stopScan {
    
    [btManager stopScan];
    NSLog(@"Stopping scan");
}

-(void) stopMonitoring {
    
    if (deviceInUse != nil) {
        [btManager cancelPeripheralConnection:[deviceInUse deviceID]];
        NSLog(@"stop monitoring %@", [[deviceInUse deviceID] name]);
    }
    [monitoringTimer invalidate];
    monitoringTimer = nil;
}

@end
