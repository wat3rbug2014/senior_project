//
//  HeartMonitorSelectVCViewController.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

/**
 * This screen does the device selection for devices that have been discovered
 * that perform heart monitoring functions.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TableVCWithSounds.h"

@interface HeartMonitorSelectVC : TableVCWithSounds


/**
 * This method unchecks the previous cell if one is selected so that duplicate
 * selection does not display.
 *
 * @param tableView The tableview that contains the cells for updating.
 */

-(void) unCheckPreviousCellForTableView: (UITableView*) tableView;

@end
