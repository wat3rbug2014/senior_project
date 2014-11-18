//
//  DeviceConstantsAndStaticFunctions.m
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 11/15/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import "DeviceConstantsAndStaticFunctions.h"

@implementation DeviceConstantsAndStaticFunctions

NSString * const BTHeartConnected = @"BTHeartConnected";
NSString * const BTActivityConnected = @"BTActivityConnected";
NSString * const DEVICE_DISCOVERED = @"BTDeviceDiscovered";
NSString * const BATTERY = @"Battery";
NSString * const BATTERY_LVL = @"Battery Level";
NSString * const DEVICE_READ_VALUE = @"BTDeviceValueUpdated";
NSInteger const NONE_SELECTED = -1;
NSString * const POLARH7_SERV_UUID = @"180D";
NSString * const POLARH7_HRM_UUID = @"2A37";

NSInteger NO_BATTERY_VALUE = 0;
NSString * const BATTERY_LOW_NOTIFCATION_STR = @"Battery Level Low";


+(int) activityLevelBasedOnHeartRate: (NSInteger) heartRate andAge: (NSInteger) age {
    
    int result = 0;
    NSInteger mhr = 208 - ((NSInteger)(.7 * age));
    float percentOfMax = ((float)heartRate/ (float)mhr);
    if (percentOfMax < 0.5) {
        result =  RESTING;
    }
    if (percentOfMax >= 0.5 && percentOfMax < 0.6) {
        result = WARM_UP;
    }
    if (percentOfMax >= 0.6 && percentOfMax < 0.7) {
        result = ENDURANCE;
    }
    if (percentOfMax >= .7 && percentOfMax < .8) {
        result = AEROBIC;
    }
    if (percentOfMax >= .8 && percentOfMax < .9) {
        result = ANAEROBIC;
    }
    if (percentOfMax >= 0.9) {
        result = PEAK;
    }
    return result;
}

+(NSString*) activityPhraseUsingActivityLevel: (int) activity {
    
    NSString *result = nil;
    switch (activity) {
        case PEAK: result = @"Peak Performance";
            break;
        case WARM_UP: result = @"Warming Up";
            break;
        case ENDURANCE: result = @"Endurance";
            break;
        case AEROBIC: result = @"Aerobic Exercise";
            break;
            case  ANAEROBIC: result = @"Anaerobic Exercise";
            break;
        default: result = @"Resting";
            break;
            
    }
    return result;
}
@end
