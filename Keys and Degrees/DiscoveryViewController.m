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
@synthesize deviceDataSourceDelegate;

#pragma mark -
#pragma mark Super class methods


- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Discovery";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotificationOfBTDiscovery) name:@"BTDiscoveryChange" object:bluetoothSearchBox];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [bluetoothSearchBox startScan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    
        [deviceDataSourceDelegate passReferenceToBTManager:bluetoothSearchBox];
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

    return [bluetoothSearchBox discoveredDeviceCount];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [bluetoothSearchBox selectDiscoveredDeviceAtIndex:indexPath.row];
    NSLog(@"Selected %@", [[[bluetoothSearchBox discoveredDeviceAtIndex:indexPath.row] deviceID] name]);
    [bluetoothSearchBox stopScan];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTDeviceInfo *currentDevice = [[bluetoothSearchBox discoveredDevices] objectAtIndex:indexPath.row];
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
    [[cell textLabel] setText:[[currentDevice deviceID ]name]];
    return cell;
}

#pragma mark -
#pragma mark Custom methods


-(void) receivedNotificationOfBTDiscovery {
       
    [self.tableView reloadData];
}
@end
