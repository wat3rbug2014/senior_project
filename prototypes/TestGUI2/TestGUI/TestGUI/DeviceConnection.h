//
//  DeviceConnection.h
//  TestGUI
//
//  Created by Douglas Gardiner on 9/30/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeviceConnection <NSObject>

@required

-(BOOL) isConnected;
-(void) connect;
-(void) disconnect;
-(NSData*) getData;
-(NSInteger) batteryLevel;

@end
