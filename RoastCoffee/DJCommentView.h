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

@interface DJCommentView : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *TableViewContainer;
@property (retain) TimerLogDoc *logDoc;
@property (retain) DJTempTimerData *detaildoc;
@property (strong, nonatomic) IBOutlet UITableView *EventTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@property (weak, nonatomic) IBOutlet UITextField *roastTemp;
@property (strong, nonatomic) DJSettings* settings;

@end
