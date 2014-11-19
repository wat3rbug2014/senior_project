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

@property (strong) BTDeviceManager *deviceManager;

@property RemoteDBConnectionManager *serverPoller;
@property DevicePollManager *devicePoller;
@property DBManager *database;
@property PersonalInfo *patient;
@property BOOL allowMonitoring;
@property NSRunLoop *runLoop;
@property NSTimeInterval devicePollInterval;
@property NSTimeInterval serverPollInterval;
@property (readonly) UIApplication *app;
@property NSTimer *devicePollTimer;
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

-(UIApplication*) app;

@end
