//
//  AppDelegate.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/2/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize processScheduler;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    processScheduler = [[BackgroundScheduler alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HomeScreenVC *homeScreen = [[HomeScreenVC alloc] initWithBackgroundScheduler:processScheduler];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:homeScreen];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navCon;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [[processScheduler serverPoller] flushDatabase];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"app is now in background");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    

    [[processScheduler deviceManager]  disconnectAllDevices];
    [[processScheduler serverPoller] flushDatabase];
}

@end
