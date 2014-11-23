//
//  HomeScreenVC.h
//  Medical Cyborgs Project
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This is the first screen you see when the application starts. It
 * provides buttons to navigate through device selection, patient
 * information setup and toggle the monitoring for the application.
 */

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"
#import "PersonalInfo.h"
#import "DevicePollManager.h"
#import "RemoteDBConnectionManager.h"
#import "PatientInformationVC.h"
#import "BackgroundScheduler.h"

@interface HomeScreenVC : UIViewController



/**
 * The UIButton for going to the viewcontroller that provides selection for the 
 * heart rate device to use.
 */

@property (retain, nonatomic) IBOutlet UIButton *heartRateButton;


/**
 * The UIButton for going to the viewcontroller that provides selection for the
 * activity device to use.
 */

@property (retain, nonatomic) IBOutlet UIButton *activityButton;


/**
 * The UIButton for going to the viewcontroller a display of the heart rate and
 * activity so that verification of the devices operation can be done.
 */

@property (retain, nonatomic) IBOutlet UIButton *graphButton;


/**
 * The UIButton for toggling the tracking of the patients activity and heart rates
 * along with location.
 */

@property (retain, nonatomic) IBOutlet UIButton *toggleRunButton;


/**
 * The UIButton for going to the viewcontroller that provides input for the patient
 * identifcation in the system.
 */

@property (retain, nonatomic) IBOutlet UIButton *personalInfoButton;


/**
 * A BOOL to verify the state the application is in, whether it is currently monitoring, or
 * not.  It is used to toggling the color of the run button as well as starting and stopping
 * the background scheduler tasks.
 */

@property BOOL isMonitoring;


/**
 * The view controller for the patient identifcation editing.  A reference is kept for
 * updates to the buttons so that color changes relate properly to database updates.
 */

@property PatientInformationVC *settings;


/**
 * The blue tooth device manager.
 */

@property (retain) BTDeviceManager *btDevices;


/**
 * The object that updates the patient information in local storage for application restarts.
 */

@property (retain) PersonalInfo *patientInfo;


/**
 * The polling that gets information from the devices and places it in the database.  This is used
 * by the GraphVC for observing the heart rate and activity for verification.
 */

@property (retain) DevicePollManager *devicePoller;


/**
 * The poller that retrieves data from the local database nad pushes it to the server.
 */

@property (retain) RemoteDBConnectionManager *serverPoller;


/**
 * The background scheduler that is used for monitoring the patient and passing the data
 * to the local database and eventually to the remote server.
 */

@property BackgroundScheduler *scheduler;


/**
 * This is the preferred method of initialization of the object.  The scheduler
 * has all the necessary information for the homescreen to pass on to the other view controllers
 * and to allow monitoring control.
 *
 * @param scheduler The background scheduler that has all the necessary information. 
 *
 * @return The Home screen of the application with the necessary controllers to perform operation.
 */

-(id) initWithBackgroundScheduler: (BackgroundScheduler*) scheduler;

/**
 * This method sets up the UIViewController to display the personal settings page.
 * It is a standard IBAction style of method with the signature of (id) sender
 * and a void return value noted as IBAction for use in the interface builder.
 *
 * @param sender is not used.
 */

-(IBAction)alterPersonalSettings:(id)sender;


/**
 * This method sets up the UIViewController to display the activity monitor selection
 * page. It is a standard IBAction style of method with the signature of (id) sender
 * and a void return value noted as IBAction for use in the interface builder.
 *
 * @param sender is not used.
 */

-(IBAction)selectActivityMonitor:(id)sender;


/**
 * This method sets up the UIViewController to display the heart monitor selection
 * page. It is a standard IBAction style of method with the signature of (id) sender
 * and a void return value noted as IBAction for use in the interface builder.
 *
 * @param sender is not used.
 */

-(IBAction)selectHeartMonitor:(id)sender;


/**
 * This method changes the color of the button based on whether that function
 * has been configured for use.  If the function is not ready the button will
 * get a red hue, otherwise it will get a green hue.
 *
 * @param button The UIButton that will be modified for the color change.  If none
 *          provided no change takes place.
 * @param ready The ready state.  The default is NO.
 */

-(void) setColorForButton:(UIButton*) button isReady: (BOOL) ready;


/**
 * This method sets up the UIViewController to display the graph page.  This page
 * will only display if the other devices are connected.  Its purpose is to show
 * real time collection of data. It is a standard IBAction style of method with the 
 * signature of (id) sender and a void return value noted as IBAction for use in the 
 * interface builder.
 *
 * @param sender is not used.
 */

-(IBAction)showGraph:(id)sender;


/**
 * This method starts and stops the actual monitoring process.  It does the setup and
 * tear down of the backgroun thread that pulls information from the devices at certain
 * intervals and uploads to the remote database at other intervals. It is a standard 
 * IBAction style of method with the signature of (id) sender and a void return value 
 * noted as IBAction for use in the interface builder.
 *
 * @param sender is not used.
 */

-(IBAction)toggleMonitoring:(id)sender;

/**
 * This method checks to see if the patientID has been updated.  It is used because
 * of the network delay and the delay for the userdefaults on synchronization.
 */

-(void) checkForUpdatedPatientID;


/**
 * This method is called when a notification is given by the device poller.  It determines
 * how the UI is to respond to the event.
 *
 * @param notification  The notification that is passed to it.
 */

-(void) pollFailed:(NSNotification*) notification;

@end
