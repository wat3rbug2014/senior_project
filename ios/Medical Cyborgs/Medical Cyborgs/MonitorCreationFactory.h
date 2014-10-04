//
//  MonitorCreationFactory.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/4/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MonitorCreationFactory : NSObject

+(id) createFromPeripheral: (CBPeripheral*) peripheral;

@end