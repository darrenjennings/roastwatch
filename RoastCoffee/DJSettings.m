//
//  DJSettings.m
//  Roast Coffee
//
//  Created by Darren Jennings on 3/21/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJSettings.h"

@implementation DJSettings

- (id)initWithTempEvents:(NSString *)tempPreference eventsCustom:(NSMutableArray *)eventsCustom{
    if ((self = [super init]))
    {
        self.tempPreference = tempPreference;
        self.eventsCustom = eventsCustom;
    }
    return self;
}

- (id)initWithTempMinMaxEvents:(NSString *)tempPreference eventsCustom:(NSMutableArray *)eventsCustom minTemp:(NSString *)minTemp maxTemp:(NSString *)maxTemp{
    if ((self = [super init]))
    {
        self.tempPreference = tempPreference;
        self.eventsCustom = eventsCustom;
        self.minTemp = minTemp;
        self.maxTemp = maxTemp;
    }
    return self;
}

- (id)init:(NSString *)tempPreference eventsCustom:(NSMutableArray *)eventsCustom minTemp:(NSString *)minTemp maxTemp:(NSString *)maxTemp exportEmailAddress:(NSString *)exportEmailaddress{
    if ((self = [super init]))
    {
        self.tempPreference = tempPreference;
        self.eventsCustom = eventsCustom;
        self.minTemp = minTemp;
        self.maxTemp = maxTemp;
        self.exportEmailaddress = exportEmailaddress;
    }
    return self;
}

#pragma mark NSCoding

#define kTempPreferenceKey   @"tempPreference"
#define keventDataKey  @"eventsCustom"
#define kminTempKey  @"minTemp"
#define kmaxTempKey  @"maxTemp"
#define kemailTempKey  @"exportEmailTemp"

-(void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_tempPreference forKey:kTempPreferenceKey];
    [encoder encodeObject:_eventsCustom forKey:keventDataKey];
    [encoder encodeObject:_minTemp forKey:kminTempKey];
    [encoder encodeObject:_maxTemp forKey:kmaxTempKey];
    [encoder encodeObject:_exportEmailaddress forKey:kemailTempKey];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init]; // or [self init] if needed
    if (self != nil)
    {
        //Date creation for naming the event.
        NSString *tempPreference = [decoder decodeObjectForKey:kTempPreferenceKey];
        NSMutableArray *eventsCustom = [decoder decodeObjectForKey:keventDataKey];
        NSString *minTemp = [decoder decodeObjectForKey:kminTempKey];
        NSString *maxTemp = [decoder decodeObjectForKey:kmaxTempKey];
        NSString *exportEmailaddressTemp = [decoder decodeObjectForKey:kemailTempKey];
        
        return [self init:tempPreference eventsCustom:eventsCustom minTemp:minTemp maxTemp:maxTemp exportEmailAddress:exportEmailaddressTemp];
    }
    return self;
}

@end
