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
        [self.deviceManager discoverDevicesForType: HEART_MONITOR];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self deviceManager] discoveredDevicesForType:ACTIVITY_MONITOR];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [[cell textLabel] setText:[[[super.deviceManager activityDevices ] objectAtIndex:indexPath.row] name]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    


    [super.deviceManager setActivityMonitorIsConnected:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
