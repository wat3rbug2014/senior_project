//
//  BackGroundScheduler.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@end
