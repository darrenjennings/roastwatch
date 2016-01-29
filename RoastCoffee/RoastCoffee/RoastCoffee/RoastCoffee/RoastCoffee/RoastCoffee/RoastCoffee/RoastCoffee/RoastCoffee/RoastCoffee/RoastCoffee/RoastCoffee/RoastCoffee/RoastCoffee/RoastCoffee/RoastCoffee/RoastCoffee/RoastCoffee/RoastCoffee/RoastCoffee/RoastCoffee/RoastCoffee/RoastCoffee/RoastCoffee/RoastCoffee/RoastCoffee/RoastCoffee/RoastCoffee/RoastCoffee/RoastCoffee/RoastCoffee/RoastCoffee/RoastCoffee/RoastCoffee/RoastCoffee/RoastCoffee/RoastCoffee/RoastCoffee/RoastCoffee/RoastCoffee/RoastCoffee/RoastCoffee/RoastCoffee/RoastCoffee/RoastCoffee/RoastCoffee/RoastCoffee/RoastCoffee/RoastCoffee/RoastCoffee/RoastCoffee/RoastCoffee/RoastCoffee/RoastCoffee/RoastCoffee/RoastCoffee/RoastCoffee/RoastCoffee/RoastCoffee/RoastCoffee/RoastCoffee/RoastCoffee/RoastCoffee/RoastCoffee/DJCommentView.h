//
//  DJCommentView.h
//  RoastMaster
//
//  Created by Darren Jennings on 1/25/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerLogDoc.h"
#import "TimerLogData.h"
#import "DJTempTimerData.h"

@class DJCommentView;

@interface DJCommentView : UIViewController<UITextFieldDelegate>

@property (retain) TimerLogDoc *logDoc;
@property (retain) DJTempTimerData *detaildoc;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@end
