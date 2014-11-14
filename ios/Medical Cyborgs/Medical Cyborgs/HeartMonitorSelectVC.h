//
//  HeartMonitorSelectVCViewController.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This screen does the device selection for devices that have been discovered
 * that perform heart monitoring functions.
 */

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"
#import <AVFoundation/AVFoundation.h>
#import "TableVCWithSoundsT.h"

@interface HeartMonitorSelectVC : TableVCWithSoundsT

@property BTDeviceManager *deviceManager;



@end
