//
//  HomeScreenVC.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "HomeScreenVC.h"
#import "BTDeviceManager.h"
#import "HeartMonitorSelectVC.h"
#import "ActivityMonitorSelectVC.h"

@interface HomeScreenVC ()

@end

@implementation HomeScreenVC

@synthesize heartRateButton;
@synthesize activityButton;
@synthesize graphButton;
@synthesize toggleRunButton;
@synthesize isMonitoring;
@synthesize btDevices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        isMonitoring = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityButton setBackgroundColor:[UIColor redColor]];
    [toggleRunButton setBackgroundColor:[UIColor redColor]];
    btDevices = [[BTDeviceManager alloc] init];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    NSLog(@"Checking color");
    if ([btDevices heartMonitorIsConnected]) {
        [heartRateButton setBackgroundColor:[UIColor greenColor]];
    } else {
        [heartRateButton setBackgroundColor:[UIColor redColor]];
    }
    if ([btDevices activityMonitorIsConnected]) {
        [activityButton setBackgroundColor:[UIColor greenColor]];
    } else {
        [activityButton setBackgroundColor:[UIColor redColor]];
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)selectActivityMonitor:(id)sender {
    
    ActivityMonitorSelectVC *heartSelectorVC = [[ActivityMonitorSelectVC alloc] initWithDeviceManager:btDevices];
    [heartSelectorVC setTitle:@"Activity Monitors"];
    [self.navigationController pushViewController:heartSelectorVC animated:YES];

}

-(IBAction)selectHeartMonitor:(id)sender {

    HeartMonitorSelectVC *heartSelectorVC = [[HeartMonitorSelectVC alloc] initWithDeviceManager:btDevices];
    [heartSelectorVC setTitle:@"Heart Rate Monitors"];
    [self.navigationController pushViewController:heartSelectorVC animated:YES];
    
}

-(IBAction)showGraph:(id)sender {
    
    
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
}
@end
