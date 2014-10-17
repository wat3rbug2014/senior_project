//
//  SettingsVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/9/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfo.h"

#define MONTH_COMP 0
#define DAY_COMP 1
#define YEAR_COMP 2
#define NONE_FOUND 0



@interface SettingsVC : UIViewController <UITextFieldDelegate,NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) IBOutlet UITextField *firstNameEntry;
@property (retain, nonatomic) IBOutlet UITextField *lastNameEntry;
@property (retain, nonatomic) IBOutlet UIDatePicker *dobSelector;
@property (retain, strong) PersonalInfo *patientData;
@property (retain) NSMutableData *serverResponseData;


-(id) initWithPersonalInformation:(PersonalInfo*) existingPatientData;

/**
 * This method updates the patient information  to reflect the date that is
 * selected from the UIDatePicker object.
 */

-(void) updateDOB;

@end
