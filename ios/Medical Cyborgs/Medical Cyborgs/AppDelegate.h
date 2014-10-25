//
//  AppDelegate.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/2/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "BTDeviceManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CoreDataHelper *coreDataHelper;
@property (strong, nonatomic) BTDeviceManager *deviceManager;

@end

