//
//  HeartMonitorSelectVCViewController.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
// Blahd ahdsahdahdadsasa

#import "HeartMonitorSelectVC.h"

@interface HeartMonitorSelectVC ()

@end

@implementation HeartMonitorSelectVC

@synthesize deviceManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Heart Monitors";
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:DEVICE_READ_VALUE object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.deviceManager setSearchType:HEART_MONITOR];
    [self.deviceManager discoverDevicesForType:HEART_MONITOR];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [self.deviceManager stopScan];
    [self.deviceManager disconnectDevicesForType:HEART_MONITOR];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource protocol methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[deviceManager heartDevices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Default";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    id<DeviceCommonInfoInterface> currentDevice = [[deviceManager heartDevices] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[currentDevice name]];
    UIImageView *batteryCharge = [[UIImageView alloc] initWithFrame:CGRectMake(230, 6, 32, 32)];
    [batteryCharge setImage:[UIImage imageNamed:@"battery_empty_32.png"]];
    if ([currentDevice conformsToProtocol:@protocol(DeviceCommonInfoInterface)]) {
        
        // select the battery icon based on charge
        
        int lvl = [currentDevice batteryLevel];
        
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
    }
    [cell addSubview:batteryCharge];
    
    // add manufacturer information
    
    if ([currentDevice respondsToSelector:@selector(manufacturer)]) {
        [[cell detailTextLabel] setText:[currentDevice manufacturer]];
    }
    // add checkmark for the currently selected device
    
    if ([deviceManager selectedIndexForHeartMonitor] == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // deselect the device
    
    if ([deviceManager selectedIndexForHeartMonitor] == indexPath.row) {
        [deviceManager setHeartMonitorIsConnected:NO];
        [deviceManager setSelectedIndexForHeartMonitor:NONE_SELECTED];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } else {
        
        // select the device
        
        [deviceManager setHeartMonitorIsConnected:YES];
        [deviceManager setSelectedIndexForHeartMonitor:indexPath.row];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self playClickSound];
}

@end
