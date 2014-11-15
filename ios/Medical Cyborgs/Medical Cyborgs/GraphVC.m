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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Measurements";
        [devicePoller addObserver:self forKeyPath:@"currentHeartRate" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void) dealloc {
    
    [self removeObserver:devicePoller forKeyPath:@"currentHeartRate"];
}

-(id) initWithDevicePoller:(DevicePollManager *) newDevicePoller {
    
    if (self = [self initWithNibName:@"GraphVC" bundle:nil]) {
        devicePoller = newDevicePoller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [devicePoller pollDevicesForData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
}
@end
