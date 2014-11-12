//
//  DevicePollManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/20/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This class functions as the polling mechanism for the bluetooth devices.  Its
 * goes through each time the main method is called and retrieves the information
 * from the devices and puts the data in the local data store.
 */

#import <Foundation/Foundation.h>
#import "DeviceCommonInfoInterface.h"
#import "PersonalInfo.h"
#import "HeartMonitorProtocol.h"
#import "BTDeviceManager.h"
#import "DBManager.h"
#import "ActivityMonitorProtocol.h"

@interface DevicePollManager : NSObject


@property PersonalInfo *patientInfo;
@property NSInteger patientID;
@property (retain) BTDeviceManager *deviceManager;
@property id<DeviceCommonInfoInterface, HeartMonitorProtocol> heartMonitor;
@property id<DeviceCommonInfoInterface, ActivityMonitorProtocol> activityMonitor;
@property DBManager *database;
@property BOOL batteryAlertGiven;
@property BOOL ableToPoll;
@property BOOL isHeartMonitorReady;
@property BOOL isActivityMonitorReady;


/**
 * This is the preferred initialization method.  The datastore and the two components are passed
 * so that polling can happen imediately. WARNING:  This initialization method must be used if any
 * polling is to occur.
 */

-(id) initWithDataStore:(DBManager*) dataStore andDevicemanager: (BTDeviceManager*) newDeviceManager;


/**
 * This method is used to get information from the devices. If the devices have not been added with the
 * initWithDataStore: heartMonitor: activityMonitor: no updates will occur.  The appropriate data is
 * pulled from the devices for monitoring.  The battery level, if readable is also polled.  If the 
 * battery is below 20% a notification will be posted to the NSNotificationCenter.
 */

-(void) pollDevicesForData;


/**
 * This method is used by the device manager to notify the poller that a device is connected.
 *  It is used to help signal the device poller that it can continue because all devices are
 * connected.
 *
 * @param notification The notification that is used to update device status.
 */

-(void) didReceiveNotificationDeviceConnected: (NSNotification*) notification;



-(int) activityLevelBasedOnHeartRate: (NSInteger) heartRate;


@end
