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
    UIApplication *app = [UIApplication sharedApplication];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [app registerUserNotificationSettings:settings];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [[processScheduler serverPoller] pushDataToRemoteServer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"app is now in background");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:[UIUserNotificationSettings
            settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    [app setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    

    [[processScheduler deviceManager]  disconnectSelectedMonitors];
    [[processScheduler serverPoller] pushDataToRemoteServer];
    UIApplication *app = [UIApplication sharedApplication];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:[UIUserNotificationSettings
            settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    [app setApplicationIconBadgeNumber:0];
}

-(void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // I think this needs rework to check to see if monitoring is happening so that we can disregard or turn off devices.
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
