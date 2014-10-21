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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Measurements";
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
