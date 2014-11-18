//
//  BTDummyData.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This manager handles the overall connection and discovery of the bluetooth
 * devices.  It performs scanning, connectivity and management of the devices for
 * the selection view controllers.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceTypes.h"
#import "DeviceCommonInfoInterface.h"
#import "HeartMonitorProtocol.h"
#import "ActivityMonitorProtocol.h"
#import "DeviceConstantsAndStaticFunctions.h"
#import "BTDeviceManagerDelegate.h"


@interface BTDeviceManager : NSObject <CBCentralManagerDelegate>


@property id<HeartMonitorProtocol, DeviceCommonInfoInterface> _selectedHeartMonitor;
@property id<ActivityMonitorProtocol, DeviceCommonInfoInterface> _selectedActivityMonitor;
@property NSArray *heartDevices;
@property NSArray *activityDevices;
@property NSInteger selectedIndexForHeartMonitor;
@property NSInteger selectedIndexForActivityMonitor;
@property BOOL isInDiscoveryMode;
@property (retain) CBCentralManager *manager;
@property NSInteger searchType;
@property BOOL isActive;
@property NSTimer *waitForDevices;
@property NSRunLoop *runLoop;
@property (nonatomic, weak) id delegate;
@property NSInteger discoveryCount;


/**
 * This method starts the scanning process for a particular type of device. See
 * DeviceTypes.h for values relating to the kind of device to scan.
 *
 * @param type The integer value representing the kind of services to scan and discover.
 */

-(void) startScanForType: (NSInteger) type;


/**
 * This is the preferred method of initialization.  This object is treated as a singleton 
 * because nil objects and other conflicts will result from using more than one instance of
 * a CBCentral object, which is included in this object.
 *
 * @return The shared instance of a BTDeviceManager.
 */

+(id) sharedManager;

/**
 * This function gives the current count of the number of devices found in the 
 * discovery process based on the type of device it is looking to find.  At this 
 * time there is HEART_MONITOR and ACTIVITY_MONITOR types.  See DeviceTypes.h for more
 * details.
 *
 * @param type The integer that designates whether a heart monitor or an activity monitor
 *          will be the attempt to discover.
 *
 * @return The number of devices found.
 */

-(NSInteger) discoveredDevicesForType: (NSInteger) type;


/**
 * This function allows remote shutdown of discovery process to conserve the battery.  Its purpose is to allow
 * the dismissal of selection viewcontrollers to shut the discovery because the devicemanager class is shared
 * throughout the application.
 */

-(void) stopScan;


/**
 * This method is for disconnecting the devices that are used for monitoring.  Both this method and the 
 * connect Monitors are meant to keep the battery lasting longer by not keeping connectivity when not in use.
 */
 
-(void) disconnectSelectedMonitors;


/**
 * This method connects the monitoring devices that have been selected from the various other views.
 * It is used for the device poller to initiate the polling
 */

-(void) connectSelectedMonitors;


/** 
 * This method is used to go through disconnecting every device after discovery.  It is used when the viewcontrollers
 * are being dismissed and the scanning is stopped.  In order to discover all the characteristics needed for
 * operation in other parts of the application, things like battery service, heart rate measurements etc must be
 * discovered and that can only happen when the devices are connected.
 */

-(void) disconnectAllDevices;

/**
 * This method is to be used by the tableviews so that individual devices can be selected and the appropriate
 * variables updated to reflect it.
 *
 * @param type The device type to select.  See DeviceTypes.h for details.
 *
 * @param index The index of the array of devices within a particular type.
 */

-(void) selectDeviceType: (NSInteger) type atIndex:(NSInteger) index;


/**
 * This method is to be used by the tableviews so that individual devices can be deselected and the appropriate
 * variables updated to reflect it.
 *
 * @param type The device type to deselect.  See DeviceTypes.h for details.
 */

-(void) deselectDeviceType: (NSInteger) type;


/**
 * This method is used by the tableview to get the devices that they need to query for their
 * views.
 *
 * @param index The index within the device types that are the same.
 *
 * @param type The device type that the search is restricted to performing.
 *
 * @return The device that is selected.  The DeviceCommonInfoInterface is the
 *  restrictor and all devices must conform to this protocol, otherwise the result is
 * nil.
 */

-(id<DeviceCommonInfoInterface>) deviceAtIndex: (NSInteger) index forType: (NSInteger) type;


-(id<DeviceCommonInfoInterface>) monitorMatchingCBPeripheral: (CBPeripheral*) device;


/**
 * This getter returns the current selectedHeartMonitor.  The reference conforms to the
 * HeartMonitorProtocol and the DeviceCommonInfoInterface protocol.
 *
 * @return the object reference for the heart monitor.  A check for nil is necessary because
 * it is possible to deselect the heart monitor.
 */

-(id<HeartMonitorProtocol, DeviceCommonInfoInterface>) selectedHeartMonitor;


/**
 * This setter updates the selectedHeartMonitor as long as it conforms to the 
 * HeartMonitorProtocol and the DeviceCommonInfoInterface.  It also notifies that delegate
 * that the value has changed.
 */

-(void) setSelectedHeartMonitor: (id<HeartMonitorProtocol, DeviceCommonInfoInterface>) selectedHeartMonitor;


/**
 * This getter returns the current selectedActivityMonitor.  The reference conforms to the
 * ActivityMonitorProtocol and the DeviceCommonInfoInterface protocol.
 *
 * @return the object reference for the activity monitor.  A check for nil is necessary because
 * it is possible to deselect the activity monitor.
 */

-(id<ActivityMonitorProtocol, DeviceCommonInfoInterface>) selectedActivityMonitor;


/**
 * This setter updates the selectedActivityMonitor as long as it conforms to the
 * ActivityMonitorProtocol and the DeviceCommonInfoInterface.  It also notifies that delegate
 * that the value has changed.
 */

-(void) setSelectedActivityMonitor: (id<ActivityMonitorProtocol, DeviceCommonInfoInterface>) selectedActivityMonitor;

@end
