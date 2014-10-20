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

#define NO_BATTERY_VALUE 0
#define BATTERY_LOW_NOTIFCATION_STR @"Battery Level Low"

@protocol DeviceConnection <CBPeripheralDelegate>

@required


/**
 * This initialization method creates the desired device based on the CBPeripheral that is discovered.
 * It is common to all types of devices and will probably bypass very use of the standard init method
 * for those classes.  This method is used by the MonitorCreationFactory as a standard for initializing
 * the device and providing all of the methods in this protocol.
 *
 * @param CBPeripheral is the device object that the CBCentralManager discovered.
 * @return id<DeviceConnection> This object is any class that conforms to the DeviceConnection protocol.
 */

-(id<DeviceConnection>) initWithPeripheral: (CBPeripheral*) peripheral;


/**
 * This method does a check to see if the the device is actually connected and returns a value of
 * TRUE if it is currently connected.  If the Device is in the CBPeripheralDeviceIsConnecting state,
 * the return value is FALSE.
 *
 * @return TRUE or FALSE value if the device is connected.
 */

-(BOOL) isConnected;


/**
 * This method returns the data to be received.  Because the default datatype from the CBperipheral method
 * is NSData, this is left to keep consistency across all classes that use this interface.  For more
 * specific breakdown of the data see the classes that use this protocol for other methods.  It is noted that
 * no conversion has been performed on the data and the Endianness is undetermined.
 *
 * @return NSData The raw data received from the device without any filtration or conversion.
 */

-(NSData*) getData;


/**
 * This method retrieves the battery level as expressed as a percent integer.  It assumed that a
 * updateBatteryLevel call was made, otherwise the last known value is returned.
 *
 * @return NSInteger value from 0 to 100 expressing the percent of charge. 0 is default for unread
 * or unreadable battery level characteristic.
 */

-(NSInteger) updatedBatteryLevel;


/**
 * This method forces the device to read and broadcast the battery level.
 */

-(void) updateBatteryLevel;


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


@optional


 /**
  * This method is used to fill in details in the discovery view table.  It is optional.
  *
  * @return This NSString value that the device broadcast for the manufacturer name in the
  *         Device Information characteristic.  Not all devices have this information.
  */

-(NSString*) manufacturer;

@end
