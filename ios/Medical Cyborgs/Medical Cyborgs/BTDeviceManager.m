//
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceManager.h"
#import "MonitorCreationFactory.h"
#import "DeviceCommonInfoInterface.h"


@implementation BTDeviceManager

@synthesize selectedHeartMonitor;
@synthesize selectedActivityMonitor;
@synthesize heartDevices;
@synthesize activityDevices;
@synthesize selectedIndexForHeartMonitor;
@synthesize selectedIndexForActivityMonitor;
@synthesize isInDiscoveryMode;
@synthesize manager;
@synthesize searchType;
@synthesize isActive;
@synthesize waitForDevices;
@synthesize runLoop;

static BTDeviceManager *sharedManager = nil;

-(void) startScanForType:(NSInteger)type {
    
    NSMutableArray *services = nil;
    [self setIsInDiscoveryMode:YES];
    if ((type & HEART_MONITOR) == HEART_MONITOR) {
        services = [[NSMutableArray alloc] initWithObjects:[CBUUID UUIDWithString: POLARH7_SERV_UUID], nil];
    }
    if ((type & ACTIVITY_MONITOR) == ACTIVITY_MONITOR) {
        if (services == nil) {
            services = [[NSMutableArray alloc] init]; // fix this for services once discovered
        } else {
            [services addObject:nil]; // fix this once discovered
        }
    }
    NSLog(@"scanning for services");
    if (isActive) {
        [manager scanForPeripheralsWithServices:services options:nil];
    }
}

+(id)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[BTDeviceManager alloc] init];
    });
    return sharedManager;
}

-(id) init {
    
    if (self = [super init]) {
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        selectedIndexForActivityMonitor = NONE_SELECTED;
        selectedIndexForHeartMonitor = NONE_SELECTED;
        isInDiscoveryMode = NO;
    }
    return self;
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [manager setDelegate:nil];
    manager = nil;
}

-(NSInteger) discoveredDevicesForType:(NSInteger)type {
    
    if ((type & ACTIVITY_MONITOR) == HEART_MONITOR) {
        return [heartDevices count];
    } else {
        return  [activityDevices count];
    }
}

-(void) stopScan {
    
    BOOL readyToStopScan = YES;
    if ([heartDevices count] > 0) {
        if (selectedIndexForHeartMonitor != NONE_SELECTED && ![[heartDevices objectAtIndex: selectedIndexForHeartMonitor] discoveryComplete]) {
            readyToStopScan = NO;
        }
    }
    if ([activityDevices count] > 0) {
        if (selectedIndexForActivityMonitor != NONE_SELECTED && ![[activityDevices objectAtIndex:selectedIndexForActivityMonitor] discoveryComplete]) {
            readyToStopScan = NO;
        }
    }
    if (!readyToStopScan) {
        NSLog(@"Waiting for devices to be fully discovered before disconnection");
        waitForDevices = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
            selector:@selector(stopScan) userInfo:nil repeats:YES];
        runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:waitForDevices forMode:NSDefaultRunLoopMode];
        return;
    } else {
        NSLog(@"all devices fully discovered");
        [waitForDevices invalidate];
        [runLoop cancelPerformSelectorsWithTarget:self];
    }
    NSLog(@"Stopping scan");
    [manager stopScan];
    //[self disconnectAllDevices];
    [self setIsInDiscoveryMode:NO];
}

-(void) disconnectSelectedMonitors {
    
    if (selectedHeartMonitor != nil) {
        [manager cancelPeripheralConnection:[selectedHeartMonitor device]];
    }
    if (selectedActivityMonitor != nil) {
        [manager cancelPeripheralConnection:[selectedActivityMonitor device]];
    }
}

-(void)connectSelectedMonitors {
    
    [self setIsInDiscoveryMode:NO];
    if (selectedActivityMonitor) {
        [manager connectPeripheral:[selectedActivityMonitor device] options:nil];
    }
    if (selectedHeartMonitor) {
        [manager connectPeripheral:[selectedHeartMonitor device] options:nil];
    }
}

-(void) disconnectAllDevices {

    NSMutableArray *allDevices = [[NSMutableArray alloc] initWithArray:heartDevices];
    [allDevices addObjectsFromArray:activityDevices];
    for (id<DeviceCommonInfoInterface> currentDevice in allDevices) {
        if ([currentDevice isConnected]) {
            [currentDevice shouldMonitor:NO];
            [manager cancelPeripheralConnection:[currentDevice device]];
        }
    }
}


-(id<DeviceCommonInfoInterface>) deviceAtIndex: (NSInteger) index forType: (NSInteger) type {
    
    id<DeviceCommonInfoInterface> result = nil;
    if (index != NONE_SELECTED) {
        if ((type & HEART_MONITOR) == HEART_MONITOR && index < [heartDevices count]) {
            result = [heartDevices objectAtIndex:index];
        }
        if ((type & ACTIVITY_MONITOR) == ACTIVITY_MONITOR && index < [activityDevices count]) {
            result = [activityDevices objectAtIndex:index];
        }
    }
    return result;
}

-(void)selectDeviceType:(NSInteger)type atIndex:(NSInteger)index {
    
    if (index == NONE_SELECTED) {
        return;
    }
    if ((type & ACTIVITY_MONITOR) == ACTIVITY_MONITOR && index < [activityDevices count]) {
        [manager connectPeripheral:[[activityDevices objectAtIndex:index] device] options:nil];
        selectedActivityMonitor = [activityDevices objectAtIndex:index];
        selectedIndexForActivityMonitor = index;
    }
    if ((type & HEART_MONITOR) == HEART_MONITOR && index < [heartDevices count]) {
        [manager connectPeripheral:[[heartDevices objectAtIndex:index] device] options:nil];
        selectedIndexForHeartMonitor = index;
        selectedHeartMonitor = [heartDevices objectAtIndex:index];
    }
}

-(void)deselectDeviceType:(NSInteger)type {
    

    if ((type & HEART_MONITOR) == HEART_MONITOR) {
        selectedIndexForHeartMonitor = NONE_SELECTED;
        selectedHeartMonitor = nil;
    } else {
        selectedIndexForActivityMonitor = NONE_SELECTED;
        selectedActivityMonitor = nil;
    }
}

-(id<DeviceCommonInfoInterface>) monitorMatchingCBPeripheral:(CBPeripheral *)device {
    
    id<DeviceCommonInfoInterface> result = nil;
    NSMutableArray *allDevices = [[NSMutableArray alloc] initWithArray:heartDevices];
    [allDevices addObjectsFromArray:activityDevices];
    for (id<DeviceCommonInfoInterface> currentDevice in allDevices) {
        if ([[device name] rangeOfString:[[currentDevice device] name]].location != NSNotFound) {
            result = currentDevice;
        }
    }
    return result;
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
    if ([peripheral name] == nil) {
        NSLog(@"false positive");
        return;
    }
    NSLog(@"preliminary duplicates removed");
    id<DeviceCommonInfoInterface> result = [self monitorMatchingCBPeripheral:peripheral];
    if (result != nil) {
        return;
    }
    id<DeviceCommonInfoInterface> newDevice = [MonitorCreationFactory createFromPeripheral:peripheral];
    NSMutableArray *buffer = nil;
    if (([newDevice type] & HEART_MONITOR) == HEART_MONITOR) {
        buffer = [[NSMutableArray alloc] initWithArray:heartDevices];
        [buffer addObject:newDevice];
        heartDevices = buffer;
        NSLog(@"Added %@ to heart devices", [newDevice name]);
    } else {
        buffer = [[NSMutableArray alloc] initWithArray:activityDevices];
        [buffer addObject:newDevice];
        activityDevices = buffer;
        NSLog(@"Added %@ to activity devices", [newDevice name]);
    }
    NSLog(@"Activity devices: %d\theart devices: %d", (int)[activityDevices count],
          (int)[heartDevices count]);
    
    // post a notification so that the tableviews can update their views
    
    NSLog(@"Device: %@ connecting...", [newDevice name]);
    [manager connectPeripheral:[newDevice device] options:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: DEVICE_DISCOVERED object:self];
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    if([self isInDiscoveryMode]) {
        
        // find the object that has the device and scan for the service and characteristics
        
        id<DeviceCommonInfoInterface> result = [self monitorMatchingCBPeripheral:peripheral];
        if (result == nil) {
            return;
        }
        [result getTableInformation];
    } else {
        
        // going through all devices that were discovered to find the one and its type
        
        NSNotification *connectNotification = nil;
        NSLog(@"Determining which device is connected");
        id<DeviceCommonInfoInterface> result = [self monitorMatchingCBPeripheral:peripheral];
        if ([result conformsToProtocol:@protocol(ActivityMonitorProtocol)]) {
            connectNotification = [[NSNotification alloc] initWithName:BTActivityConnected
                        object:self userInfo:nil];
            NSLog(@"Found activity monitor %@", [peripheral name]);
        }
        // if heart device connected notify everyone
                
        if ([result conformsToProtocol:@protocol(HeartMonitorProtocol)]) {
            NSLog(@"Found heart monitor %@", [peripheral name]);
            connectNotification = [[NSNotification alloc] initWithName:BTHeartConnected
                        object:self userInfo:nil];
        }
        //[result shouldMonitor:YES];
        [result getTableInformation];
        [[NSNotificationCenter defaultCenter] postNotification:connectNotification];
    }
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        // not sure what to do because not connecting is a desired result
    }
    NSLog(@"%@ is disconnected", [peripheral name]);
}

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (![self isInDiscoveryMode]) {
        NSLog(@"Unable to connect to %@", [peripheral identifier]);
        NSNotification *failedNotification = [[NSNotification alloc] initWithName:@"DevicePollFailed" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:failedNotification];
    } else {
        NSLog(@"unable to connect to %@ is discovery mode", [peripheral identifier]);
    }
}
@end
