//
//  DeviceDetailVC.m
//  Keys and Degrees
//
//  Created by Douglas Gardiner on 8/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DeviceDetailVC.h"

@interface DeviceDetailVC ()

@end

@implementation DeviceDetailVC

@synthesize  useSounds;
@synthesize btManager;
@synthesize bluetoothPeripheral;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.useSounds = true;
        btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    
    // if the device is not already disconnected then do so.
    
    if ([[bluetoothPeripheral deviceID] state] != CBPeripheralStateDisconnected) {
        NSLog(@"Disconnecting from %@", [[bluetoothPeripheral deviceID] name]);
        [btManager cancelPeripheralConnection:[bluetoothPeripheral deviceID]];
    }
}
#pragma mark -
#pragma CBCentralManagerDelegate Protocol methods

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        [[bluetoothPeripheral deviceID] setDelegate:self];
        [btManager connectPeripheral:[bluetoothPeripheral deviceID] options:nil];
        NSLog(@"Connecting to %@", [[bluetoothPeripheral deviceID] name]);
        // do subscription to service to receive updates
    }
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"%@ is disconnected", [peripheral name]);
    if (error != nil) {
        // do something to try an reconnect if possible
        
    }
    
}

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Failed to connect");
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    // start doing RSSI and temp readings and doing routine
    
    NSLog(@"Connected to %@", [peripheral name]);
}



#pragma mark -
#pragma mark Custom methods

-(IBAction)changeSoundSetting:(id)sender {
    
    useSounds = !useSounds;
    if (useSounds) {
        NSLog(@"Sounds are on");
    } else {
        NSLog(@"Sounds are off");
    }
}
@end
