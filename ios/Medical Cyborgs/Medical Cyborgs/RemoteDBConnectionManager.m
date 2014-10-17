//
//  RemoteDBConnectionManager.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "RemoteDBConnectionManager.h"

@implementation RemoteDBConnectionManager

@synthesize patient;
//@synthesize delegate;

-(id) init {
    
    if (self = [super init]) {
        patient = nil;
    }
    return self;
}

-(BOOL) patientIDUpdateSuccess:(PersonalInfo *)newPatient {
    
    BOOL result = NO;
    if (newPatient == nil) {
        return result;
    }
    patient = newPatient;
    NSString *findOldID = [NSString stringWithFormat:
            @"SELECT PATIENT_ID FROM PATIENTS WHERE FIRST_NAME='%@' AND LAST_NAME='%@' AND DOB='%@'",
            [patient firstName], [patient lastName], [patient dob]];
    
    return result;
}
@end
