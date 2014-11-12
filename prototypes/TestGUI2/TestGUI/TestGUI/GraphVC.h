//
//  GraphVC.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDeviceManager.h"

@interface GraphVC : UIViewController

@property BTDeviceManager *deviceManager;

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager;

@end
