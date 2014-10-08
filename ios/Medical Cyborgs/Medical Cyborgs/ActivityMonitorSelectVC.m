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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:)
                                                 name:DEVICE_READ_VALUE object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.deviceManager setSearchType:ACTIVITY_MONITOR];
    [self.deviceManager discoverDevicesForType:ACTIVITY_MONITOR];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [self.deviceManager stopScan];
    [self.deviceManager disconnectDevicesForType:ACTIVITY_MONITOR];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    id<DeviceConnection> currentDevice = [[super.deviceManager activityDevices] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[currentDevice name]];
    if ([currentDevice respondsToSelector:@selector(updatedBatteryLevel)]) {
        int lvl = [currentDevice updatedBatteryLevel];
        //UILabel *batteryCharge = [[UILabel alloc] initWithFrame:CGRectMake(230, 2, 48, 48)];
        //[batteryCharge setText:[NSString stringWithFormat:@"%d%%", lvl]];
        UIImageView *batteryCharge = [[UIImageView alloc] initWithFrame:CGRectMake(230, 2, 32, 32)];
        if (lvl == 100) {
            [batteryCharge setImage:[UIImage imageNamed:@"battery_full_32.png"]];
        }
        if (lvl > 80 && lvl < 100) {
            [batteryCharge setImage:[UIImage imageNamed:@"battery_4_32.png"]];
        }
        if (lvl <= 80 && lvl > 60) {
            [batteryCharge setImage:[UIImage imageNamed:@"battery_3_32.png"]];
        }
        if (lvl <= 60 && lvl > 40) {
            [batteryCharge setImage:[UIImage imageNamed:@"battery_2_32.png"]];
        }
        if (lvl <= 40 && lvl  > 20) {
            [batteryCharge setImage:[UIImage imageNamed:@"battery_1_32.png"]];
        }
        if (lvl <= 20) {
            [batteryCharge setImage:[UIImage imageNamed:@"battery_empty_32.png"]];
        }
        [cell addSubview:batteryCharge];
    }
    if ([currentDevice respondsToSelector:@selector(manufacturer)]) {
        [[cell detailTextLabel] setText:[currentDevice manufacturer]];
    }
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


-(void) updateTable:(NSNotification*) notification {
    
    NSLog(@"Updating table");
    [self.tableView reloadData];
    
}
@end
