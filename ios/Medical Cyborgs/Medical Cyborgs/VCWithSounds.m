//
//  VCWithSounds.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "VCWithSounds.h"

@implementation VCWithSounds : UIViewController

@synthesize soundPlayer;


-(void) viewWillDisappear:(BOOL)animated {
    
    [self playViewChangeSound];
    [super viewWillDisappear:animated];
}

-(void) playViewChangeSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Star Trek Door" ofType:@"m4r"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playClickSound {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"click_one" ofType:@"m4a"];
    NSURL *soundFileLocation = [[NSURL alloc] initFileURLWithPath:soundFile];
    [self playSoundWithFile:soundFileLocation];
}

-(void) playSoundWithFile:(NSURL *)soundFile {
    
    NSError *error = nil;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    float old_volume = [soundPlayer volume];
    if (error == nil) {
        [soundPlayer setVolume:0.5];
        [soundPlayer prepareToPlay];
        [soundPlayer play];
        [soundPlayer setVolume:old_volume];
    }
}

@end
