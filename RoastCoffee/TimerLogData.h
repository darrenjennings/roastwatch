//
//  TimerEventData.h
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJTempTimerData.h"

@interface TimerLogData : NSObject <NSCoding>

@property (strong) NSString *title;
@property (strong) NSDate *dateCreated;
//timer
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, strong) NSDate *duration;
@property (nonatomic, strong) NSString *timePassed;
//laptimer
@property (nonatomic, strong) NSTimer *lapTimer;
@property NSTimeInterval lapstartTime;
@property NSTimeInterval elapsedlapTime;
@property NSDate *lapduration;
@property NSString *laptimePassed;

@property (nonatomic, strong) NSMutableArray *eventdata;


//@property NSMutableArray *secondsIntoRoast;
//@property NSMutableArray *temperatures;
//@property NSMutableArray *logs;
@property bool running;
@property bool resetCheck;

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate*)dateCreated startTime:(NSTimeInterval)startTime timePassed:(NSString*)timePassed eventdata:(NSMutableArray*)eventdata;

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate*)dateCreated startTime:(NSTimeInterval)startTime timePassed:(NSString*)timePassed eventdata:(NSMutableArray*)eventdata resetCheck:(bool)resetCheck;

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate*)dateCreated startTime:(NSTimeInterval)startTime timePassed:(NSString*)timePassed;

@end
