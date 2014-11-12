//
//  DummyData.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/28/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DummyData.h"
#include <stdlib.h>

@implementation DummyData

@synthesize heartRate;
@synthesize latitude;
@synthesize longitude;
@synthesize timestamp;

-(NSDate*) timestamp {
    
    return [NSDate date];
}

-(NSInteger) heartRate {
    
    int r = arc4random_uniform(80);
    return (NSInteger) r + 80;
}

-(float) longitude {
    
    return 45.0;
}

-(float) latitude {
    
    return 90.0;
}

@end
