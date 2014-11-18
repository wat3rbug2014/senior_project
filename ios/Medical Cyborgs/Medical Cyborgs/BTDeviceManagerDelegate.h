//
//  BTDeviceManagerDelegate.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/17/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDeviceManager.h"

@protocol BTDeviceManagerDelegate <NSObject>

@required

-(void) deviceManagerDidUpdateMonitors;

@end
