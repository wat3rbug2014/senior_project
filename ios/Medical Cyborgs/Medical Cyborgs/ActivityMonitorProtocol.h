//
//  ActivityMonitorProtocol.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/28/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
// WARNING: This is under construction because it is not known how the
// activity devices work yet.

#import <Foundation/Foundation.h>

/**
 * This protocol is designed to be used on all activity monitor devices.
 * The methods enclosed ensure uniform operation with the application, irrespective
 * of the specific device.  It is used for polling so that all modifications are to the
 * specific device and do not have cascading effects to the other devices.
 */

@protocol ActivityMonitorProtocol <NSObject>

/**
 * This methods get an activity level.  The result is defined in the DeviceTypes.h file.
 *
 * @return An integer value that corresponds with the activity level constants in DeviceTypes.h
 */

-(NSInteger) getActivityLevel;

@end
