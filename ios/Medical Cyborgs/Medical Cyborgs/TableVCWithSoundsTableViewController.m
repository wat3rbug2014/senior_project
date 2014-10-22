//
//  TableVCWithSoundsTableViewController.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "TableVCWithSoundsTableViewController.h"
#import <UIKit/UIKit.h>

@interface TableVCWithSoundsTableViewController ()

@end

@implementation TableVCWithSoundsTableViewController

@synthesize soundPlayer;

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
    
    [self playViewChangeSound];
    [super viewWillDisappear:animated];
}

-(void) playViewChangeSound {
    
    NSString *soundFile = nil; // disabled because overall navigation will change
   // NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Star Trek Door" ofType:@"m4r"];
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


@end
