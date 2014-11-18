//
//  BTDeviceManagerDelegate.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/17/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * The protocol is used for delegate of the BTDeviceManager for callback
 * to notifiy the delegate that changes have been made to selected monitors.
 */

#import <Foundation/Foundation.h>
#import "BTDeviceManager.h"

@protocol BTDeviceManagerDelegate <NSObject>

@required


/**
 * This method is called by the BTDeviceManager after the selectedHeartMonitor
 * or the selectActivityMonitor references have changed.
 */

-(void) deviceManagerDidUpdateMonitors;

@end
