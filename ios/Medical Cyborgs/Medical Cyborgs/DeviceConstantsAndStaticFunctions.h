//
//  DeviceConstantsAndStaticFunctions.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/15/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This is a collection constants that are used throughout the application
 * or static functions which can used in several places, but do not show
 * any obvious affinity to a class.
 */

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

typedef enum {
    RESTING = 1,
    WARM_UP = 2,
    ENDURANCE = 3,
    AEROBIC = 4,
    ANAEROBIC = 5,
    PEAK = 6
} ActivityLevel;


/**
 * This method does a calculation of activity level based on the current heart rate and
 * the patients ages.  The result is defined as an ActivityLevel enumeration.
 *
 * @param heartRate The current heart rate.
 *
 * @param age The age of the patient.
 *
 * @return An integer value that correlates with the ActivityLevel enumeration.
 */

+(int) activityLevelBasedOnHeartRate: (NSInteger) heartRate andAge: (NSInteger) age;


/**
 * This method takes the enumeration integer and returns a string value of the activity
 * level.
 *
 * @param activity  An integer that is an ActivityLevel enumeration value.
 *
 * @return A string representation of the ActivityLevel enumeration.
 */

+(NSString*) activityPhraseUsingActivityLevel: (int) activity;

@end
