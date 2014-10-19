//
//  ActivityMonitorSelectVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "BTDeviceManager.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ActivityMonitorSelectVC : UITableViewController

@property BTDeviceManager *deviceManager;
@property AVAudioPlayer *soundPlayer;

/**
 * Creates a device selection view controller.  The purpose of the method
 * is to create a standard initialization process for the subclasses of this
 * class.  All of the subclasses require a bluetooth device manager and need
 * to be active to start building the view.  The BTDeviceManager functions
 * as the datasource for this tableviewcontroller and all the subclasses.
 *
 * @param newDeviceManager the bluetooth device manager that will serve as the
 *          data source.
 * @return Returns a view controller unless no device manager is given, then
 *          the result is nil.
 */

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager;


/**
 * This method is the default method that is called when the device manager
 * discovers a device. Its intent is to allow the tableview to update since the
 * count of devices has changed and information is available. A table reload is
 * used because the number of items to be discovered is very small and the overhead
 * is small.  Otherwise it is recommended to just reload the section and choose the
 * type of animation.
 *
 * @param notification A NSNotification object, not used at this time.
 */

-(void) updateTable:(NSNotification*) notification;

/**
 * This method is called whenever a cell is selected or deselected.  Its purpose is to
 * play an audio file whenever the selection takes places to give an audio clue that you
 * selected or deselected a device.
 */
-(void) playSelectionSound;

@end
