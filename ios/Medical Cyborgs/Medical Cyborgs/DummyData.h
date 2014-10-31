//
//  DummyData.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/28/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This class supplies dummy data for testing of the device pollers
 * and server poller.  Part of the testing is when the phone is locked
 * or the application is in the background.
 */

#import <Foundation/Foundation.h>

@interface DummyData : NSObject


@property (readonly) NSInteger heartRate;
@property (readonly) NSDate *timestamp;
@property (readonly) float latitude;
@property (readonly) float longitude;

@end
