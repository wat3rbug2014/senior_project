//
//  HeartMonitorProtocol.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/20/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This protocol is designed to be used on all heart rate monitor devices.
 * The methods enclosed ensure uniform operation with the application, irrespective
 * of the specific device.  It is used for polling so that all modifications are to the 
 * specific device and do not have cascading effects to the other devices.
 */

#import <Foundation/Foundation.h>

@protocol HeartMonitorProtocol <NSObject>

/**
 * This method gets the current heart rate value from the monitor that utilizes this 
 * protocol.
 *
 * @return An integer of the currently record heart rate from the heart rate monitor.
 */

-(NSInteger) getHeartRate;

@end
