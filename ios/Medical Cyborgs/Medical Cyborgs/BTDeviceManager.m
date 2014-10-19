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


-(id) init {
    
    if (self = [super init]) {
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; // maybe this needs to be on another thread
        selectedIndexForActivityMonitor = NONE_SELECTED;
        selectedIndexForHeartMonitor = NONE_SELECTED;
//        NSArray *services;
//        services =[[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:FLEX_SERV_UUID], nil];
//        NSArray *oldDevices = [manager retrieveConnectedPeripheralsWithServices:services];
//        for (CBPeripheral *currentDevice in oldDevices) {
//            [manager cancelPeripheralConnection: currentDevice];
//        }
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



-(void) discoverDevicesForType:(NSInteger)type {
    
    NSArray *services;
    if (type == ACTIVITY_MONITOR) {
        
        // temporary workaround since only one device is known at the moment
        
        services =[[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:FLEX_SERV_UUID], nil];
    } else {
        
        // need information on the other devices
    }
    NSLog(@"Scanning devices");
    [manager scanForPeripheralsWithServices:nil options:nil];
}

-(void) stopScan {
    
    NSLog(@"Stopping scan");
    [manager stopScan];
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
    
    if (type == HEART_MONITOR) {
        for (id<DeviceConnection> currentDevice in heartDevices) {
            [manager cancelPeripheralConnection:[currentDevice device]];
        }
    } else {
        for (id<DeviceConnection> currentDevice in activityDevices) {
            [manager cancelPeripheralConnection:[currentDevice device]];
        }
    }
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
    
    // a recent API bug returns a nil peripheral related to caching devices 
    if (peripheral == nil) {
        return;
    }
    NSLog(@"Discovered a device");
    id<DeviceConnection> newDevice = [MonitorCreationFactory createFromPeripheral:peripheral];
    
    // get rid of false positive devices.  Sometimes a device is discovered but there
    // is no information for it or there is a duplicate.
    
    if (newDevice == nil) {
        return;
    }
    NSMutableArray *buffer = nil;
    
    // do the check for duplicates and add to heart monitors
    
    if ([newDevice type] == HEART_MONITOR) {
        buffer = [NSMutableArray arrayWithArray:heartDevices];
        BOOL isNew = false;
        for (id<DeviceConnection> currentDevice in buffer) {
            if ([[currentDevice name] isEqual:[newDevice name]]) {
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
            if ([[currentDevice name] isEqual:[newDevice name]]) {
                isNew = true;
            }
        }
        if (!isNew) {
            [buffer addObject:newDevice];
            activityDevices = buffer;
        }
    }
    // post a notification so that the tableviews can update their views
    
    NSLog(@"Device: %@ connecting...", [newDevice name]);
    [manager connectPeripheral:[newDevice device] options:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BTDeviceDiscovery" object:self];
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Connected to %@", [peripheral name]);
    if ([self searchType] == ACTIVITY_MONITOR) {
        for (id<DeviceConnection> currentDevice in activityDevices) {
            if ([[currentDevice device] isEqual:peripheral]) {
                
                // query the device and get this information to the table and update even though
                // we are discarding the local result.
                
                [currentDevice getTableInformation];
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
