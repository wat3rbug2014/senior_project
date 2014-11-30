//
//  DevicePollManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/20/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DevicePollManager.h"
#import "HeartMonitorProtocol.h"

@implementation DevicePollManager

@synthesize database;
@synthesize deviceManager;
@synthesize patientInfo;
@synthesize patientID;
@synthesize ableToPoll;
@synthesize heartMonitor;
@synthesize activityMonitor;
@synthesize batteryAlertGiven;
@synthesize isActivityMonitorReady;
@synthesize isHeartMonitorReady;
@synthesize currentHeartRate;
@synthesize locationAllowed;
@synthesize locationManager;
@synthesize lowBatteryNotified;

-(UIApplication*) app {
    
    return [UIApplication sharedApplication];
}

-(id) initWithDataStore:(DBManager *)dataStore andDevicemanager:(BTDeviceManager *)newDeviceManager {
    
    if (dataStore == nil || newDeviceManager == nil) {
        return nil;
    }
    if (self = [super init]) {
        deviceManager = newDeviceManager;
        [deviceManager setDelegate:self];
        database = dataStore;
        patientID = [database patientID];
        ableToPoll = NO;
        batteryAlertGiven = NO;
        isHeartMonitorReady = NO;
        isActivityMonitorReady = NO;
        lowBatteryNotified = NO;
        // setup notifications
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotificationDeviceConnected)
                                                     name: BTHeartConnected object:deviceManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotificationDeviceConnected)
                                                     name: BTActivityConnected object:deviceManager];
        
        heartMonitor = [[deviceManager heartDevices] objectAtIndex:[deviceManager selectedIndexForHeartMonitor]];
        activityMonitor = [[deviceManager activityDevices] objectAtIndex:[deviceManager selectedIndexForActivityMonitor]];
    }
    return self;
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [deviceManager removeObserver:self forKeyPath:@"selectedHeartMonitor"];
    [deviceManager removeObserver:self forKeyPath:@"selectActivityMonitor"];
    locationManager = nil;
}

-(void) stopMonitoring {
    
    ableToPoll = NO;
    [locationManager stopMonitoringSignificantLocationChanges];
    //[deviceManager disconnectSelectedMonitors];
}
-(void) pollDevicesForData {
    
    NSLog(@"verifying input before poll");
    if ([self patientID] == NO_ID_SET) {
        ableToPoll = NO;
        NSLog(@"No patient ID\nPolling stopped");
        return;
    }
    [database setPatientID:patientID];
    if (![heartMonitor isConnected]) {
        NSLog(@"Device poller attempt to heart monitor");
        [deviceManager connectSelectedMonitors];
        return;
    }
    NSLog(@"Device poller already has connected devices");

    if (!ableToPoll) {
        NSLog(@"Setting up location services");
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager requestAlwaysAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
        ableToPoll = YES;
    }
    NSLog(@"Getting battery level info from devices");
    
    [heartMonitor discoverBatteryLevel];
    [activityMonitor discoverBatteryLevel];
    if ([heartMonitor batteryLevel] < 20) {
        [self doBatteryLowNotificationFor:heartMonitor];
    }
    if ([activityMonitor batteryLevel] < 20) {
        [self doBatteryLowNotificationFor:activityMonitor];
    }
    NSLog(@"getting data from heart monitor");
    currentHeartRate = (int)[heartMonitor getHeartRate];
    
    NSLog(@"getting data from activity monitor");
    
    
    NSLog(@"storing data in database");
    
    [database setHrmeasurement:currentHeartRate];
    
    // check this
    
    [database setActivityLevel:[DeviceConstantsAndStaticFunctions
        activityLevelBasedOnHeartRate:currentHeartRate andAge:[patientInfo age]]];
    
    // end of check portion
    
    [database setTimestamp:[NSDate date]];
    [database insertDataIntoDB];
    
    NSLog(@"finished poll");
}

-(void)didReceiveNotificationDeviceConnected {
  
    // determine heart or activity and flag appropriate one is connected
    
    if ([deviceManager selectedIndexForHeartMonitor] == NONE_SELECTED) {
        return;
    } else {
        heartMonitor = [deviceManager selectedHeartMonitor];
        if ([heartMonitor isConnected]) {
            [self setIsHeartMonitorReady:YES];
            NSLog(@"heart monitor connected\nContinue polling");
            [heartMonitor shouldMonitor:YES];
        }
    }
    if ([deviceManager selectedIndexForActivityMonitor] == NONE_SELECTED) {
        return;
    } else {
        self.activityMonitor = [deviceManager selectedActivityMonitor];
        if ([activityMonitor isConnected]) {
            [self setIsActivityMonitorReady:YES];
            NSLog(@"activity monitor connected\nContinue polling");
            [activityMonitor shouldMonitor:YES];
        }
    }
}

-(void) doBatteryLowNotificationFor:(id<DeviceCommonInfoInterface>)device {
    
    UIApplication *app = [self app];
    if ([app applicationState] != UIApplicationStateBackground) {
        return;
    }
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
            settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    UILocalNotification *batteryNotification = [[UILocalNotification alloc] init];
    [batteryNotification setSoundName:UILocalNotificationDefaultSoundName];
    [batteryNotification setApplicationIconBadgeNumber:1];
    [batteryNotification setAlertBody:[NSString stringWithFormat:@"%@ has low battery", [device name]]];
    if (!lowBatteryNotified) {
        [[self app] presentLocalNotificationNow:batteryNotification];
    }
    lowBatteryNotified = YES;
}

#pragma mark - BTDeviceManagerDelegate methods


-(void) deviceManagerDidUpdateMonitors {
    
    NSLog(@"Used delegate");
    [self setActivityMonitor:[deviceManager selectedActivityMonitor]];
    [self setHeartMonitor:[deviceManager selectedHeartMonitor]];
}

#pragma mark - CLLocationManagerDelegate methods


-(void) locationManager:(CLLocationManager*) manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status {
    
    
    // NOTE The constants seem invalid
    
    NSLog(@"Authorization status changed");
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        locationAllowed = NO;
        NSLog(@"Authorization NOT allowed");
    } else {
        if ( status == kCLAuthorizationStatusAuthorizedAlways) {
            locationAllowed = YES;
            NSLog(@"Location allowed ALWAYS");
        } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            NSLog(@"Location allowed IN USE");
        } else {
             NSLog(@"authorization unknown");
        }
    }
}

-(void) locationManager: (CLLocationManager*) manager didUpdateLocations: (NSArray*) locations {
    
    NSLog(@"location update happened");
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"Location: %@", currentLocation);
    [database setLongitude:[currentLocation coordinate].longitude];
    [database setLatitude:[currentLocation coordinate].latitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Show a log entry for failure for now");
    // not sure what to do at this moment.  Database will be using last recording
    // and I haven't done research on how to reset aft
}

@end
