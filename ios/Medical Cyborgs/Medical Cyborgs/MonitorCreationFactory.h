//
//  MonitorCreationFactory.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This class is a factory.  The purpose is to use polymorphic behavior in the creation
 * of the device classes without the calling class having to know the details.  The setup
 * details are in the createFromPeripheral method.
 *
 * NOTE: In order to add more devices to this application the following must be done.
 *
 * 1.  A class for that device must be created.
 * 2.  The class must at a minimum follow and implement the methods in the DeviceConnection
 *     protocol.
 * 3.  If the device does heart monitoring it must use the methods in the HeartMonitorProtocol.
 * 4.  If the device does activity monitoring it must use the methods in the
 *     ActivityMonitorProtocol.
 * 5.  The +(id<DeviceConnection>) createFromPeripheral: (CBPeripheral*) peripheral must
 * be updated
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceConnection.h"

@interface MonitorCreationFactory : NSObject


/**
 * Creates a device object based on the peripheral supplied.  There are a few assumptions.
 * The first assumption is that there is a class for the type of device to be created.  The
 * second assumption is that this method properly identifies the type of device that fits the class
 * and finally that the class is in the import section above this comment.  This method does NOT
 * always produce an object and so a check to see if the return is nil is needed.  This is to
 * prevent the false positives sometimes created from the scanning process.
 *
 * @param peripheral is the device bluetooth device peripheral object that is passed from the device
 *          manager.
 * @return The return is an object of the class that fits in the DeviceConnection protocol.  All devices
 *          must follow the protocol for proper utilization and to prevent runtime crashes.  The return value
 *          must be checked for nil cases.
 */

+(id<DeviceConnection>) createFromPeripheral: (CBPeripheral*) peripheral;

@end
