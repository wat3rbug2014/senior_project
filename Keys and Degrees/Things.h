//
//  Things.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceList.h"

@interface Things : UITableViewController

@property (nonatomic, retain) DeviceList *deviceDB;
@property (nonatomic, retain) UIBarButtonItem *addButton;

-(void) addDevicesToList;

@end
