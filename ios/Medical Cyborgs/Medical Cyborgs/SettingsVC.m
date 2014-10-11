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
@synthesize patientDOB;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    dobSelector = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 260.0, 320.0, 80.0)];
    [dobSelector setDatePickerMode:UIDatePickerModeDate];
    NSDate *today = [NSDate date];
    [dobSelector setMaximumDate:today];
    [dobSelector setMinimumDate:[NSDate distantPast]];
    [dobSelector addTarget:self action:@selector(updateDOB)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dobSelector];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateDOB {
    
    [self setPatientDOB:[dobSelector date]];
    NSLog(@"selecting %@", patientDOB);
}

@end
