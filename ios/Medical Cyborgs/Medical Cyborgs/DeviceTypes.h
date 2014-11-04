//
//  DeviceTypes.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#ifndef Medical_Cyborgs_DeviceTypes_h
#define Medical_Cyborgs_DeviceTypes_h

/**
 * These constants are used in several view controllers and the device manager.
 * It seemed necessary to keep the definitions in one location to reduce confusion
 * and the possbilility of bugs based on selection criteria for the view controllers.
 */

#define HEART_MONITOR 1
#define ACTIVITY_MONITOR 2
#define HEART_AND_ACTIVITY_MONITOR 3
#define NONE_SELECTED -1

#define BATTERY @"Battery"
#define BATTERY_LVL @"Battery Level"
#define DEVICE_READ_VALUE @"BTDeviceValueUpdated"

typedef enum {
    SLEEPING = 1,
    TROUBLE_SLEEP = 2,
    ACTIVE = 3,
    EXERCISE = 4,
    TRAVEL = 5
} ActivityMode;

#endif
