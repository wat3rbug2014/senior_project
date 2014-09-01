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
@synthesize distanceDisplay;
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

-(void) dealloc {
    
    [btManager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BTMonitoringUpdate" object:btManager];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [distanceDisplay setText:nil];
    [btManager setManagerDelegate:self];
    [btManager startMonitoring];
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Ping" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    NSError *error;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileLocation error:&error];
    [soundPlayer prepareToPlay];
    if (error != nil) {
        NSLog(@"error is %@", [error description]);
    }
    [soundPlayer setDelegate:self];
}

-(void) viewWillAppear:(BOOL)animated {
    
    NSLog(@"going to appear");
}
-(void) viewWillDisappear:(BOOL)animated {
    
    [btManager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BTMonitoringUpdate" object:btManager];
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

-(NSInteger) calculateDistanceWithTXPwr: (NSInteger) power {
    
    NSInteger result = 0;
    
    return result;
}

-(void) flashTheScreen {
    
    NSLog(@"screen flash");
}

#pragma mark -
#pragma mark BTManagerNotifcation methods


-(void) didGetResponseFromDevice {
    
    NSLog(@"Play sound");
    if (useSounds) {
        [soundPlayer play];
    }
    NSInteger distance = [self calculateDistanceWithTXPwr:0]; // need variable here from peripheral
    [distanceDisplay setText: [NSString stringWithFormat:@"%d ft", distance]];
    if ([[btManager deviceInUse] useTemp]) {
        
        // get temperature from peripheral and display it
    }
    // update color
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate methods


-(void) audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    NSLog(@"sounds interrupted");
    useSounds = false;
}

-(void) audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    NSLog(@"sound interruption ended");
    useSounds = [soundSelect isOn];
}

-(void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    // do nothing because I want silent fail
    NSLog(@"silent fail of sound");
}

@end
