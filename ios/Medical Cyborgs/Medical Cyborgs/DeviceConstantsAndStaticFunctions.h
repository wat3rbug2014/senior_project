//
//  DeviceConstantsAndStaticFunctions.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/15/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceTypes.h"

@interface DeviceConstantsAndStaticFunctions : NSObject

extern NSString *const BTHeartConnected;
extern NSString *const BTActivityConnected;
extern NSInteger const NONE_SELECTED;
extern NSString * const POLARH7_SERV_UUID;
extern NSString * const POLARH7_HRM_UUID;
extern NSString * const DEVICE_DISCOVERED;
extern NSString * const BATTERY;
extern NSString * const BATTERY_LVL;
extern NSString * const DEVICE_READ_VALUE;

extern NSInteger NO_BATTERY_VALUE; 
extern NSString * const BATTERY_LOW_NOTIFCATION_STR;


+(NSString*) activityPhaseUsingActivityLevel: (int) activity;
+(int) activityLevelBasedOnHeartRate: (NSInteger) heartRate andAge: (NSInteger) age;
@end
