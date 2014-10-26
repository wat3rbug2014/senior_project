//
//  DBManager.h
//  Medical Cyborgs
//
//  Created by Douglas Gardiner on 10/25/14.
//  Copyright (c) 2014 Douglas Gardiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;


-(instancetype) initWithDatabaseFileName: (NSString*) filename;
-(void)copyDatabaseIntoDocumentsDirectory;

@end
