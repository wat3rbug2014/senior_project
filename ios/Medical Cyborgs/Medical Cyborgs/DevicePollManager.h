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
#import "DeviceConnection.h"
#import "PersonalInfo.h"

@interface DevicePollManager : NSObject


@property (retain) id<DeviceConnection> heartMonitor;
@property (retain) id<DeviceConnection> activityMonitor;
@property (retain) NSData *database;
@property PersonalInfo *patientInfo;
@property NSInteger patientID;


/**
 * This is the preferred initialization method.  The datastore and the two components are passed
 * so that polling can happen imediately. WARNING:  This initialization method must be used if any
 * polling is to occur.
 */

-(id) initWithDataStore:(NSData*) dataStore heartMonitor: (id) newHeartMonitor activityMonitor: (id) newActivityMonitor;


/**
 * This method is used to get information from the devices. If the devices have not been added with the
 * initWithDataStore: heartMonitor: activityMonitor: no updates will occur.  The appropriate data is
 * pulled from the devices for monitoring.  The battery level, if readable is also polled.  If the 
 * battery is below 20% a notification will be posted to the NSNotificationCenter.
 */

-(void) pollDevicesForData;
@end
