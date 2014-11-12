//
//  PersonalInfo.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This class provides a way to access the stored user information for the
 * application without having to maintain them.  The patient Information
 * will be used every time the application is used, so the code has been
 * centralized so that the data is updated and automatically saved.
 */

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
@property NSInteger patientID;
@property NSUserDefaults *defaults;
@property NSDictionary *personalData;


/**
 * Loads all the information from the application user defaults and stores them in
 * local variables for quicker and easier access.
 */

-(void) loadInformation;


/**
 * Save all the local variables into the user defaults for the application.
 */

-(void) saveInformation;

/**
 * This method is called as part of ARC.  It has been added because the data is saved
 * to the user defaults location before the memory is released so that changes are not 
 * lost.
 */

-(void) dealloc;
@end
