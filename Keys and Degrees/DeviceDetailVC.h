//
//  DeviceDetailVC.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "BTDeviceInfo.h"
#import "DeviceManager.h"

@interface DeviceDetailVC : UIViewController <AVAudioPlayerDelegate>

@property DeviceManager *btManager;
@property (nonatomic, retain) IBOutlet UILabel *distanceDisplay;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;
@property (nonatomic, retain) IBOutlet UISwitch *soundSelect;
@property BOOL useSounds;

-(NSInteger) calculateDistanceWithTXPwr: (NSInteger) power;
-(IBAction)changeSoundSetting:(id)sender;
-(void) flashTheScreen;
@end
