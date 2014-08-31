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

-(void) updateDeviceListing:(CBPeripheral*) newListing;

@end

@interface DiscoveryViewController : UITableViewController


@property (retain) NSArray *devices;
@property (retain) DiscoveryController *bluetoothSearchBox;
@property (nonatomic,assign) id deviceDataSourceDelegate;
@property (nonatomic, retain) CBPeripheral *selectedDevice;

-(void) receivedNotificationOfBTDiscovery;
@end
