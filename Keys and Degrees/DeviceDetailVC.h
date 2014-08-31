//
//  DeviceDetailVC.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTDeviceInfo.h"

@interface DeviceDetailVC : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, retain) IBOutlet UISwitch *soundSelect;
@property (nonatomic, retain) IBOutlet UILabel *soundSelectDisplay;
@property BOOL useSounds;
@property (nonatomic, retain) BTDeviceInfo *bluetoothPeripheral;
@property CBCentralManager *btManager;

-(IBAction)changeSoundSetting:(id)sender;
@end
