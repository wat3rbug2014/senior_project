//
//  GraphVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This screen displays the output of the monitors in real time.
 */

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"
#import "DevicePollManager.h"
#import "DeviceConstantsAndStaticFunctions.h"
#import "BTDeviceManagerDelegate.h"

@interface GraphVC : UIViewController


/**
 * The device poller that will be used for getting data from the devices for
 * display by the view controller.
 */

@property DevicePollManager *devicePoller;


/**
 * The display that shows the current heart rate.  It defaults to 0 when the view first appears
 * and does not update until a new heart rate has been received.
 */

@property (retain, nonatomic) IBOutlet UILabel *heartRateDisplay;


/**
 * The label that shows a string representation of the value that is calculated based on the
 * age of the patient and the current heart rate.
 */

@property (retain, nonatomic) IBOutlet UILabel *activityDisplay;


/**
 * The timer that calls for the device poller to get information.  It is set for 1 second.
 */

@property NSTimer *displayTimer;


/**
 * The run loop that the device poller uses.  It it reference so that viewWillAppear 
 * can activate it and viewWillDisappear can cancel the runloop.
 */

@property NSRunLoop *runLoop;


/**
 * The local instance of the selectedHeartMonitor from the device poller.  It is made so 
 * that the code is easier to read.
 */

@property id<HeartMonitorProtocol> heartMonitor;


/**
 * The local instance of the selectedActivityMonitor from the device poller.  It is made so
 * that the code is easier to read.
 */

@property id<ActivityMonitorProtocol> activityMonitor;


/**
 * Creates a device selection view controller.  The purpose of the method
 * is to create a standard initialization process for the subclasses of this
 * class.  All of the subclasses require a bluetooth device manager and need
 * to be active to start building the view.  The DevicePollManager functions
 * as the datasource for this viewcontroller.
 *
 * @param devicePoller the bluetooth device poller that will serve as the
 *          data source.
 * @return Returns a view controller unless no device manager is given, then
 *          the result is nil.
 */

-(id) initWithDevicePoller: (DevicePollManager*) devicePoller;


/**
 * This method is used to update the activity level and heart rate on a timed
 * interval.
 */

-(void) updateDisplay;

@end
