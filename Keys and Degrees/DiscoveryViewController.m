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

@synthesize devices;
@synthesize bluetoothSearchBox;
static NSString *cellWithTemp = @"ShowTemp";
static NSString *cellBasic = @"Basic";
@synthesize deviceDataSourceDelegate;
@synthesize selectedDevice;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        bluetoothSearchBox = [[DiscoveryController alloc] init];
        self.title = @"Discovery";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotificationOfBTDiscovery) name:@"BTDiscoveryChange" object:bluetoothSearchBox];
    }

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

-(void) viewWillDisappear:(BOOL)animated {
    
    if (selectedDevice != nil) {
        [deviceDataSourceDelegate updateDeviceListing:selectedDevice];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [devices count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTDeviceInfo *newSelection = [[BTDeviceInfo alloc] initWithDevice:[devices objectAtIndex:indexPath.row]];
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
    [[cell textLabel] setText:[currentDevice name]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BTDiscoveryChange" object:bluetoothSearchBox];
}

-(void) receivedNotificationOfBTDiscovery {
    
    NSLog(@"Received notification.  Device count is %d", [[bluetoothSearchBox discoveredDevices] count]);
    devices = [bluetoothSearchBox discoveredDevices];
    
    [self.tableView reloadData];
}
@end
