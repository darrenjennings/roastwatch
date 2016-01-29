//
//  DJTempTimerData.h
//  RoastMaster
//
//  Created by Darren Jennings on 1/27/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJTempTimerData : NSObject<NSCoding>

@property NSString *secondsIntoRoast;
@property NSTimeInterval djDuration;
@property NSString *temperature;
@property NSString *log;

- (id)initWithLog:(NSString*)log secondsIntoRoast:(NSString*)secondsIntoRoast djDuration:(NSTimeInterval)djDuration temperature:(NSString*)temperature;

@end
