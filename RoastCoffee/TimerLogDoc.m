//
//  TimerEventDoc.m
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import "TimerLogDoc.h"
#import "TimerLogData.h"
#import "TimerLogDatabase.h"
#define kDataKey    @"Data"
#define kDataFile   @"data.plist"
#define kThumbImageFile @"thumbImage.jpg"
#define kFullImageFile  @"fullImage.jpg"

@implementation TimerLogDoc

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate *)dateCreated thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage startTime:(NSTimeInterval)startTime timePassed:(NSString *)timePassed eventdata:(NSMutableArray*)eventdata settings:(DJSettings*)settings resetCheck:(bool)resetCheck{
    if ((self = [super init])) {
        self.data = [[TimerLogData alloc]
                     initWithTitle:title
                     dateCreated:dateCreated
                     startTime:startTime
                     timePassed:timePassed
                     eventdata:eventdata
                     resetCheck:resetCheck];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
        self.settings = settings;
    }
    
    return self;
}

- (id)initWithTitle:(NSString*)title dateCreated:(NSDate *)dateCreated thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage startTime:(NSTimeInterval)startTime timePassed:(NSString *)timePassed eventdata:(NSMutableArray*)eventdata settings:(DJSettings*)settings{
    if ((self = [super init])) {
        self.data = [[TimerLogData alloc]
                     initWithTitle:title
                     dateCreated:dateCreated
                     startTime:startTime
                     timePassed:timePassed
                     eventdata:eventdata
                     ];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
        self.settings = settings;
    }
    
    return self;
}



- (id)initWithTitle:(NSString*)title dateCreated:(NSDate *)dateCreated thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage startTime:(NSTimeInterval)startTime timePassed:(NSString *)timePassed settings:(DJSettings*)settings{
    if ((self = [super init])) {
        self.data = [[TimerLogData alloc]
                     initWithTitle:title
                     dateCreated:dateCreated
                     startTime:startTime
                     timePassed:timePassed];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
        self.settings = settings;
    }
    
    return self;
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
        _docPath = [TimerLogDatabase nextTimerLogDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}

-(TimerLogData *)data {
    if (_data != nil) return _data;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return _data;
}

-(void)saveData {
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
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

// Add new functions
- (UIImage *)thumbImage {
    
    if (_thumbImage != nil) return _thumbImage;
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    return [UIImage imageWithContentsOfFile:thumbImagePath];
    
}

- (UIImage *)fullImage {
    
    if (_fullImage != nil) return _fullImage;
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    return [UIImage imageWithContentsOfFile:fullImagePath];
    
}
- (void)saveImages {
    
    if (_thumbImage == nil || _fullImage == nil) return;
    
    [self createDataPath];
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    NSData *thumbImageData = UIImagePNGRepresentation(_thumbImage);
    [thumbImageData writeToFile:thumbImagePath atomically:YES];
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    NSData *fullImageData = UIImagePNGRepresentation(_fullImage);
    [fullImageData writeToFile:fullImagePath atomically:YES];
    
    self.thumbImage = nil;
    self.fullImage = nil;
}

@end
