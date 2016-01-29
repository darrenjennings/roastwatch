//
//  TimerEventDoc.h
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJSettings.h"

@class TimerLogData;

@interface TimerLogDoc : NSObject

@property (strong, nonatomic) TimerLogData *data;
@property (strong, nonatomic) UIImage *thumbImage;
@property (strong, nonatomic) UIImage *fullImage;
@property (copy) NSString *docPath;
@property (strong, nonatomic) DJSettings *settings;

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate *)dateCreated thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage startTime:(NSTimeInterval)startTime timePassed:(NSString*)timePassed eventdata:(NSMutableArray*)eventdata settings:(DJSettings*)settings;

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate *)dateCreated thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage startTime:(NSTimeInterval)startTime timePassed:(NSString*)timePassed settings:(DJSettings*)settings;


#pragma mark - file access methods

-(id)init;
-(id)initwithDocPath:(NSString *)docPath;
-(void)saveData;
-(void)deleteDoc;
-(void)saveImages;


@end
