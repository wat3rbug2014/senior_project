//
//  DeviceDetailVC.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DeviceDetailVC.h"

@interface DeviceDetailVC ()

@end

@implementation DeviceDetailVC

@synthesize btManager;
@synthesize soundPlayer;
@synthesize soundSelect;
@synthesize useSounds;

#pragma mark -
#pragma mark Super class methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.useSounds = true;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetResponseFromDevice)
                                                     name:@"BTMonitoringUpdate" object:btManager];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [btManager setManagerDelegate:self];
    [btManager startMonitoring];
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Ping 1" ofType:AVFileTypeAppleM4A];
    NSURL *soundFileLocation = [NSURL URLWithString:soundFile];
    NSError *error;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileLocation fileTypeHint:AVFileTypeAppleM4A error:&error];
    [soundPlayer prepareToPlay];
    if (error != nil) {
        NSLog(@"error is %@", [error description]);
    }
    [soundPlayer setDelegate:self];
    if ([soundPlayer url] == nil) {
        NSLog(@"Fix the file location");
    }
    
}

-(void) dealloc {
    
    [btManager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BTMonitoringUpdate" object:btManager];
    [btManager setDeviceInUse:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom methods

-(IBAction)changeSoundSetting:(id)sender {
    
    useSounds = !useSounds;
    if (useSounds) {
        NSLog(@"Sounds are on");
    } else {
        NSLog(@"Sounds are off");
    }
}

#pragma mark -
#pragma mark BTManagerNotifcation methods


-(void) didGetResponseFromDevice {
    
    NSLog(@"Play sound");
    if (useSounds) {
        [soundPlayer play];
    }
    // play sound
    // update color
    // update temperature if available
}

@end
