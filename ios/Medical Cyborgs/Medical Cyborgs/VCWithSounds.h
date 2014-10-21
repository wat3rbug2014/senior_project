//
//  VCWithSounds.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VCWithSounds : UIViewController

@property AVAudioPlayer *soundPlayer;

/**
 * This method is used for audio cue that a view is about to be displayed.
 */

-(void) playViewChangeSound;


/**
 * This method is used to sound the audio cue that the monitoring button has been selected.
 */

-(void) playClickSound;

/**
 * This method is the base method that the others use for playing the audio file.  It does
 * the setup of the audio player and uses the file passed to it for playback.
 * @param soundFile The NSURL of the file to be played.
 */

-(void) playSoundWithFile: (NSURL*) soundFile;

@end
