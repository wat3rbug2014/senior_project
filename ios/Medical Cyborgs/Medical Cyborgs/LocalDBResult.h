//
//  LocalDBResult.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This is a simple data class that is used to pass around from the
 * database to classes that are using it.  It was created to simplify 
 * string manipulation.
 */

#import <Foundation/Foundation.h>

@interface LocalDBResult : NSObject


/**
 * The patientID that is used by the database.
 */

@property NSInteger patientID;


/**
 * The heart rate of the patient as it was recorded by the database.
 */

@property NSInteger heartRate;


/**
 * The latitude of the patient that was recorded.  This value will not
 * change much unless big changes happen.
 */

@property float latitude;


/**
 * The longitude of the patient that was recorded.  This value will not 
 * change much unless big changes happen.
 */

@property float longitude;


/**
 * The timestamp this data was recorded in the database.  It has date and 
 * time.  It follows the format of 'yyyy-mm-dd hh:mm:ss'.  The hours are expressed
 * in military time from 0-23.
 */

@property NSString *timeStamp;


/**
 * An integer value of the activity level based on patient age and heart rate.
 * See DeviceConstantsAndStaticFunctions for a description.
 */

@property NSInteger activityLevel;

@end
