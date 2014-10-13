//
//  PersonalInfo.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "PersonalInfo.h"

@implementation PersonalInfo

@synthesize patientID;
@synthesize firstName;
@synthesize lastName;
@synthesize dob;
@synthesize personalData;
@synthesize defaults;

-(id) init {
    
    if (self = [super init]) {
        defaults = [NSUserDefaults standardUserDefaults];
        personalData = [defaults dictionaryForKey:USER_DEFAULT_KEY];
        [self loadInformation];
    }
    return self;
}

-(void) dealloc {
    
    [self saveInformation];
}

-(void) loadInformation {
    
    [self setFirstName:[self.personalData objectForKey:F_NAME]];
    [self setLastName:[self.personalData objectForKey:L_NAME]];
    [self setPatientID:[self.personalData objectForKey:PATIENT_ID]];
    [self setDob:[self.personalData objectForKey:DOB]];
}

-(void) saveInformation {
    
    NSMutableDictionary *updatedInfo = [NSMutableDictionary dictionaryWithDictionary:personalData];
    [updatedInfo setObject:firstName forKey:F_NAME];
    [updatedInfo setObject:lastName forKey:L_NAME];
    [updatedInfo setObject:dob forKey:DOB];
    [updatedInfo setObject:patientID forKey:PATIENT_ID];
    [defaults setObject:updatedInfo forKey:USER_DEFAULT_KEY];
    [defaults synchronize];
}
@end
