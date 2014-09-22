//
//  HeartMonitorSelectVCViewController.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "HeartMonitorSelectVC.h"
#import "DummyDevice.h"

@interface HeartMonitorSelectVC ()

@end

@implementation HeartMonitorSelectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Heart Rate Monitors";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[super.deviceManager heartDevices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Default";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [[cell textLabel] setText:[[[super.deviceManager heartDevices ] objectAtIndex:indexPath.row] name]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    DummyDevice *selectedDevice = [super.deviceManager deviceAtIndex:indexPath.row forMonitorType:HEART_MONITOR];
    [selectedDevice setIsConnected:YES];
    [super.deviceManager setHeartMonitorIsConnected:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
