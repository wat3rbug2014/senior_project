//
//  HomeScreenVC.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"


@interface HomeScreenVC : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *heartRateButton;
@property (retain, nonatomic) IBOutlet UIButton *activityButton;
@property (retain, nonatomic) IBOutlet UIButton *graphButton;
@property (retain, nonatomic) IBOutlet UIButton *toggleRunButton;
@property BOOL isMonitoring;
@property (retain) BTDeviceManager *btDevices;


-(IBAction)selectHeartMonitor:(id)sender;
-(IBAction)selectActivityMonitor:(id)sender;
-(IBAction)showGraph:(id)sender;
-(IBAction)toggleMonitoring:(id)sender;

@end
