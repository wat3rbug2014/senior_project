//
//  LocalDBResult.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDBResult : NSObject

@property NSInteger patientID;
@property NSInteger heartRate;
@property float latitude;
@property float longitude;
@property NSString *timeStamp;

@end
