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

- (id)initWithStyle:(UITableViewStyle)style
{
    // not used
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager {
    
    // this may be a bad hack because I haven't defined self yet
    
    self = [self initWithStyle:UITableViewStylePlain];
    self.deviceManager = newDeviceManager;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

@end
