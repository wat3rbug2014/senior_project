//
//  ActivityMonitorSelectVC.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "ActivityMonitorSelectVC.h"

@interface ActivityMonitorSelectVC ()

@end

@implementation ActivityMonitorSelectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Activity Monitors";
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self.deviceManager discoverDevicesForType:ACTIVITY_MONITOR];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [self.deviceManager stopScan];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[super.deviceManager activityDevices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Default";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    [[cell textLabel] setText:[[[super.deviceManager activityDevices] objectAtIndex:indexPath.row] name]];
    if ([super.deviceManager selectedIndexForActivityMonitor] == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super.deviceManager setActivityMonitorIsConnected:YES];
    [super.deviceManager setSelectedIndexForActivityMonitor:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark Custom methods



@end
