//
//  AppDelegate.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/2/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * The starting point of the Objective-C code for the application.
 */

#import <UIKit/UIKit.h>
#import "BackgroundScheduler.h"
#import "HomeScreenVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


/**
 * The first view of the application once it starts.
 */

@property (strong, nonatomic) UIWindow *window;


/**
 * The background scheduler that is used for monitoring the state of the application.
 */

@property (strong, nonatomic) BackgroundScheduler *processScheduler;


/**
 * The startinv view of the application.  It is passed to the window once the application
 * starts.
 */

@property (strong) HomeScreenVC *homeScreen;

@end

