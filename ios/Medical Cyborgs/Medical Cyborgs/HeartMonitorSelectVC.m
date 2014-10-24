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

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager {
    
    if (newDeviceManager == nil) {
        return nil;
    }
    // this may be a bad hack because I haven't defined self yet
    
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.deviceManager = newDeviceManager;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:)
            name:@"BTDeviceDiscovery" object:self.deviceManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    
    NSLog(@"heart devices %d", [[deviceManager heartDevices] count]);
    return [[deviceManager heartDevices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Default";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:identifier];
    [[cell textLabel] setText:[[[deviceManager heartDevices] objectAtIndex:indexPath.row] name]];
    if ([deviceManager selectedIndexForHeartMonitor] == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // deselect the device
    
    if ([deviceManager selectedIndexForHeartMonitor] == indexPath.row) {
        [deviceManager setHeartMonitorIsConnected:NO];
        [deviceManager setSelectedIndexForActivityMonitor:NONE_SELECTED];
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

#pragma mark Custom methods


-(void) updateTable:(NSNotification*) notification {
    
    [self.tableView reloadData];
}

@end
