//
//  SettingsVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/9/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This class is the view controller that is used to update the patient information
 *  It updates the database and the PersonalInfo that is stored as standard defaults.
 */

#import <UIKit/UIKit.h>
#import "PersonalInfo.h"

#define MONTH_COMP 0
#define DAY_COMP 1
#define YEAR_COMP 2
#define NONE_FOUND 0


@interface PatientInformationVC : UIViewController <UITextFieldDelegate,NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) IBOutlet UITextField *firstNameEntry;
@property (retain, nonatomic) IBOutlet UITextField *lastNameEntry;
@property (retain, nonatomic) IBOutlet UIDatePicker *dobSelector;
@property (retain, strong) PersonalInfo *patientData;
@property (retain) NSMutableData *_serverResponseData;


/**
 * This method creates a viewcontroller that has the personal information object.  The object queries
 * the device store user default settings and maintains the records.  This information is needed
 * for building the initial view with patient information.
 *
 * @param existingPatientData is the object that contains the patient name, DOB, and ID necessary
 * for the VC to function.
 * @return A viewcontroller that will display the current patient information and allow editing.
 */

-(id) initWithPersonalInformation:(PersonalInfo*) existingPatientData;

/**
 * This method updates the patient information  to reflect the date that is
 * selected from the UIDatePicker object.
 */

-(void) updateDOB;

@end
