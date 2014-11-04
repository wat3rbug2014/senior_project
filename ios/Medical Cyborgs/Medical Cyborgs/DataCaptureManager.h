//
//  DataCaptureController.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/2/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This class does the overall management for device polling, server updates
 * and location awareness and reporting.  It does the overall management because
 * I need one controller that the AppDelegate uses for calling.  It is intended
 * to be a singleton object.  It has functions that are called when the application
 * is in the 3 modes of operation for the application: Baackground, Inactive and Active
 * states of operation.  These 3 modes have various restrictions on functions, so 
 * this class is designed to support those restrictions.
 */
#import <Foundation/Foundation.h>
#import "DevicePollManager.h"
#import "RemoteDBConnectionManager.h"
#import "BTDeviceManager.h"


@interface DataCaptureManager : NSObject

@property (strong) DevicePollManager *devicePoller;
@property (strong) RemoteDBConnectionManager *networkServerPoller;
@property (strong) BTDeviceManager *btManager;


+(id) sharedManager;
-(BOOL) heartMonitorIsConnected;
-(BOOL) activityMonitorIsConnected;

@end
