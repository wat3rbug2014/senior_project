//
//  DataCaptureController.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/2/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DataCaptureManager.h"



@implementation DataCaptureManager

@synthesize devicePoller;
@synthesize networkServerPoller;
@synthesize btManager;

+(id) sharedManager {
    static DataCaptureManager *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
            [sharedManager setBtManager:[[BTDeviceManager alloc] init]];
        }
    }
    return sharedManager;
}

-(BOOL)heartMonitorIsConnected {
    
    return [btManager heartMonitorIsConnected];
}

-(BOOL)activityMonitorIsConnected {
    
    return [btManager activityMonitorIsConnected];
}
@end
