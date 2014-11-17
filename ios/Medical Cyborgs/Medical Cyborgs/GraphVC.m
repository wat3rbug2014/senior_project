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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Measurements";
        //[devicePoller addObserver:self forKeyPath:@"currentHeartRate" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void) dealloc {
    
    //[self removeObserver:devicePoller forKeyPath:@"currentHeartRate"];
}

-(id) initWithDevicePoller:(DevicePollManager *) newDevicePoller {
    
    if (self = [self initWithNibName:@"GraphVC" bundle:nil]) {
        devicePoller = newDevicePoller;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [devicePoller pollDevicesForData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
    NSTimeInterval displayUpdateTime = 1.0;
    displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayUpdateTime target:self
        selector:@selector(updateDisplay) userInfo:nil repeats:YES];
    [runLoop addTimer:displayTimer forMode:NSDefaultRunLoopMode];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [displayTimer invalidate];
    [runLoop cancelPerformSelector:@selector(updateDisplay) target:self argument:nil];
    [super viewWillDisappear:animated];
}

-(void) updateDisplay {
    
    [heartRateDisplay setText:[NSString stringWithFormat:@"%d", [[devicePoller heartMonitor] getHeartRate]]];
    int activity = [devicePoller activityLevelBasedOnHeartRate:[[devicePoller heartMonitor] getHeartRate]];
    NSLog(@"activity level is %d",activity);
    switch (activity) {
        case TRAVEL: [activityDisplay setText:@"Traveling"];
            break;
        case TROUBLE_SLEEP: [activityDisplay setText:@"Troubled sleep"];
            break;
        case ACTIVE: [activityDisplay setText:@"Active"];
            break;
        case EXERCISE: [activityDisplay setText:@"Exercising"];
            break;
        default: [activityDisplay setText:@"Sleeping"];
            break;
            
    }
}
@end
