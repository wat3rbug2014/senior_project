//
//  Things.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceList.h"
#import "DiscoveryViewController.h"
#import "DeviceManager.h"

@interface Things : UITableViewController <DeviceDataSourceProtocol>

@property (nonatomic, assign) id delegate;
@property (retain) DeviceManager *btManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;

-(void) addDevicesToList;

@end
