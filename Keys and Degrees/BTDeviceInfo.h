//
//  BTDeviceInfo.h
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDeviceInfo : NSObject

@property NSString *name;
@property NSString *alias;
@property int temp;
@property BOOL useTemp;
@property NSString *deviceID;

@end
