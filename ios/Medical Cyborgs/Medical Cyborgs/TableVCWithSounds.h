//
//  TableVCWithSoundsTableViewController.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This base class is a viewcontroller with sound implementation.  It allows
 * clicking sounds when a device is selected.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BTDeviceManager.h"

@interface TableVCWithSounds : UITableViewController

@property AVAudioPlayer *soundPlayer;
@property BTDeviceManager *deviceManager;

/**
 * This method is used for audio cue that a view is about to be displayed.
 */

-(void) playViewChangeSound;


/**
 * This method is used to sound the audio cue that the monitoring button has been selected.
 */

-(void) playClickSound;

/**
 * This method is the base method that the others use for playing the audio file.  It does
 * the setup of the audio player and uses the file passed to it for playback.
 * @param soundFile The NSURL of the file to be played.
 */

-(void) playSoundWithFile: (NSURL*) soundFile;


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
 * This function is the default method that is called when the device manager
 * discovers a device. Its intent is to allow the tableview to update since the
 * count of devices has changed and information is available. A table reload is
 * used because the number of items to be discovered is very small and the overhead
 * is small.  Otherwise it is recommended to just reload the section and choose the
 * type of animation.
 *
 * @param notification A NSNotification object, not used at this time.
 */

-(void) updateTable:(NSNotification*) notification;

@end
