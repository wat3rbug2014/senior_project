//
//  GraphVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "VCWithSounds.h"
#import "BTDeviceManager.h"
#import "DevicePollManager.h"


@interface GraphVC : VCWithSounds


@property DevicePollManager *devicePoller;


/**
 * Creates a device selection view controller.  The purpose of the method
 * is to create a standard initialization process for the subclasses of this
 * class.  All of the subclasses require a bluetooth device manager and need
 * to be active to start building the view.  The DevicePollManager functions
 * as the datasource for this viewcontroller.
 *
 * @param newDevicePollManager the bluetooth device poller that will serve as the
 *          data source.
 * @return Returns a view controller unless no device manager is given, then
 *          the result is nil.
 */

-(id) initWithDevicePoller: (DevicePollManager*) devicePoller;

@end
