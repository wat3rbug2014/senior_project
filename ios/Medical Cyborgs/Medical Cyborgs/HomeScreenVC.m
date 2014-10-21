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
#import "SettingsVC.h"
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
@synthesize soundPlayer;
@synthesize devicePoller;
@synthesize pollRunLoop;
@synthesize devicePollTimer;
@synthesize serverPollTimer;
@synthesize serverPoller;

#pragma mark Standard UIViewController methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        isMonitoring = false;
        self.patientInfo = [[PersonalInfo alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setColorForButton:graphButton isReady:YES];
    [self setColorForButton:activityButton isReady:NO];
    [self setColorForButton:heartRateButton isReady:NO];
    [self setColorForButton:personalInfoButton isReady:NO];
    [self setColorForButton:toggleRunButton isReady:NO];
    btDevices = [[BTDeviceManager alloc] init];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self setColorForButton:heartRateButton isReady:[btDevices heartMonitorIsConnected]];
    [self setColorForButton:activityButton isReady:[btDevices activityMonitorIsConnected]];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [self playViewChangeSound];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HomeScreenVC custom methods


-(IBAction)alterPersonalSettings:(id)sender {
    
    SettingsVC *settings = [[SettingsVC alloc] init];
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
        [[button titleLabel] setTextColor:[UIColor blackColor]];
    } else {
        [button setBackgroundColor:[UIColor redColor]];
        [[button titleLabel] setTextColor:[UIColor whiteColor]];
    }
}

-(IBAction)showGraph:(id)sender {
    
    GraphVC *graphDisplay = [[GraphVC alloc] initWithDeviceManager: btDevices];
    [self.navigationController pushViewController:graphDisplay animated:YES];
}

-(IBAction)toggleMonitoring:(id)sender {
    
    [self setIsMonitoring:![self isMonitoring]];
    [self setColorForButton:toggleRunButton isReady:[self isMonitoring]];
    [self playClickSound];
    if ([self isMonitoring]) {
        [[toggleRunButton titleLabel] setText:@"Stop"];
        
        //setup polling objects
        
        id currentHeartMon = [[btDevices heartDevices] objectAtIndex:[btDevices selectedIndexForHeartMonitor]];
        id currentActivityMon = [[btDevices activityDevices] objectAtIndex:[btDevices selectedIndexForActivityMonitor]];
        devicePoller = [[DevicePollManager alloc] initWithDataStore:nil heartMonitor:currentHeartMon
            activityMonitor:currentActivityMon];
        serverPoller = [[RemoteDBConnectionManager alloc] initWithDatabase:nil];
        
        // setup run loop
        
        pollRunLoop = [NSRunLoop mainRunLoop];
        NSTimeInterval intveral =  5.0;
        NSTimeInterval serverTime = 300.0;
        
        devicePollTimer = [NSTimer scheduledTimerWithTimeInterval:intveral target:devicePoller
                selector:@selector(pollDevicesForData) userInfo:nil repeats:YES];
        serverPollTimer = [NSTimer scheduledTimerWithTimeInterval:serverTime target:serverPoller selector:@selector(pushDataToRemoteServer) userInfo:nil repeats:YES];
        [pollRunLoop addTimer:devicePollTimer forMode:NSDefaultRunLoopMode];
        [pollRunLoop addTimer:serverPollTimer forMode:NSDefaultRunLoopMode];
        NSLog(@"started running");
        [pollRunLoop run];
    } else {
        [[toggleRunButton titleLabel] setText:@"Start"];
        NSLog(@"stopped running");
        [pollRunLoop cancelPerformSelector:@selector(pollDevicesForData) target:devicePoller argument:nil];
        [pollRunLoop cancelPerformSelector:@selector(pushDataToRemoteServer) target:serverPoller argument:nil];
        [serverPollTimer invalidate];
        [devicePollTimer invalidate];
        [serverPoller flushDatabaseToRemoteServer];
    }
}

-(void) playViewChangeSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Star Trek Door" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playClickSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"click_one" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playSoundWithFile:(NSURL *)soundFile {
    
    if (soundPlayer == nil) {
        return;
    }
    NSError *error = nil;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    if (error == nil) {
        [soundPlayer prepareToPlay];
        [soundPlayer play];
    } else {
        NSLog(@"error with sound: %@", [error description]);
    }
}
@end
