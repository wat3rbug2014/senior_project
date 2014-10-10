//
//  SettingsVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/9/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MONTH_COMP 0
#define DAY_COMP 1
#define YEAR_COMP 2

@interface SettingsVC : UIViewController 

@property (retain, nonatomic) IBOutlet UITextField *firstNameEntry;
@property (retain, nonatomic) IBOutlet UITextField *lastNameEntry;
@property (retain, nonatomic) IBOutlet UIDatePicker *dobSelector;
@property (retain) NSDate *patientDOB;

-(void) updateDOB;

@end