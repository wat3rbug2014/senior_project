//
//  GraphVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "VCWithSounds.h"
#import "BTDeviceManager.h"


@interface GraphVC : VCWithSounds

@property BTDeviceManager *deviceManager;


/**
 * Creates a device selection view controller.  The purpose of the method
 * is to create a standard initialization process for the subclasses of this
 * class.  All of the subclasses require a bluetooth device manager and need
 * to be active to start building the view.  The BTDeviceManager functions
 * as the datasource for this viewcontroller.
 *
 * @param newDeviceManager the bluetooth device manager that will serve as the
 *          data source.
 * @return Returns a view controller unless no device manager is given, then
 *          the result is nil.
 */

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager;

@end
