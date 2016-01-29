//
//  DJTempTimerData.m
//  RoastMaster
//
//  Created by Darren Jennings on 1/27/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJTempTimerData.h"

@implementation DJTempTimerData


- (id)initWithLog:(NSString*)log secondsIntoRoast:(NSString*)secondsIntoRoast djDuration:(NSTimeInterval)djDuration temperature:(NSString*)temperature
{
    if ((self = [super init]))
    {
        self.temperature = temperature;
        self.log = log;
        self.secondsIntoRoast = secondsIntoRoast;
        self.djDuration = djDuration;
    }
    return self;
}

#pragma mark NSCoding

#define klogKey   @"log"
#define kTempKey  @"temperature"
#define ksecondsIntoRoastKey  @"secondsIntoRoast"
#define kdjDuration @"djDuration"

-(void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_log forKey:klogKey];
    [encoder encodeObject:_temperature forKey:kTempKey];
    [encoder encodeObject:_secondsIntoRoast forKey:ksecondsIntoRoastKey];
    [encoder encodeDouble:_djDuration forKey:kdjDuration];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init]; // or [self init] if needed
    if (self != nil)
    {
        NSString *temp = [decoder decodeObjectForKey:kTempKey];
        NSString *log = [decoder decodeObjectForKey:klogKey];
        NSString *secondsIntoRoast = [decoder decodeObjectForKey:ksecondsIntoRoastKey];
        NSTimeInterval djDuration = [decoder decodeDoubleForKey:kdjDuration];
        return [self initWithLog:log secondsIntoRoast:secondsIntoRoast djDuration:djDuration temperature:temp];
    }
    return self;
}

@end
