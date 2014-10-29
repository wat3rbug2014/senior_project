//
//  HomeScreenVC.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "HomeScreenVC.h"
#import "BTDeviceManager.h"
#import "HeartMonitorSelectVC.h"
#import "ActivityMonitorSelectVC.h"
#import "GraphVC.h"
#import "RemoteDBConnectionManager.h"

@interface HomeScreenVC ()

@end

@implementation HomeScreenVC

@synthesize heartRateButton;
@synthesize activityButton;
@synthesize graphButton;
@synthesize toggleRunButton;
@synthesize isMonitoring;
@synthesize btDevices;
@synthesize personalInfoButton;
@synthesize patientInfo;
@synthesize devicePoller;
@synthesize pollRunLoop;
@synthesize devicePollTimer;
@synthesize serverPollTimer;
@synthesize serverPoller;
@synthesize settings;

#pragma mark Standard UIViewController methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        isMonitoring = false;
        self.patientInfo = [[PersonalInfo alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollFailed:)
            name:@"DevicePollFailed" object:self.devicePoller];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForUpdatedPatientID)
            name:@"PersonalInfoUpdated" object:settings];
    }
    return self;
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setColorForButton:graphButton isReady:YES];
    [self setColorForButton:activityButton isReady:NO];
    [self setColorForButton:heartRateButton isReady:NO];
    [self setColorForButton:personalInfoButton isReady:NO];
    [self setColorForButton:toggleRunButton isReady:NO];
    [[toggleRunButton titleLabel] setText:@"Start"];
    [[toggleRunButton titleLabel] setTextColor:[UIColor whiteColor]];
    btDevices = [[BTDeviceManager alloc] init];
}

-(void) viewWillAppear:(BOOL)animated {
    
    // set button colors
    
    [self setColorForButton:heartRateButton isReady:[btDevices heartMonitorIsConnected]];
    [self setColorForButton:activityButton isReady:[btDevices activityMonitorIsConnected]];
    [self setColorForButton:toggleRunButton isReady:[self isMonitoring]];
    [self checkForUpdatedPatientID];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HomeScreenVC custom methods


-(IBAction)alterPersonalSettings:(id)sender {
    
    settings = [[PatientInformationVC alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}


-(IBAction)selectActivityMonitor:(id)sender {
    
    ActivityMonitorSelectVC *heartSelectorVC = [[ActivityMonitorSelectVC alloc] initWithDeviceManager:btDevices];
    [heartSelectorVC setTitle:@"Activity Monitors"];
    [self.navigationController pushViewController:heartSelectorVC animated:YES];
}

-(IBAction)selectHeartMonitor:(id)sender {
    
    HeartMonitorSelectVC *heartSelectorVC = [[HeartMonitorSelectVC alloc] initWithDeviceManager:btDevices];
    [self.navigationController pushViewController:heartSelectorVC animated:YES];
}

-(void) setColorForButton:(UIButton *)button isReady:(BOOL)ready {
    
    if (![button isKindOfClass:[UIButton class]] || button == nil) {
        return;
    }
    if (ready) {
        [button setBackgroundColor:[UIColor greenColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[button titleLabel] setTextColor:[UIColor blackColor]];
    } else {
        [button setBackgroundColor:[UIColor redColor]];
        [[button titleLabel] setTextColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(IBAction) showGraph:(id)sender {
    
    GraphVC *graphDisplay = [[GraphVC alloc] initWithDevicePoller: devicePoller];
    [self.navigationController pushViewController:graphDisplay animated:YES];
}

-(IBAction) toggleMonitoring:(id)sender {
    
    // check to see if it is allowed to start monitoring
    
    if ([patientInfo patientID] == NO_ID_SET) {
        return;
    }
//    if ([btDevices selectedIndexForActivityMonitor] == NONE_SELECTED) {
//        return;
//    }
//    if ([btDevices selectedIndexForHeartMonitor] == NONE_SELECTED) {
//        return;
//    }
    // change the button color and stop or start the pollers
    
    [self setIsMonitoring:![self isMonitoring]];
    [self setColorForButton:toggleRunButton isReady:[self isMonitoring]];
    //[super playClickSound];
    if ([self isMonitoring]) {
        [toggleRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        //setup polling objects
        
        [btDevices selectedIndexForActivityMonitor];
        devicePoller = [[DevicePollManager alloc] initWithDataStore:nil andDevicemanager:btDevices];
        serverPoller = [[RemoteDBConnectionManager alloc] initWithDatabase:nil];
        [serverPoller setPatientID:[patientInfo patientID]];
        
        // setup run loop
        
        pollRunLoop = [NSRunLoop mainRunLoop];
        NSTimeInterval intveral =  5.0;
        NSTimeInterval serverTime = 60.0;
        
        devicePollTimer = [NSTimer scheduledTimerWithTimeInterval:intveral target:devicePoller
                selector:@selector(pollDevicesForData) userInfo:nil repeats:YES];
        serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:serverTime target:serverPoller selector:@selector(pushDataToRemoteServer) userInfo:nil repeats:YES];
        [pollRunLoop addTimer:devicePollTimer forMode:NSDefaultRunLoopMode];
        [pollRunLoop addTimer:serverPollTimer forMode:NSDefaultRunLoopMode];
        NSLog(@"started running");
        [pollRunLoop run];
    } else {
        
        // stop the pollers
        
        [toggleRunButton setTitle:@"Start" forState:UIControlStateNormal];
        NSLog(@"stopped running");
        [pollRunLoop cancelPerformSelector:@selector(pollDevicesForData) target:devicePoller argument:nil];
        [pollRunLoop cancelPerformSelector:@selector(pushDataToRemoteServer) target:serverPoller argument:nil];
        [serverPollTimer invalidate];
        [devicePollTimer invalidate];
        [serverPoller pushDataToRemoteServer];
    }
}

-(void) checkForUpdatedPatientID {
    
    NSLog(@"Checking personal info");
    patientInfo = nil;
    patientInfo = [[PersonalInfo alloc] init];
    if ([patientInfo patientID] != NO_ID_SET) {
        NSLog(@"patient id is %d", (int)[patientInfo patientID]);
        [self setColorForButton:personalInfoButton isReady:YES];
    } else {
        NSLog(@"no patient id");
        [self setColorForButton:personalInfoButton isReady:NO];
    }
}

-(void) pollFailed: (NSNotification*) notification {
    
    NSString *title = nil;
    NSString *message = nil;

    // check to see if battery for activity monitor or heart monitor is low
    
    UIAlertController *popup = [UIAlertController alertControllerWithTitle:title message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [popup addAction:action];
    [self.navigationController presentViewController:popup animated:YES completion:nil];
    [self setColorForButton:toggleRunButton isReady:NO];
}
@end
