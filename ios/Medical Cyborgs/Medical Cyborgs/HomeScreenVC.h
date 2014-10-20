//
//  HomeScreenVC.h
//  Medical Cyborgs Project
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"
#import "PersonalInfo.h"
#import <AVFoundation/AVFoundation.h>


@interface HomeScreenVC : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *heartRateButton;
@property (retain, nonatomic) IBOutlet UIButton *activityButton;
@property (retain, nonatomic) IBOutlet UIButton *graphButton;
@property (retain, nonatomic) IBOutlet UIButton *toggleRunButton;
@property (retain, nonatomic) IBOutlet UIButton *personalInfoButton;
@property BOOL isMonitoring;
@property (retain) BTDeviceManager *btDevices;
@property (retain) PersonalInfo *patientInfo;
@property AVAudioPlayer *soundPlayer;


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
 * This method is used for audio cue that a button has been selected.
 */

-(void) playClickSound;

@end
