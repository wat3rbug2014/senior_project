//
//  DummyDevice.m
//  TestGUI
//
//  Created by Douglas Gardiner on 9/21/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DummyDevice.h"

@implementation DummyDevice

@synthesize name;
@synthesize isConnected;

-(id) init {
    
    if (self = [super init]) {
        self.isConnected =false;
    }
    return self;
}

@end
