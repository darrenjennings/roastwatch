//
//  DJSettings.h
//  Roast Coffee
//
//  Created by Darren Jennings on 2/14/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJSettings.h"

@interface DJSettingsDoc : NSObject

@property (copy) NSString *docPath;
@property (strong, nonatomic) DJSettings *settings;

+(NSMutableArray *)loadSettings;
+(NSString *)nextSettingsPath;

#pragma mark - file access methods
-(id)init;
-(id)initwithDocPath:(NSString *)docPath;
-(void)saveData;
-(void)deleteDoc;

@end
