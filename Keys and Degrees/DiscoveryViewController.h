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

@protocol DeviceDataSourceProtocol <NSObject>

-(void) updateDeviceListing:(BTDeviceInfo*) newListing;

@end

@interface DiscoveryViewController : UITableViewController

@property (retain) DiscoveryController *bluetoothSearchBox;
@property (retain) NSArray *devices;
@property (nonatomic,assign) id deviceDataSourceDelegate;
@property (nonatomic, retain) BTDeviceInfo *selectedDevice;

-(void) receivedNotificationOfBTDiscovery;

@end
