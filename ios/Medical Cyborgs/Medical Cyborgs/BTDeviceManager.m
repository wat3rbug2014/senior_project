//
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceManager.h"
#import "MonitorCreationFactory.h"
#import "DeviceConnection.h"


@implementation BTDeviceManager

@synthesize heartDevices;
@synthesize activityDevices;
@synthesize selectedIndexForActivityMonitor;
@synthesize selectedIndexForHeartMonitor;
@synthesize heartMonitorIsConnected;
@synthesize activityMonitorIsConnected;
@synthesize isActive;
@synthesize manager;
@synthesize searchType;
@synthesize isInDiscoveryMode;

-(id) init {
    
    if (self = [super init]) {
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; // maybe this needs to be on another thread
        selectedIndexForActivityMonitor = NONE_SELECTED;
        selectedIndexForHeartMonitor = NONE_SELECTED;
        isInDiscoveryMode = NO;
    }
    return self;
}

/*
 * This method is mostly not needed because of ARC.  However, it is important to understand that only one instance of the
 * CBCentralManager should exist.  This just demonstrates that the references must be cleared so that dangling
 * pointers don't cause a bug somewhere else.
 **/

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [manager setDelegate:nil];
    manager = nil;
}

-(void) disconnectAllDevices {
    
    NSMutableArray *completeBuffer = [[NSMutableArray alloc] initWithArray:activityDevices];
    [completeBuffer addObjectsFromArray:heartDevices];
    for (id<DeviceConnection> currentDevice in completeBuffer) {
        if ([currentDevice isConnected]) {
            NSLog(@"disconnecting %@", [currentDevice name]);
            [manager cancelPeripheralConnection:[currentDevice device]];
        }
    }
}

-(void) discoverDevicesForType:(NSInteger)type {
    
    NSArray *services = nil;
    if (type == ACTIVITY_MONITOR) {
        
        // temporary workaround since only one device is known at the moment
        
        services =[[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:FLEX_SERV_UUID], nil];
    } else {
        services = [[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:POLARH7_SERV_UUID], nil];
        // need information on the other devices
    }
    NSLog(@"Scanning devices");
    [self setIsInDiscoveryMode:YES];
    //[manager scanForPeripheralsWithServices:nil options:nil];
    [manager scanForPeripheralsWithServices:services options:nil];
}

-(void) stopScan {
    
    NSLog(@"Stopping scan");
    [manager stopScan];
    [self setIsInDiscoveryMode:NO];
}

-(NSInteger) discoveredDevicesForType:(NSInteger)type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices count];
    } else {
        return  [activityDevices count];
    }
}

-(id<DeviceConnection>) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices objectAtIndex:index];
    } else {
        return  [activityDevices objectAtIndex:index];
    }
}

-(void) disconnectDevicesForType: (NSInteger) type {

    for (id<DeviceConnection> currentDevice in heartDevices) {
        if ([currentDevice type] == type) {
            [manager cancelPeripheralConnection:[currentDevice device]];
        }
    }
}

-(void)connectMonitors {
    
    [manager connectPeripheral: [heartDevices objectAtIndex:[self selectedIndexForHeartMonitor]]options:nil];
    [manager connectPeripheral:[activityDevices objectAtIndex:[self selectedIndexForActivityMonitor]] options:nil];
}

#pragma mark CBCentralManagerDelegate methods


-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
    // will need to include the other states so that proper error handling can be done
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        [self setIsActive:YES];
    } else {
        [self setIsActive:NO];
    }

}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
     NSLog(@"Discovered a device %@", [peripheral description]);
    
    // a recent API bug returns a nil peripheral related to cached devices
    
    if (peripheral == nil) {
        return;
    }
    if ([peripheral identifier] == nil) {
        NSLog(@"false positive");
        return;
    }
    NSLog(@"preliminary duplicates removed");
    id<DeviceConnection> newDevice = [MonitorCreationFactory createFromPeripheral:peripheral];
    NSMutableArray *buffer = nil;
    
    // do the check for duplicates and add to heart monitors if it is original
    
    if ([newDevice type] == HEART_MONITOR) {
        buffer = [NSMutableArray arrayWithArray:heartDevices];
        BOOL isNew = false;
        for (id<DeviceConnection> currentDevice in buffer) {
            if ([[[currentDevice device] identifier] isEqual:[[newDevice device] identifier]]) {
                isNew = true;
            }
        }
        if (!isNew) {
            [buffer addObject:newDevice];
            heartDevices = buffer;
        }
        // do the check for duplicates and add to activity monitors
        
    } else {
        buffer = [NSMutableArray arrayWithArray:activityDevices];
        BOOL isNew = false;
        for (id<DeviceConnection> currentDevice in buffer) {
            if ([[[currentDevice device] identifier] isEqual:[[newDevice device] identifier]]) {
                isNew = true;
            }
        }
        if (!isNew) {
            [buffer addObject:newDevice];
            activityDevices = buffer;
        }
    }
    NSLog(@"Activity devices: %d\theart devices: %d", [activityDevices count], [heartDevices count]);
    // post a notification so that the tableviews can update their views
    
    NSLog(@"Device: %@ connecting...", [newDevice name]);
    [manager connectPeripheral:[newDevice device] options:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BTDeviceDiscovery" object:self];
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSMutableArray *completeBuffer = [[NSMutableArray alloc] initWithArray:activityDevices];
    [completeBuffer addObjectsFromArray:heartDevices];

    if([self isInDiscoveryMode]) {
        for (id<DeviceConnection> currentDevice in completeBuffer) {
            if ([[currentDevice name] isEqual:[peripheral name]]) {
                
                // query the device and get this information to the table and update even though
                // we are discarding the local result.
                NSLog(@"Getting information for %@" , [currentDevice name]);
                [currentDevice getTableInformation];
            } else {
                NSLog(@"Not getting info for %@", [peripheral name]);
            }
        }
    }
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        // not sure what to do because not connecting is a desired result
    }
    NSLog(@"%@ is disconnected", [peripheral name]);
}
@end
