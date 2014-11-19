//
//  GraphVC.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "GraphVC.h"

@interface GraphVC ()

@end

@implementation GraphVC

@synthesize devicePoller;
@synthesize heartRateDisplay;
@synthesize activityDisplay;
@synthesize displayTimer;
@synthesize runLoop;
@synthesize heartMonitor;
@synthesize activityMonitor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Measurements";
    }
    return self;
}

-(id) initWithDevicePoller:(DevicePollManager *) newDevicePoller {
    
    if (newDevicePoller == nil) {
        return nil;
    }
    if (self = [self initWithNibName:@"GraphVC" bundle:nil]) {
        devicePoller = newDevicePoller;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
    [devicePoller pollDevicesForData];
    NSTimeInterval displayUpdateTime = 1.0;
    displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayUpdateTime target:self
        selector:@selector(updateDisplay) userInfo:nil repeats:YES];
    [runLoop addTimer:displayTimer forMode:NSDefaultRunLoopMode];
    heartMonitor = [devicePoller heartMonitor];
    activityMonitor = [devicePoller activityMonitor];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [displayTimer invalidate];
    [runLoop cancelPerformSelector:@selector(updateDisplay) target:self argument:nil];
    [devicePoller stopMonitoring];
    [[devicePoller database] purgeDatabase];
    [super viewWillDisappear:animated];
}

-(void) updateDisplay {
    
    NSString *currentHeartRateStr = [NSString stringWithFormat:@"%d",[heartMonitor getHeartRate]];
    [heartRateDisplay setText:currentHeartRateStr];
    int activity = [DeviceConstantsAndStaticFunctions activityLevelBasedOnHeartRate:
        [heartMonitor getHeartRate] andAge:[[devicePoller patientInfo] age]];
    [activityDisplay setText:[DeviceConstantsAndStaticFunctions activityPhraseUsingActivityLevel:activity]];
    }
@end
