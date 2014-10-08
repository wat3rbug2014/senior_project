//
//  BTDummyData.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceManager.h"
#import "MonitorCreationFactory.h"
#import "DeviceConnection.h"
#import "DummyDevice.h"

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

/*
 * This function starts the discovery process based on the type of device
 * it is looking to find.  At this time there is HEART_MONITOR and ACTIVITY_MONITOR
 * types.
 *
 * @param The integer that designates whether a heart monitor or an activity monitor
 *          will be the attempt to discover.
 **/

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

/*
 * This function allows remote shutdown of discovery process to conserve the battery.  Its purpose is to allow
 * the dismissal of selection viewcontrollers to shut the discovery because the devicemanager class is shared
 * throughout the application.
 **/

-(void) stopScan {
    
    NSLog(@"Stopping scan");
    [manager stopScan];
}

/*
 * This function returns the count of the number of devices found during the discovery process of either the
 * heart monitor or activity monitor discovery.  Accepted types are to be found in DeviceTypes.h
 *
 * @param An integer result of the count of devices that have been found.
 **/

-(NSInteger) discoveredDevicesForType:(NSInteger)type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices count];
    } else {
        return  [activityDevices count];
    }
}

/*
 * This returns the device object based on the index and the device type that discovery is done to obtain.
 * The monitor type is an integer based on the constants found in DeviceTypes.h. 
 *
 * @param index is the index from the table which is in sync with the array of devices that have been discovered.
 * @param type it the integer value that determines which array to retrieve the device class.
 * @return Returns the device object that correlates to the DeviceConnection protocol.
 **/

-(id<DeviceConnection>) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices objectAtIndex:index];
    } else {
        return  [activityDevices objectAtIndex:index];
    }
}

/*
 * This method is to tidy up after a device selection screen.  In order to get device details
 * all the devices that werte scanned have to be connected.  Since only one is connected during 
 * the monitoring process the others need to disconnect.  Only those device types are disconnected.
 *
 * @param type The device type as designated by the DeviceTypes.h file.
 **/

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

// undecided on whether this should remain

-(BOOL) isActiveMeasurementReceived {
    
    [self setIsActive:![self isActive]];
    return [self isActive];
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
                
                // query the device and get this information so the table and update even though
                // we are discarding the local result.
                
                [currentDevice getTableInformation];
            }
        }
    }
}

@end
