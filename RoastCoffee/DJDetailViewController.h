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
#import "DJDetailClockView.h"
#import "ASValueTrackingSlider.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DJGraphView.h"

@class TimerLogDoc;


@interface DJDetailViewController : UIViewController <UIScrollViewDelegate,UISplitViewControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DBRestClientDelegate, UIAlertViewDelegate>
//, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet DJGraphView *djGraphView;
@property (strong, nonatomic) IBOutlet DJDetailClockView *djDetailClockView;

@property NSTimeInterval lapstartTime;
@property NSTimeInterval elapsedlapTime;
@property NSDate *lapduration;
@property NSString *laptimePassed;
@property NSTimer * timer4Temp;

@property (strong, nonatomic) TimerLogDoc* detailItem;
@property (strong, nonatomic) DJSettings* settings;

@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *tempSlider;
@property (strong, nonatomic) IBOutlet UIButton *titleButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *plusTempButton;
@property (strong, nonatomic) IBOutlet UIButton *minusTempButton;
@property (strong, nonatomic) IBOutlet UIButton *jumpUpTempButton;
@property (strong, nonatomic) IBOutlet UIButton *jumpDownTempButton;
@property (strong, nonatomic) IBOutlet UIStepper *tempStepper;

//@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
//@property (strong, nonatomic) IBOutlet UILabel *lapClockLabel;

@property (strong, nonatomic) IBOutlet UILabel *celsiusLabel;
@property (strong, nonatomic) IBOutlet UILabel *farenheitLabel;

@property (retain) UIActionSheet *actionSheet;

@property (strong, nonatomic) IBOutlet UITableView *temptimeTable;
@property (retain) DJCommentView *commentViewController;

@property (retain) UILongPressGestureRecognizer *lgpressInc;
@property (retain) UILongPressGestureRecognizer *lgpressDec;
@property (weak, nonatomic) IBOutlet UIView *mediaViewBackground;
@property (weak, nonatomic) IBOutlet UIView *rowLabelBackground;

//Alert View for confirming reset of roast
@property (strong, nonatomic) UIAlertView *resetAlertView;

// Dropbox client
@property (nonatomic, strong) DBRestClient *dropBoxClient;

- (void) startTimer;
- (IBAction)startButtonTapped:(id)sender;
- (IBAction)recordButtonTapped:(id)sender;
- (void) actionButtonPressed:(id)sender;
- (void) decrementTemp:(id) sender;
- (void) emailLogInBody;

@end
