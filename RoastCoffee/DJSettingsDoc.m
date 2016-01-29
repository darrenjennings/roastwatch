//
//  DJSettings.m
//  Roast Coffee
//
//  Created by Darren Jennings on 2/14/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJSettingsDoc.h"
#define kSettingsKey    @"Data"
#define kSettingsFile   @"data.plist"

@implementation DJSettingsDoc

+(NSString *)getPrivateDocsDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *settingsDirectory = [paths objectAtIndex:0];
    settingsDirectory = [settingsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:settingsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return settingsDirectory;
}

+(NSMutableArray *)loadSettings {
    
    //Get private docs dir
    NSString *settingsDirectory = [DJSettingsDoc getPrivateDocsDir];
    NSLog(@"Loading Settings from %@", settingsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:settingsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of settings directory: %@", [error localizedDescription]);
        return nil;
    }
    
    //Create SettingsDoc for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"setting" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [settingsDirectory stringByAppendingPathComponent:file];
            DJSettingsDoc *settingsdoc = [[DJSettingsDoc alloc] initwithDocPath:fullPath];
            [retval addObject:settingsdoc];
        }
    }
    if(retval.count > 0)
    {
        return retval;
    }else{
        DJSettingsDoc *settings = [[DJSettingsDoc alloc] init];
        settings.settings = [[DJSettings alloc] init:@"F" eventsCustom:[NSMutableArray arrayWithObjects: @"First Crack Begin", @"First Crack End", @"Roast End", nil] minTemp:nil maxTemp:nil exportEmailAddress:@"editMeUnderSettings@somewhere.com"];
        [retval addObject:settings];
        return retval;
    }
}

+(NSString *)nextSettingsPath {
    
    // get private docs dir
    NSString *settingsDirectory = [DJSettingsDoc getPrivateDocsDir];
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:settingsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"setting" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.setting", maxNumber+1];
    return [settingsDirectory stringByAppendingPathComponent:availableName];
}

#pragma mark - File Access Methods
-(id)init{
    if ((self = [super init])) {
    }
    return self;
}

-(id)initwithDocPath:(NSString *)docPath {
    _docPath = [docPath copy];
    return self;
}

-(BOOL)createDataPath {
    if (_docPath == nil) {
        _docPath = [DJSettingsDoc nextSettingsPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}

-(DJSettings *)settings {
    if (_settings != nil) return _settings;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kSettingsFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _settings = [unarchiver decodeObjectForKey:kSettingsKey];
    [unarchiver finishDecoding];
    
    return _settings;
}

-(void)saveData {
    
    if (_settings == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kSettingsFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_settings forKey:kSettingsKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

-(void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}

@end
