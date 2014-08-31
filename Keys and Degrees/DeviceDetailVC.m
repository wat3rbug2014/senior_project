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

@synthesize  useSounds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.useSounds = true;
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
@end
