//
//  SettingsVC.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/9/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC


@synthesize dobSelector;
@synthesize firstNameEntry;
@synthesize lastNameEntry;
@synthesize patientData;


-(id) init {
    
    if (self = [super init]) {
        patientData = [[PersonalInfo alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    dobSelector = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 260.0, 320.0, 80.0)];
    [dobSelector setDatePickerMode:UIDatePickerModeDate];
    NSDate *today = [NSDate date];
    [dobSelector setMaximumDate:today];
    [dobSelector setMinimumDate:[NSDate distantPast]];
    [dobSelector addTarget:self action:@selector(updateDOB)
          forControlEvents:UIControlEventValueChanged];
    [firstNameEntry setDelegate:self];
    [lastNameEntry setDelegate:self];

    [self.view addSubview:dobSelector];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // load user data
    
    [firstNameEntry setText:[patientData firstName]];
    [lastNameEntry setText:[patientData lastName]];
    [dobSelector setDate:[patientData dob]];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    // not everything is filled out
    
    // figure out if the date is different than today
    
    BOOL isDateInvalid = true;
    NSUInteger flags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* currentComponents = [calendar components:flags fromDate:[dobSelector date] toDate:[NSDate date] options:0];
    int month = [currentComponents month];
    int day = [currentComponents day];
    int year = [currentComponents year];
    if (day == 0 && month == 0 && year == 0) {
        isDateInvalid = true;
    } else {
        isDateInvalid = false;
    }
    // do popup if something is missing
    
    if ([[firstNameEntry text] length] == 0 || [[lastNameEntry text] length] == 0
            || isDateInvalid) {
        NSString *title = @"Personal Information Missing";
        NSString *message = @"Please update all of the settings in the Personal Information View";
        UIAlertController *popup = [UIAlertController alertControllerWithTitle:title message:message
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [popup addAction:action];
        [self.navigationController presentViewController:popup animated:YES completion:nil];
        [super viewWillDisappear:animated];
        return;
    } else {
        if ([patientData patientID] > NONE_FOUND) {
            [patientData saveInformation];
        } else {
            
        }
    // read from defaults

    // if first name last name and dob is different then get new id
    // set default id to 0
    // write name and dob to defaults
    //check if network available
    // if network available
    // open database
    // do add statement to database
    // check success
    //do select statement to database
    // if only 1 result
    // get result
    // close database
    }
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldViewDelegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *personalInfo = [NSMutableDictionary
        dictionaryWithDictionary:[defaults dictionaryForKey:USER_DEFAULT_KEY]];
    if ([textField isEqual:firstNameEntry]) {
        [personalInfo setObject:[firstNameEntry text] forKey:F_NAME];
    }
    if ([textField isEqual:lastNameEntry]) {
        [personalInfo setObject:[lastNameEntry text] forKey:L_NAME];
    }
    [defaults setObject:personalInfo forKey:USER_DEFAULT_KEY];
    [defaults synchronize];
    [textField resignFirstResponder];
    return YES;
}

-(void) updateDOB {
    
    [self setPatientDOB:[dobSelector date]];
    NSLog(@"selecting %@", patientDOB);
}


@end
