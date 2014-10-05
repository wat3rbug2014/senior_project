//
//  DeviceSelectionVCTableViewController.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DeviceSelectionVC.h"
#import "DummyDevice.h"

@interface DeviceSelectionVC ()

@end

@implementation DeviceSelectionVC

@synthesize deviceManager;

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListUpdated)
                name:@"BTDeviceDiscovery" object:self.deviceManager];
    }
    return self;
}

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager {
    
    // this may be a bad hack because I haven't defined self yet
    
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.deviceManager = newDeviceManager;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListUpdated)
                name:@"BTDeviceDiscovery" object:self.deviceManager];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.deviceManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(void) deviceListUpdated {
    
    [self.tableView reloadData];
}

@end
