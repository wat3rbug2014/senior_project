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
 * This method gets the current longitude value from the monitor that utilizes this
 * protocol.
 *
 * @return A float of the current longitude from the activity monitor.
 */

-(float) getLongitude;


/**
 * This method gets the current latitude value from the monitor that utilizes this
 * protocol.
 *
 * @return A float of the current latitude from the activity monitor.
 */

-(float) getLatitude;

@end
