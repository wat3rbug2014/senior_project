//
//  TableVCWithSoundsTableViewController.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "TableVCWithSounds.h"
#import <UIKit/UIKit.h>

@interface TableVCWithSounds ()

@end

@implementation TableVCWithSounds

@synthesize soundPlayer;
@synthesize deviceManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    
    //[self playViewChangeSound];
    [super viewWillDisappear:animated];
}

-(void) playViewChangeSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Star Trek Door" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playClickSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"click_one" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playSoundWithFile:(NSURL *)soundFile {
    
    if (soundFile == nil) {
        return;
    }
    NSError *error = nil;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    float old_volume = [soundPlayer volume];
    if (error == nil) {
        [soundPlayer setVolume:0.2];
        [soundPlayer prepareToPlay];
        [soundPlayer play];
        [soundPlayer setVolume:old_volume];
    }
}

-(id) initWithDeviceManager: (BTDeviceManager*) newDeviceManager {
    
    if (newDeviceManager == nil) {
        return nil;
    }
    // this may be a bad hack because I haven't defined self yet
    
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.deviceManager = newDeviceManager;
        [deviceManager setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:)
                name:@"BTDeviceDiscovery" object:self.deviceManager];
    }
    return self;
}

-(void) updateTable:(NSNotification*) notification {
    
    [self.tableView reloadData];
}

-(void) deviceManagerDidUpdateMonitors {
    
    
}

@end
