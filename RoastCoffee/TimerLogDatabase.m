//
//  TimerLogDatabase.m
//  RoastMaster
//
//  Created by Darren Jennings on 1/28/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "TimerLogDatabase.h"
#import "TimerLogDoc.h"

@implementation TimerLogDatabase

+(NSString *)getPrivateDocsDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil
                                                    error:&error];
    
    return documentsDirectory;
}

+(NSMutableArray *)loadTimerLogDocs {
    
    //Get private docs dir
    NSString *documentsDirectory = [TimerLogDatabase getPrivateDocsDir];
    NSLog(@"Loading logs from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    //Create TimerLogDoc for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"timerlog" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            TimerLogDoc *doc = [[TimerLogDoc alloc] initwithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    return retval;
}

+(NSString *)nextTimerLogDocPath {
    
    // get private docs dir
    NSString *documentsDirectory = [TimerLogDatabase getPrivateDocsDir];
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"timerlog" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.timerlog", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
}

@end
