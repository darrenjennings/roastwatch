//
//  TimerEventData.m
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import "TimerLogData.h"

@implementation TimerLogData

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate*)dateCreated startTime:(NSTimeInterval)startTime timePassed:(NSString *)timePassed eventdata:(NSMutableArray *)eventdata resetCheck:(bool)resetCheck
{
    if ((self = [super init]))
    {
        self.title = title;
        self.dateCreated = dateCreated;
        self.startTime = startTime;
        self.timePassed = timePassed;
        self.eventdata = eventdata;
        self.resetCheck = resetCheck;
    }
    return self;
}

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate*)dateCreated startTime:(NSTimeInterval)startTime timePassed:(NSString *)timePassed eventdata:(NSMutableArray *)eventdata
{
    if ((self = [super init]))
    {
        self.title = title;
        self.dateCreated = dateCreated;
        self.startTime = startTime;
        self.timePassed = timePassed;
        self.eventdata = eventdata;
    }
    return self;
}

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate*)dateCreated startTime:(NSTimeInterval)startTime timePassed:(NSString *)timePassed
{
    if ((self = [super init]))
    {
        self.title = title;
        self.dateCreated = dateCreated;
        self.startTime = startTime;
        self.timePassed = timePassed;
    }
    return self;
}

#pragma mark NSCoding

#define kTitleKey   @"Title"
#define keventDataKey  @"eventData"
#define kdateCreatedKey  @"dateCreated"
//#define kstartTimeKey  @"startTime"
#define ktimePassedKey  @"timePassed"
#define kresetCheck  @"resetCheck"

-(void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_eventdata forKey:keventDataKey];
    [encoder encodeObject:_dateCreated forKey:kdateCreatedKey];
    [encoder encodeObject:_timePassed forKey:ktimePassedKey];
    [encoder encodeBool:_resetCheck forKey:kresetCheck];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init]; // or [self init] if needed
    if (self != nil)
    {
        //Date creation for naming the event.
        NSString *title = [decoder decodeObjectForKey:kTitleKey];
        NSMutableArray *eventData = [decoder decodeObjectForKey:keventDataKey];
        NSDate *dateCreated = [decoder decodeObjectForKey:kdateCreatedKey];
        NSString *timePassed = [decoder decodeObjectForKey:ktimePassedKey];
        bool resetCheck = [decoder decodeObjectForKey:kresetCheck];
        return [self initWithTitle:title dateCreated:dateCreated startTime:0 timePassed:timePassed eventdata:eventData resetCheck: resetCheck];
    }
    return self;
}

@end
