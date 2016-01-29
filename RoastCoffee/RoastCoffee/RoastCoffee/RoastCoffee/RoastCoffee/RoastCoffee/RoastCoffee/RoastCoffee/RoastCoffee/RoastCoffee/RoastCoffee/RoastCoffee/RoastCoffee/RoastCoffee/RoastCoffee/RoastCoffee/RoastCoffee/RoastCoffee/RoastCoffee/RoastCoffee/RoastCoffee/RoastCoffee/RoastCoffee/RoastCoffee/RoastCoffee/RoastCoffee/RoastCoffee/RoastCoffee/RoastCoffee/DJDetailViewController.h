//
//  DJDetailViewController.h
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TimerLogDoc.h"
#import "TimerLogData.h"
#import "DJCommentView.h"

@class TimerLogDoc;


@interface DJDetailViewController : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate, CPTPlotDataSource, CPTPlotDelegate, CPTScatterPlotDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
//, UIPickerViewDataSource, UIPickerViewDelegate>

@property NSTimeInterval lapstartTime;
@property NSTimeInterval elapsedlapTime;
@property NSDate *lapduration;
@property NSString *laptimePassed;
@property NSTimer * timer4Temp;

@property (strong, nonatomic) TimerLogDoc * detailItem;

@property (strong, nonatomic) IBOutlet UISlider *tempSlider;
@property (strong, nonatomic) IBOutlet UIButton *titleButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *plusTempButton;
@property (strong, nonatomic) IBOutlet UIButton *minusTempButton;
@property (strong, nonatomic) IBOutlet UIStepper *tempStepper;

@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (strong, nonatomic) IBOutlet UILabel *lapClockLabel;

@property (strong, nonatomic) IBOutlet UILabel *celsiusLabel;
@property (strong, nonatomic) IBOutlet UILabel *farenheitLabel;

@property (retain) UIActionSheet *actionSheet;
@property (retain) CPTScatterPlot *scatterTimeTempPlot;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTXYPlotSpace *plotSpaceTimeTemp;

@property (strong, nonatomic) IBOutlet UITableView *temptimeTable;
@property (retain) DJCommentView *commentViewController;

- (void) startTimer;
- (IBAction)startButtonTapped:(id)sender;
- (IBAction)recordButtonTapped:(id)sender;
- (void) actionButtonPressed:(id)sender;
- (void) decrementTemp:(id) sender;
- (void) emailLogInBody;
/*- (void) emailLogAsAttachment;
- (void) copyLogToClipboard;*/

@end
