//
//  PersonalInfo.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USER_DEFAULT_KEY @"Medical Cyborgs User"

/**
 * These constants are added as a way to use autocomplete
 * feature on XCode.
 */

#define F_NAME @"First Name"
#define L_NAME @"Last Name"
#define DOB @"DOB"
#define PATIENT_ID @"patientID"
#define NO_ID_SET -1


@interface PersonalInfo : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSDate *dob;
@property NSNumber* patientID;
@property NSUserDefaults *defaults;
@property NSDictionary *personalData;

-(void) loadInformation;
-(void) saveInformation;

@end
