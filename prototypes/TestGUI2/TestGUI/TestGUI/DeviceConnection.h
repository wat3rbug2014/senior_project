//
//  DeviceConnection.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/* This protocol is created to make an API for the devices so that similar operations can be performed.
 * All of the devices are CBPeripheral devices.  They have different UUIDs for their services and differing
 * charaacteristics, so their interactions are different.  This API is an attempt to hide the complexity
 * for the sake of brevity in the code and to make things more readable elsewhere.  Device specific 
 * operations are done in the class files associated with the devices.
 **/

#import <Foundation/Foundation.h>

@protocol DeviceConnection <NSObject>

@required

/*
 * This method does a check to see if the the device is actually connected and returns a value of
 * TRUE if it is currently connected.
 * @return TRUE or FALSE value if the device is connected.
 **/

-(BOOL) isConnected;

/*
 * This method provides a top level connection mechanism to the device.  Because there is another method
 * for checking the final status of connection, the connection state is not returned.
 **/

-(void) connect;

/*
 * This method provides a top level disconnection mechanism to the device.  Because there is another method
 * for checking the final status of connection, the connection state is not returned.
 **/

-(void) disconnect;

/*
 * This method returns the data to be received.  Because the default datatype from the CBCperipheral method
 * is NSData, this is left to keep consistency across all classes that use this interface.  For more
 * specific breakdown of the data see the classes that use this protocol for other methods.
 **/

-(NSData*) getData;

/*
 * This method returns the battery level expressed as a percentage from 0 to 100.  NSInteger is used to keep
 * platform differences to a minimum.
 **/

-(NSInteger) batteryLevel;

@end
