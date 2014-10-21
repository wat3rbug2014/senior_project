//
//  SettingsVC.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/9/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "PatientInformationVC.h"
#import "DatabaseConstants.h"

@interface PatientInformationVC ()

@end

@implementation PatientInformationVC


@synthesize dobSelector;
@synthesize firstNameEntry;
@synthesize lastNameEntry;
@synthesize patientData;
@synthesize serverResponseData;


-(id) initWithPersonalInformation: (PersonalInfo*) existingPatientData {
    
    if (self = [super init]) {
        self.patientData = existingPatientData;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    patientData = [[PersonalInfo alloc] init];
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
    if ([patientData dob] != nil) {
        [dobSelector setDate:[patientData dob]];
    }
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
        
        //save the current data except the patientID
        
        [patientData setFirstName:[firstNameEntry text]];
        [patientData setLastName:[lastNameEntry text]];
        [patientData setDob:[dobSelector date]];
        [patientData saveInformation];
        
        // setup dob components for URL
        
        NSDateComponents *dobComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitDay |
            NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[dobSelector date]];
        month = [dobComponents month];
        year = [dobComponents year];
        day = [dobComponents day];

        NSString *firstNameStr = [NSString stringWithFormat:@"first_name=%@", [patientData firstName]];
        NSString *lastNameStr = [NSString stringWithFormat:@"last_name=%@", [patientData lastName]];
        NSString *birthDateStr = [NSString stringWithFormat:@"dob=%d-%d-%d", year, month, day];
        NSString *rawUserUrl = [NSString stringWithFormat:@"&%@&%@&%@", firstNameStr, lastNameStr, birthDateStr];
        NSString *userUrl = [rawUserUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *databaseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_BASE_URL, userUrl]];
        NSLog(@"url: %@",databaseUrl);
        
        // go to database and get patientID
        // test this to make sure it does not hold up things
        
        NSURLRequest *dbRequest = [NSURLRequest requestWithURL:databaseUrl];
        //NSURLConnection *dbConnection = [[NSURLConnection alloc] initWithRequest:dbRequest delegate:self startImmediately:YES];
        NSURLResponse *serverResponse = nil;
        NSError *error = nil;
        //[NSURLConnection sendAsynchronousRequest:dbRequest queue:[NSOperationQueue currentQueue] completionHandler:<#^(NSURLResponse *response, NSData *data, NSError *connectionError)handler#>];
        [serverResponseData appendData:[NSURLConnection sendSynchronousRequest:dbRequest
                returningResponse:&serverResponse error:&error]];
        if (error != nil) {
            NSLog(@"got an error %@", error);
        } else {
            NSLog(@"success %d", [serverResponseData length]);
        }
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

#pragma NSURLConnectionDelegate methods


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"couldn't reach: see %@", error);
}

#pragma NSURLConnectDataDelegate methods 


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"got a response from %@", [response description]);
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [serverResponseData appendData:data];
    NSLog(@"got some data %d", [serverResponseData length]);
}

-(void) connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSLog(@"not sure what to use this for");
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"That was the last");
}
#pragma mark Custom methods


-(void) updateDOB {
    
    [patientData setDob:[dobSelector date]];
    NSLog(@"selecting %@", [patientData dob]);
}


@end
