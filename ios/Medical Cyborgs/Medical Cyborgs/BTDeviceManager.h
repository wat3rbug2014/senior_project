//
//  BTDummyData.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FitBitFlex.h"
#import "JawboneUP24.h"
#import "PolarH7.h"
#import "WahooTickrX.h"
#import "DeviceTypes.h"

#define DEVICE_NUM 3


@interface BTDeviceManager : NSObject <CBCentralManagerDelegate>


@property NSArray *heartDevices;
@property NSArray *activityDevices;
@property NSInteger selectedIndexForHeartMonitor;
@property NSInteger selectedIndexForActivityMonitor;
@property BOOL heartMonitorIsConnected;
@property BOOL activityMonitorIsConnected;
@property BOOL isActive;
@property NSInteger searchType;
@property (retain) CBCentralManager *manager;


/**
 * This function starts the discovery process based on the type of device
 * it is looking to find.  At this time there is HEART_MONITOR and ACTIVITY_MONITOR
 * types.
 *
 * @param The integer that designates whether a heart monitor or an activity monitor
 *          will be the attempt to discover.
 */

-(NSInteger) discoveredDevicesForType: (NSInteger) type;


/**
 * This returns the device object based on the index and the device type that discovery is done to obtain.
 * The monitor type is an integer based on the constants found in DeviceTypes.h.
 *
 * @param index is the index from the table which is in sync with the array of devices that have been discovered.
 * @param type it the integer value that determines which array to retrieve the device class.
 * @return Returns the device object that correlates to the DeviceConnection protocol.
 */

-(id) deviceAtIndex: (NSInteger) index forMonitorType: (NSInteger) type;


/**
 * This function returns the count of the number of devices found during the discovery process of either the
 * heart monitor or activity monitor discovery.  Accepted types are to be found in DeviceTypes.h
 *
 * @param An integer result of the count of devices that have been found.
 */

-(void) discoverDevicesForType: (NSInteger) type;


/**
 * This function allows remote shutdown of discovery process to conserve the battery.  Its purpose is to allow
 * the dismissal of selection viewcontrollers to shut the discovery because the devicemanager class is shared
 * throughout the application.
 */

-(void) stopScan;


/**
 * This method is to tidy up after a device selection screen.  In order to get device details
 * all the devices that werte scanned have to be connected.  Since only one is connected during
 * the monitoring process the others need to disconnect.  Only those device types are disconnected.
 *
 * @param type The device type as designated by the DeviceTypes.h file.
 */

-(void) disconnectDevicesForType: (NSInteger) type;

@end
