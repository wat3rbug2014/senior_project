//
//  DiscoveryController.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceList.h"
#import "DiscoveryController.h"

@interface DiscoveryViewController : UITableViewController


@property (retain) DeviceList *devices;
@property (retain) DiscoveryController *bluetoothSearchBox;

-(void) receivedNotificationOfBTDiscovery;
@end
