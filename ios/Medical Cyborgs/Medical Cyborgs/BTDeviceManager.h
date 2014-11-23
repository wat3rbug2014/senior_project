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
 * the selection view controllers.  This class is a singleton object because multiple
 * instances cause problems with false posivitives for device connection and lost information
 * based on OS level caching. 
 * WARNING: Care must be take in assigning the delegate for this object. It is possible to 
 * produce side affects to other objects that are using this manager if care is not taken
 * when updating this instance variable since the delegate can only reference one controlling
 * object.
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


/**
 * The heart monitor that is currently selected.  The value may be nil when nothing is selected
 * and is part of the design.  This variable should only be accessed using selectedHeartMonitor 
 * and setSelectedHeartMonitor because the delegate is notified of any changes to this value.
 */

@property id<HeartMonitorProtocol, DeviceCommonInfoInterface> _selectedHeartMonitor;


/**
 * The activity monitor that is currently selected.  The value may be nil when nothing is selected
 * and is part of the design. This variable should only be accessed using selectedActivityMonitor
 * and setSelectedActivityMonitor because the delegate is notified of any changes to this value.
 */

@property id<ActivityMonitorProtocol, DeviceCommonInfoInterface> _selectedActivityMonitor;


/**
 * The array containing any devices that conform to the HeartMonitorProtocol.  It is used by the
 * heart monitor selection view controller for listing possible devices to use.
 */

@property NSArray *heartDevices;


/**
 * The array containing any devices that conform to the ActivityMonitorProtocol.  It is used by the
 * activity monitor selection view controller for listing possible devices to use.
 */

@property NSArray *activityDevices;


/**
 * The index of the heart monitor device that has been selected.  It is used by the heart monitor
 * select view controller to indicate which one is selected.  If the value is -1, then no device 
 * has been selected.
 */

@property NSInteger selectedIndexForHeartMonitor;


/**
 * The index of the activity monitor device that has been selected.  It is used by the activity monitor
 * select view controller to indicate which one is selected.  If the value is -1, then no device
 * has been selected.
 */

@property NSInteger selectedIndexForActivityMonitor;


/**
 * This flag indicates that the manager is in discovery mode and that addition scans must be performed
 * to get the characteristics and services of the devices as they are discovered and connected.
 */

@property BOOL isInDiscoveryMode;


/**
 * The bluetooth connection manager that tracks the CBPeripherals.
 */

@property (retain) CBCentralManager *manager;


/**
 * This value indicates what services the manager should scan and connect.  For details see DeviceTypes.h
 */

@property NSInteger searchType;


/**
 * This flag is to see if bluetooth use is allowed.  The manager will not be able to perform any operations
 * if the bluetooth service is off or not allowed by the user.
 */

@property BOOL isActive;

/**
 * The timer that is used when the request to stop scanning has been done, but the device that is selected 
 * does not have full discovery done.
 */

@property NSTimer *waitForDevices;


/**
 * The runloop that is used to check for device discovery to see if all characteristics needed have been
 * discovered.  The reference is stated so it can be canceld outside the method that calls it.
 */

@property NSRunLoop *runLoop;


/**
 * The delegate is the object that receives a call back whenever the selected heart monitor or activity monitor
 * has changed.
 */

@property (nonatomic, weak) id delegate;


/**
 * The counter that is used for requesting a new discovery of the device.  The setting is 5 seconds, and then a 
 * rediscovery of the device begins.
 */

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


/**
 * This is a method that is to be used privately in this class.  It's purpose is to parse
 * the list of devices that this manager knows about and return a device object that matches
 * the CBPeripheral identifier.  Since the identifier is a name it is possible to have two
 * duplicate names.  This is a change to CBPeripheral where the name takes precendence over
 * the UUID of the device if it is known.
 *
 * @param device The CBPeripheral that is to be used for the search criteria.
 *
 * @return A device object that conforms to the CommonDeviceInfoInterface.  Additional
 *          introspection will be needed if you wish to see if the device conforms to one of
 *          the other protocols.
 */

-(id<DeviceCommonInfoInterface>) monitorMatchingCBPeripheral: (CBPeripheral*) device;


/**
 * This getter returns the current selectedHeartMonitor.  The reference conforms to the
 * HeartMonitorProtocol and the DeviceCommonInfoInterface protocol.
 *
 * @return the object reference for the heart monitor.  A check for nil is necessary because
 *          it is possible to deselect the heart monitor.
 */

-(id<HeartMonitorProtocol, DeviceCommonInfoInterface>) selectedHeartMonitor;


/**
 * This setter updates the selectedHeartMonitor as long as it conforms to the 
 * HeartMonitorProtocol and the DeviceCommonInfoInterface.  It also notifies that delegate
 * that the value has changed.
 *
 * @param selectedHeartMonitor The heart mo0nitor that has been selected by the view controller.
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
 *
 * @param selectedActivityMonitor The activity monitor that has been selected by the view controller.
 */

-(void) setSelectedActivityMonitor: (id<ActivityMonitorProtocol, DeviceCommonInfoInterface>) selectedActivityMonitor;

@end
