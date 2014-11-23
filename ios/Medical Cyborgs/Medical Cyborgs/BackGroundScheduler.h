//
//  BackGroundScheduler.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/** 
 * This object is responsible for the coordination of the device poller, the
 * database manager, and the process that pushes data to the remote server.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"
#import "RemoteDBConnectionManager.h"
#import "DevicePollManager.h"
#import "DBManager.h"
#import "PersonalInfo.h"

@interface BackgroundScheduler : NSObject



/**
 * The device manager used for controlling the device connectivity and discovery.
 */

@property (strong) BTDeviceManager *deviceManager;


/**
 * The manager of the remote server pushes.  It controlls connectivity to the 
 * server and pushes thdata to it.
 */

@property RemoteDBConnectionManager *serverPoller;


/**
 * The object that controlls the polling of the devices and pushes the data to 
 * the local database.
 */

@property DevicePollManager *devicePoller;


/**
 * The local database to store data from the devices during polling.
 */

@property DBManager *database;


/**
 * The patient data object.  It is used by the database for updates to the table and by
 * the server poller for pushes to the server.
 */

@property PersonalInfo *patient;


/**
 * This flag is used by the scheduler to determine if the application is ready to monitor.
 * It is not TRUE if the following conditions are not met.  Both the activity and the heart
 * rate devices must have been selected and connected.  The location manager must be allowed
 * to collection location updates.
 */

@property BOOL allowMonitoring;


/**
 * The run loop for which the polling is to be executed on.
 */

@property NSRunLoop *runLoop;


/**
 * The device polling interval.  Used for controlling the time between poll requests from the
 * devices.  This is expressed in seconds and the default is 5 seconds.
 */

@property NSTimeInterval devicePollInterval;


/**
 * The server polling interval.  Used for controlling when the server will receive updates from
 * the local database.  The default is 1 minute or 60 seconds.  It is express in seconds.
 */

@property NSTimeInterval serverPollInterval;

/**
 * The shared instance of the UIApplication.  It is used for determining the state of the application
 * in order to execute the polling.
 */

@property (readonly) UIApplication *app;


/**
 * The timer used for the device poller.  The reference is stored so that it can be canceled outside
 * of the method that invokes it.
 */

@property NSTimer *devicePollTimer;


/**
 * The timer used for the server poller.  The reference is stored so that it can be canceled outside
 * of the method that invokes it.
 */

@property NSTimer *serverPollTimer;

/**
 * This methods starts the polling process.  It checks the devices for updated
 * information and passes them to the database for updates.  It also performs
 * network updates to the server based on what it finds in the local datbase.
 *
 * @param identifier The patientID that will be used for polling.
 */

-(void) startMonitoringWithPatientID:(NSInteger) identifier;


/**
 * This method stops the polling process.  It kills the timers and does a final update
 * to the remote server using all the data in the database.
 */

-(void) stopMonitoring;


/**
 * This method does the actual polling of the devices and updating the database.
 */

-(void) performScan;

/**
 * This method returns the shared instance of the UIApplication.  It is placed here
 * to make dependency more obvious.
 */

-(UIApplication*) app;

@end
