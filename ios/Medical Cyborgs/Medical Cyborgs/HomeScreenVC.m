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
#import <AVFoundation/AVFoundation.h>

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HomeScreenVC custom methods


-(IBAction)alterPersonalSettings:(id)sender {
    
    SettingsVC *settings = [[SettingsVC alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
    [self playViewChangeSound];
}


-(IBAction)selectActivityMonitor:(id)sender {
    
    ActivityMonitorSelectVC *heartSelectorVC = [[ActivityMonitorSelectVC alloc] initWithDeviceManager:btDevices];
    [heartSelectorVC setTitle:@"Activity Monitors"];
    [self.navigationController pushViewController:heartSelectorVC animated:YES];
    [self playViewChangeSound];
}

-(IBAction)selectHeartMonitor:(id)sender {
    
    HeartMonitorSelectVC *heartSelectorVC = [[HeartMonitorSelectVC alloc] initWithDeviceManager:btDevices];
    [self.navigationController pushViewController:heartSelectorVC animated:YES];
    [self playViewChangeSound];
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
    [self playViewChangeSound];
    [self.navigationController pushViewController:graphDisplay animated:YES];
}

-(IBAction)toggleMonitoring:(id)sender {
    
    [self setIsMonitoring:![self isMonitoring]];
    if ([self isMonitoring]) {
        [toggleRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        [toggleRunButton setBackgroundColor:[UIColor greenColor]];
    } else {
        [toggleRunButton setBackgroundColor:[UIColor redColor]];
        [toggleRunButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    [self playClickSound];
}

-(void) playViewChangeSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Star Trek Door" ofType:@"m4r"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playClickSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"click_one" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playSoundWithFile:(NSURL *)soundFile {
    
    NSError *error = nil;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    float old_volume = [soundPlayer volume];
    if (error == nil) {
        [soundPlayer setVolume:0.5];
        [soundPlayer prepareToPlay];
        [soundPlayer play];
        [soundPlayer setVolume:old_volume];
    }
}
@end
