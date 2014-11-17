//
//  DeviceConnection.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This protocol is created to make an API for the devices so that similar operations can be performed.
 * All of the devices are CBPeripheral devices.  They have different UUIDs for their services and differing
 * characteristics, so their interactions are different.  This API is an attempt to hide the complexity
 * for the sake of brevity in the code and to make things more readable elsewhere.  Device specific 
 * operations are done in the class files associated with the devices.
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceConstantsAndStaticFunctions.h"

@protocol DeviceCommonInfoInterface <CBPeripheralDelegate>

@required


/**
 * This initialization method creates the desired device based on the CBPeripheral that is discovered.
 * It is common to all types of devices and will bypass use of the standard init method
 * for those classes.  This method is used by the MonitorCreationFactory as a standard for initializing
 * the device and providing all of the methods in this protocol.
 *
 * @param CBPeripheral is the device object that the CBCentralManager discovered.
 * @return id<DeviceCommonInfoInterface> This object is any class that conforms to the 
 *          DeviceCommonInfoInterface protocol.
 */

-(id<DeviceCommonInfoInterface>) initWithPeripheral: (CBPeripheral*) peripheral;


/**
 * This method does a check to see if the the device is actually connected and returns a value of
 * TRUE if it is currently connected.  If the Device is in the any other state,
 * the return value is FALSE.
 *
 * @return TRUE or FALSE value if the device is connected.
 */

-(BOOL) isConnected;


/**
 * This method retrieves the battery level as expressed as a percent integer.  It assumed that a
 * updateBatteryLevel call was made, otherwise the last known value is returned.
 *
 * @return NSInteger value from 0 to 100 expressing the percent of charge. 0 is default for unread
 * or unreadable battery level characteristic.
 */

-(int) batteryLevel;


/**
 * This method forces the device to read and broadcast the battery level.
 */

-(void) discoverBatteryLevel;


/**
 * This method returns the device type.  It is used for a shallow query of the object so that it can be placed in
 * correct array of the bluetooth manager.  See DeviceTypes.h for the values.
 *
 * @return Returns an NSInteger that fits within the confines of the DeviceTypes.h file.
 */

-(NSInteger) type;


/**
 * This sets the device type so that the device can be easily placed in the desired array of the controller.
 *
 * @param type is the NSInteger defined from the DeviceTypes.h file.  This field is used to help determine
 *         if a device belongs in the heart monitors array or the activity monitors array.
 */

-(void) setType:(NSInteger) type;

 /**
  * Returns the device name of the CBPeripheral that is in the class of the object.  Created for easy reading
  * and consist access.
  *
  * @return an NSString of the device name.
  */

-(NSString*) name;


/**
 * This method returns the actual CBPeripheral device for use with the device manager in order to manage
 * connectivity to the device.  This object is immutable and does not have hany write characteristics.
 */

-(CBPeripheral*) device;


/**
 * This method forces queries of the device in order to get the applicable data for this device.
 */

-(void) getTableInformation;

/**
 * This method is used to toggle monitoring because the devices can have setup and teardown procedures.
 * @param monitor The state to decide whether to start monitoring or not.
 */

-(void) shouldMonitor: (BOOL) monitor;


/**
 * This method is used to prevent premature interruption of discovery scan.
 *
 * @return YES if all of the services for this device have been discovered.
 */

-(BOOL) discoveryComplete;

@optional


 /**
  * This method is used to fill in details in the discovery view table.  It is optional.
  *
  * @return This NSString value that the device broadcast for the manufacturer name in the
  *         Device Information characteristic.  Not all devices have this information.
  */

-(NSString*) manufacturer;

@end
