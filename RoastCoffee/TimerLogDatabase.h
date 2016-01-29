//
//  TimerLogDatabase.h
//  RoastMaster
//
//  Created by Darren Jennings on 1/28/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimerLogDatabase : NSObject

+(NSMutableArray *)loadTimerLogDocs;
+(NSString *)nextTimerLogDocPath;

@end
