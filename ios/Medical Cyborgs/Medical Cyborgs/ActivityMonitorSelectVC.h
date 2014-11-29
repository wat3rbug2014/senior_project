//
//  ActivityMonitorSelectVC.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 9/22/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//
/**
 * This screen allows for selection and discovery of bluetooth devices that
 * conform to the activity monitoring services.
 */

#import "TableVCWithSounds.h"


@interface ActivityMonitorSelectVC : TableVCWithSounds


/**
 * This method unchecks the previous cell if one is selected so that duplicate
 * selection does not display.
 *
 * @param tableView The tableview that contains the cells for updating.
 */

-(void) unCheckPreviousCellForTableView: (UITableView*) tableView;

@end
