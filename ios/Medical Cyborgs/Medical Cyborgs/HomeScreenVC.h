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

@property (retain, nonatomic) IBOutlet UIButton *heartRateButton;
@property (retain, nonatomic) IBOutlet UIButton *activityButton;
@property (retain, nonatomic) IBOutlet UIButton *graphButton;
@property (retain, nonatomic) IBOutlet UIButton *toggleRunButton;
@property (retain, nonatomic) IBOutlet UIButton *personalInfoButton;
@property BOOL isMonitoring;
@property PatientInformationVC *settings;
@property (retain) BTDeviceManager *btDevices;
@property (retain) PersonalInfo *patientInfo;
@property (retain) DevicePollManager *devicePoller;
@property (retain) RemoteDBConnectionManager *serverPoller;
@property BackgroundScheduler *scheduler;


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
 */

-(void) pollFailed: (NSNotification*) notification;

@end
