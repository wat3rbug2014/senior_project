//
//  DeviceDetailVC.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceDetailVC : UIViewController

@property (nonatomic, retain) IBOutlet UISwitch *soundSelect;
@property (nonatomic, retain) IBOutlet UILabel *soundSelectDisplay;
@property BOOL useSounds;

-(IBAction)changeSoundSetting:(id)sender;
@end
