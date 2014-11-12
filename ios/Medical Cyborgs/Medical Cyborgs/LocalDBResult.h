//
//  LocalDBResult.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This is a simple data class that is used to pass around from the
 * database to classes that are using it.  It was created to simply string 
 * manipulation.
 */

#import <Foundation/Foundation.h>

@interface LocalDBResult : NSObject

@property NSInteger patientID;
@property NSInteger heartRate;
@property float latitude;
@property float longitude;
@property NSString *timeStamp;

@end
