//
//  AppDelegate.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/2/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize processScheduler;
@synthesize homeScreen;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    processScheduler = [[BackgroundScheduler alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    homeScreen = [[HomeScreenVC alloc] initWithBackgroundScheduler:processScheduler];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:homeScreen];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navCon;
    [self.window makeKeyAndVisible];
    [application setMinimumBackgroundFetchInterval:5.0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [[processScheduler serverPoller] pushDataToRemoteServer];
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
    

    [[processScheduler deviceManager]  disconnectSelectedMonitors];
    [[processScheduler serverPoller] pushDataToRemoteServer];
}

-(void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [processScheduler performScan];
}
@end
