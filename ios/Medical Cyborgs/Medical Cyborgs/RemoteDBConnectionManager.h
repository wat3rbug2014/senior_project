//
//  RemoteDBConnectionManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/13/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalInfo.h"

@interface RemoteDBConnectionManager : NSObject <NSURLConnectionDataDelegate>

@property PersonalInfo *patient;
//@property (nonatomic,weak) id<PatientModelProtocol> delegate;

/**
 * This method reaches the remote database and performs several queries.
 * It performs a select based on the patient information that is passed to the method
 * and if one exists then it updates the reference.  If it does not, then one is created
 * from another query to the database and then the result is passed to the PersonalInfo
 * object.  If a nil object is passed to the method, the result is NO.
 *
 * @param newPatient The Patient Information object which needs a patient ID.
 * @return YES is successful and NO if not.
 */

-(BOOL) patientIDUpdateSuccess: (PersonalInfo*) newPatient;

@end
