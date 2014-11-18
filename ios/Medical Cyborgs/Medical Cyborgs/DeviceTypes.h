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


typedef enum {
    HEART_MONITOR = 1,
    ACTIVITY_MONITOR = 2,
    HEART_AND_ACTIVITY_MONITOR = 3
} DeviceType;



#endif
