//
//  DiscoveryController.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "BTDeviceInfo.h"

@interface DiscoveryViewController ()

@end

@implementation DiscoveryViewController

static NSString *cellWithTemp = @"ShowTemp";
static NSString *cellBasic = @"Basic";

@synthesize bluetoothSearchBox;
@synthesize devices;
@synthesize deviceDataSourceDelegate;
@synthesize selectedDevice;

#pragma mark -
#pragma mark Super class methods


- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        bluetoothSearchBox = [[DiscoveryController alloc] init];
        self.title = @"Discovery";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotificationOfBTDiscovery) name:@"BTDiscoveryChange" object:bluetoothSearchBox];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if (selectedDevice != nil) {
        [deviceDataSourceDelegate updateDeviceListing:selectedDevice];
    }
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BTDiscoveryChange" object:bluetoothSearchBox];
}

#pragma mark -
#pragma mark - TableViewDataSource protocol methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [devices count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTDeviceInfo *newSelection = [[BTDeviceInfo alloc] initWithDevice:[devices objectAtIndex:indexPath.row]];
    // fix this so that temperature is updated correctly
    
    if (![[[newSelection deviceID] name] isEqualToString:@"Apple TV"] ) {
        [newSelection setUseTemp:YES];
    }
    selectedDevice = newSelection;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBPeripheral *currentDevice = [devices objectAtIndex:indexPath.row];
    
    NSString *currentId;
    if (true    ) {
        currentId = cellWithTemp;
    } else {
        currentId = cellBasic;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:currentId];
    }
    [[cell textLabel] setText:[currentDevice name]];
    return cell;
}

#pragma mark -
#pragma mark Custom methods


-(void) receivedNotificationOfBTDiscovery {
    
    NSLog(@"Received notification.  Device count is %d", [[bluetoothSearchBox discoveredDevices] count]);
    devices = [bluetoothSearchBox discoveredDevices];    
    [self.tableView reloadData];
}
@end
