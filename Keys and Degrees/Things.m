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

@synthesize deviceDB;
@synthesize addButton;

static NSString *cellWithTemp = @"ShowTemp";
static NSString *cellBasic = @"Basic";

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Keys and Things";
        // Custom initialization
        // load core data
        // get devices already saved
        addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevicesToList)];
        deviceDB = [[DeviceList alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [deviceDB count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTDeviceInfo *currentDevice = [deviceDB deviceAtIndex:indexPath.row];
    
    NSString *currentId;
    if ([currentDevice useTemp]) {
        // use identifier for temp
        
        currentId = cellWithTemp;
    } else {
        // use identifier for no temp
        
        currentId = cellBasic;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:currentId];
    }
    
    // Configure the cell...
    [[cell textLabel] setText:[currentDevice deviceID].name];
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [deviceDB removeDeviceAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceDetailVC *detailView = [[DeviceDetailVC alloc] initWithNibName:@"DeviceDetailVC" bundle:nil];
    BTDeviceInfo *selectedItem = [deviceDB deviceAtIndex:indexPath.row];
    [detailView setTitle: [[selectedItem deviceID] name]];
    [self.navigationController pushViewController:detailView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) updateDeviceListing:(BTDeviceInfo*) newListing {
    
    // see if device is in the listings
    // add it if it is new
    NSLog(@"selected device is %@", [[newListing deviceID] name]);
    bool isNew = true;
    for (int i = 0; i < [deviceDB count]; i++) {
        BTDeviceInfo *currentDevice = [deviceDB deviceAtIndex:i];
        if ([currentDevice deviceID].UUID == [newListing deviceID].UUID) {
            isNew = false;
        }
    }
    NSLog(@"device count is %d", [deviceDB count]);
    if (isNew) {
        NSMutableArray *newDeviceListing = [NSMutableArray arrayWithArray:[deviceDB devices]];
        [newDeviceListing addObject:newListing];
        [deviceDB setDevices:newDeviceListing];
    }
    [self.tableView reloadData];
}

-(void) addDevicesToList {
    
    DiscoveryViewController *discoverDevices = [[DiscoveryViewController alloc] init];
    discoverDevices.deviceDataSourceDelegate = self;
    [self.navigationController pushViewController:discoverDevices animated:YES];
}
@end
