//
//  Things.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/29/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "Things.h"
#import "DiscoveryViewController.h"
#import "DeviceDetailVC.h"

@interface Things ()

@end

@implementation Things

@synthesize btManager;
@synthesize addButton;

static NSString *cellWithTemp = @"ShowTemp";
static NSString *cellBasic = @"Basic";

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Keys and Things";
        btManager = [[DeviceManager alloc] init];
        addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevicesToList)];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [btManager selectedDeviceCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTDeviceInfo *currentDevice = [btManager selectedDeviceAtIndex:indexPath.row];
    NSString *currentId;
    if ([currentDevice useTemp]) {
        currentId = cellWithTemp;
    } else {
        currentId = cellBasic;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentId];
    if (cell == nil) {
        if (currentId == cellBasic) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:currentId];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:currentId];
            [[cell detailTextLabel] setText:@"Temperature"];
        }
    }
    [[cell textLabel] setText:[currentDevice deviceID].name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [btManager removeDeviceAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceDetailVC *detailView = [[DeviceDetailVC alloc] initWithNibName:@"DeviceDetailVC" bundle:nil];
    BTDeviceInfo *selectedItem = [btManager selectedDeviceAtIndex:indexPath.row];
    [detailView setTitle: [[selectedItem deviceID] name]];
    [detailView setBtManager:btManager];
    [self.navigationController pushViewController:detailView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark DeviceDataSourceProtocol methods


-(void) passReferenceToBTManager:(DeviceManager*) newListing {
    
    btManager = newListing;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Custom methods


-(void) addDevicesToList {
    
    DiscoveryViewController *discoverDevices = [[DiscoveryViewController alloc] init];
    discoverDevices.deviceDataSourceDelegate = self;
    [discoverDevices setBluetoothSearchBox:btManager];
    [self.navigationController pushViewController:discoverDevices animated:YES];
}

@end
