//
//  DJSettings.h
//  Roast Coffee
//
//  Created by Darren Jennings on 3/21/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJSettings : NSObject <NSCoding>

@property (nonatomic, strong) NSString *tempPreference;
@property (nonatomic, strong) NSMutableArray *eventsCustom;
@property (nonatomic, strong) NSString *minTemp;
@property (nonatomic, strong) NSString *maxTemp;
@property (nonatomic, strong) NSString *exportEmailaddress;

- (id)initWithTempEvents:(NSString*)tempPreference eventsCustom:(NSMutableArray*)eventsCustom;
- (id)initWithTempMinMaxEvents:(NSString*)tempPreference eventsCustom:(NSMutableArray*)eventsCustom minTemp:(NSString*)minTemp maxTemp:(NSString*)maxTemp;
- (id)init:(NSString*)tempPreference eventsCustom:(NSMutableArray*)eventsCustom minTemp:(NSString*)minTemp maxTemp:(NSString*)maxTemp exportEmailAddress:(NSString*)exportEmailaddress;
@end
