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

/*
 * This initialization has dummy data that will be removed as real time is put
 * into place.
 **/

-(id) init {
    
    if (self = [super init]) {
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil]; // maybe this needs to be on another thread
        
        NSMutableArray *deviceListBuild = [NSMutableArray arrayWithCapacity:DEVICE_NUM];
        for (int i = 0; i < DEVICE_NUM; i++) {
            DummyDevice *temp = [[DummyDevice alloc] init];
            [temp setName: [NSString stringWithFormat:@"Heart Test%d", i]];
            [deviceListBuild addObject:temp];
        }
        heartDevices = deviceListBuild;
//        deviceListBuild = [NSMutableArray arrayWithCapacity:DEVICE_NUM];
//        for (int i = 0; i < DEVICE_NUM; i++) {
//            DummyDevice *temp = [[DummyDevice alloc] init];
//            [temp setName: [NSString stringWithFormat:@"Activity Test%d", i]];
//            [deviceListBuild addObject:temp];
//        }
//        activityDevices = deviceListBuild;
    }
    return self;
}

-(void) dealloc {
    
    [manager setDelegate:nil];
    manager = nil;
}
/*
 * This function starts the discovery process based on the type of device
 * it is looking to find.  At this time there is HEART_MONITOR and ACTIVITY_MONITOR
 * types.
 * @param The integer that designates whether a heart monitor or an activity monitor
 * will be the attempt to discover.
 **/

-(void) discoverDevicesForType:(NSInteger)type {
    
    NSArray *services;
    if (type == ACTIVITY_MONITOR) {
        
        // temporary workaround since only one device is known at the moment
        
        services =[[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:FLEX_SERV_UUID], nil];
    } else {
        
        // need information on the other devices
    }
    [manager scanForPeripheralsWithServices:services options:nil];
    NSLog(@"Scanning devices");
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

// this should change from id for compile time checks

-(id) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type {
    
    if (type == HEART_MONITOR) {
        return [heartDevices objectAtIndex:index];
    } else {
        return  [activityDevices objectAtIndex:index];
    }
}


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

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered a device");
    id<DeviceConnection> newDevice = [MonitorCreationFactory createFromPeripheral:peripheral];
    NSMutableArray *buffer = nil;
    if ([newDevice type] == HEART_MONITOR) {
        buffer = [NSMutableArray arrayWithArray:heartDevices];
        [buffer addObject:newDevice];
        heartDevices = buffer;
    } else {
        buffer = [NSMutableArray arrayWithArray:activityDevices];
        [buffer addObject:newDevice];
        activityDevices = buffer;
    }
}
@end
