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


NSString *const USER_DEFAULT_KEY = @"Medical Cyborgs User";
NSString * const F_NAME = @"First Name";
NSString * const L_NAME = @"Last Name";
NSString * const DOB = @"DOB";
NSString * const AGE = @"Age";

NSInteger const NO_ID_SET = -1;

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

-(NSInteger) age {
    
    return  [self calculateAgeUsingDate:dob];
}

-(void) loadInformation {
    
    [self setFirstName:[self.personalData objectForKey:F_NAME]];
    [self setLastName:[self.personalData objectForKey:L_NAME]];
    [self setPatientID:[[self.personalData objectForKey:PATIENT_ID] integerValue]];
    if ([self patientID] == 0) {
        [self setPatientID:NO_ID_SET];
    }
    [self setDob:[self.personalData objectForKey:DOB]];
}

-(void) saveInformation {
    
    NSMutableDictionary *updatedInfo = [NSMutableDictionary dictionaryWithDictionary:personalData];
    [updatedInfo setObject:firstName forKey:F_NAME];
    [updatedInfo setObject:lastName forKey:L_NAME];
    [updatedInfo setObject:dob forKey:DOB];
    if (patientID == 0) {
        patientID = NO_ID_SET;
    }
    [updatedInfo setObject:[NSNumber numberWithInteger:patientID] forKey:PATIENT_ID];
    [updatedInfo setObject:[NSNumber numberWithInteger:[self age]] forKey:AGE];
    [defaults setObject:updatedInfo forKey:USER_DEFAULT_KEY];
    [defaults synchronize];
}

-(NSInteger)calculateAgeUsingDate:(NSDate *)currentDOB {
    
    assert(currentDOB != nil);
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
        fromDate:dob toDate:now options:0];
    return [ageComponents year];
}
@end
