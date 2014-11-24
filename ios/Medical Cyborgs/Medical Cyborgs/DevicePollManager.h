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
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DeviceCommonInfoInterface.h"
#import "PersonalInfo.h"
#import "HeartMonitorProtocol.h"
#import "BTDeviceManager.h"
#import "DBManager.h"
#import "ActivityMonitorProtocol.h"
#import "DeviceConstantsAndStaticFunctions.h"
#import "BTDeviceManagerDelegate.h"

@interface DevicePollManager : NSObject <BTDeviceManagerDelegate, CLLocationManagerDelegate>


/**
 * The location manager used for tracking the location of the patient for large updates.
 */

@property (strong) CLLocationManager *locationManager;


/**
 * The flag that is used for checking to see if any location checks are allowed by the
 * user.
 */

@property BOOL locationAllowed;


/**
 * The flag that is used to see if big location changes are allowed.
 */

@property BOOL bigLocationChanges;


/**
 * The patient information that is locally stored by the application.  It is in the
 * NSUserDefaults so that application restores will not require any remote connection.
 */

@property PersonalInfo *patientInfo;


/**
 * The patientID is used for the device poller to insert into the database.  This
 * reference is used for code brevity.
 */

@property NSInteger patientID;


/**
 * The device manager which controls connectivity to the devices.
 */

@property (retain) BTDeviceManager *deviceManager;


/**
 * The heart monitor that was selected.  This reference is used for code brevity.
 */

@property id<DeviceCommonInfoInterface, HeartMonitorProtocol> heartMonitor;


/**
 * The activity monitor that was selected.  The reference is used for code brevity.
 */

@property id<DeviceCommonInfoInterface, ActivityMonitorProtocol> activityMonitor;


/**
 * The local database that will be used for storage of the data retrieved from the
 * devices during polling.
 */

@property DBManager *database;


/**
 * This flag is set once a low battery indication has happened.  The default for the
 * battery alert is 20% of battery left on one of the devices.
 */

@property BOOL batteryAlertGiven;


/**
 * This flag determines whether polling will continue.  This can be FALSE when the following
 * conditions exist.  Either of the devices is not connected.  The devices has not been fully
 * discovered.
 */

@property BOOL ableToPoll;


/**
 * This flag is set when the heart monitor is connected and activity monitor are fully discovered.
 */

@property BOOL isHeartMonitorReady;


/**
 * This flag is set when the activity monitor is connected and fully discovered.
 */

@property BOOL isActivityMonitorReady;


/**
 * The current heart rate.  It will be 0 if no heart rate has been detected, or it will stay 
 * at the last value if the heart rate monitor is lost.
 */

@property int currentHeartRate;
 

/**
 * This is the preferred initialization method.  The datastore and the two components are passed
 * so that polling can happen imediately. WARNING:  This initialization method must be used if any
 * polling is to occur.
 *
 * @param dataStore The database manager that will be used for local storage of the data.
 *
 * @param newDeviceManager The device manager that is to maintain the connectivity of the devices.
 *
 * @return An instance of the device poller which contains everything that is needed to run.
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
 */

-(void) didReceiveNotificationDeviceConnected;


/**
 * This method is used to tell the device poller to stop monitoring the selected monitors.
 */

-(void) stopMonitoring;


/**
 * This method pushes notifications that the battery is low for one of the devices.
 *
 * @param device The bluetooth device that is low on battery.
 */

-(void) doBatteryLowNotificationFor: (id<DeviceCommonInfoInterface>) device;
@end
