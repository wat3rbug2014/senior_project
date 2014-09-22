//
//  DeviceSelectionVCTableViewController.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"

@interface DeviceSelectionVC : UITableViewController

@property BTDeviceManager *deviceManager;

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager;

@end
