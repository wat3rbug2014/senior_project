//
//  DiscoveryController.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceList.h"
#import "DeviceManager.h"

@protocol DeviceDataSourceProtocol <NSObject>

-(void) passReferenceToBTManager:(DeviceManager*) manager;

@end

@interface DiscoveryViewController : UITableViewController

@property (retain) DeviceManager *bluetoothSearchBox;
@property (nonatomic,assign) id deviceDataSourceDelegate;

-(void) receivedNotificationOfBTDiscovery;

@end
