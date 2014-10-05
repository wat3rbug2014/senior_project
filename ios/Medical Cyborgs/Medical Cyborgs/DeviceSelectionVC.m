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
    return self;
}

/*
 * This is the preferred method for initializing the viewcontroller.  This method allows the devicemanager
 * to start its setup so that the table in the view controller has information to build the table.  Without
 * this parameter notifications from the device manager will not be received, so the tableview can not update
 * with newly discovered devices.
 * @param newDeviceManager is the bluetooth device manager that is shared throughtout the application.
 * @return The DeviceSelectionVC that is created with the bluetooth devicemanager in it.
 **/

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

#pragma mark - Custom methods


/*
 * This function is the default method that is called when the device manager discovers a device.
 * Its intent is to allow the tableview to update since the count of devices has changed and information
 * is available. A table reload is used because the number of items to be discovered is very small
 * and the overhead is small.  Otherwise it is recommended to just reload the section and choose the type
 * of animation.
 **/

-(void) deviceListUpdated {
    
    [self.tableView reloadData];
}

@end
