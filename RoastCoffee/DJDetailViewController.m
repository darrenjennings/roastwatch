//
//  DJDetailViewController.m
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import "DJDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DJPlotAreaView.h"
#import "DJTableViewCell.h"
#import "TimerLogDoc.h"
#import "DJCommentView.h"
#import "DJTempTimerData.h"
#import <tgmath.h>
#include "Charts-Swift.h"

@interface DJDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DJDetailViewController

@synthesize detailItem = _detailItem;

#pragma mark - Managing the detail item

- (void)setDetailItem:(TimerLogDoc*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            NSLog(@"You just declared a new detail item.");
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    
    if (_detailItem) {
        _djDetailClockView.clockLabel.text = self.detailItem.data.timePassed;
        self.title = _detailItem.data.title;
        [_titleButton setTitle:_detailItem.data.title forState:UIControlStateNormal];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                              target:self action:@selector(actionButtonPressed:)];
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                          otherButtonTitles:@"Email in Body",@"Email Attachment",@"Upload to Dropbox", nil];
    
//    self.djGraphView = [[DJGraphView alloc] init];
    [self.djGraphView setDetailItem:_detailItem];
    
    
    //TODO:
    //add copy to clipboard, and email as attachment
    //
    [self onSlide:self.tempSlider];
    self.mediaViewBackground.layer.shadowOffset = CGSizeMake(-1, -1);
    self.mediaViewBackground.layer.shadowOpacity = 0.5;
    self.rowLabelBackground.layer.shadowOffset = CGSizeMake(-1, 1);
    self.rowLabelBackground.layer.shadowRadius = 5;
    self.rowLabelBackground.layer.shadowOpacity = 0.5;
    
    

    //alertview configuration
    _resetAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:@"Are you sure you wish to delete this roast data and start over?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    _resetAlertView.alertViewStyle = UIAlertViewStyleDefault;
    
}

- (IBAction)titleButtonChangetouchUp:(id)sender {
    NSLog(@"You've touched the button title.");
    
}



#pragma mark - View Methods
- (void)viewDidLoad
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    [super viewDidLoad];
    
    [_temptimeTable reloadData];

    [self configureView];
    _temptimeTable.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    
    //tempPreference label coloring
    if([_detailItem.settings.tempPreference isEqualToString:@"F"]){
        UILabel *clabel = (UILabel *)[self.view viewWithTag:1];
        clabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        _celsiusLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        _tempSlider.minimumValue = 75;
        _tempSlider.maximumValue = 500;
    }else{
        UILabel *flabel = (UILabel *)[self.view viewWithTag:2];
        flabel.textColor =[[UIColor grayColor] colorWithAlphaComponent:0.5f];
        _farenheitLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        _tempSlider.minimumValue = 21;
        _tempSlider.maximumValue = 260;
    }
    
    //Clock label ui
    _djDetailClockView.clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:(0.09*iOSDeviceScreenSize.height)];
    _djDetailClockView.clockLabel.adjustsFontSizeToFitWidth = YES;
    
    //Slider UI editing
    [self.tempSlider setMaxFractionDigitsDisplayed:0];
    [_tempSlider setMinimumTrackTintColor:[UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0]];
    [_tempSlider setMaximumTrackTintColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0]];
    self.tempSlider.popUpViewCornerRadius = 6.0;
    self.tempSlider.popUpViewColor = [UIColor groupTableViewBackgroundColor];
    self.tempSlider.popUpViewColor = [UIColor groupTableViewBackgroundColor];
    self.tempSlider.font = [UIFont fontWithName:@"Avenir Next" size:22];
    self.tempSlider.textColor = [UIColor blackColor];
    
    
    //Button Graphics editing...
    [self.minusTempButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [self.minusTempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.plusTempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.plusTempButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [self.jumpDownTempButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [self.jumpDownTempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.jumpUpTempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.jumpUpTempButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];

    CGRect buttonFrame;
    buttonFrame.size.height =  iOSDeviceScreenSize.height*.14;
    buttonFrame.size.width =  iOSDeviceScreenSize.height*.14;
    
    [self.startButton setFrame:buttonFrame];
    [self.recordButton setFrame:buttonFrame];

    self.startButton.layer.borderWidth = 1.5f;
    self.startButton.layer.cornerRadius = (self.startButton.frame.size.height)/2;
    self.recordButton.layer.borderWidth = 1.5f;
    self.recordButton.layer.cornerRadius = (self.startButton.frame.size.height)/2;

    // attach long press gesture to buttons
    self.lgpressInc
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(longPressInc:)];
    self.lgpressDec
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(longPressDec:)];
    _lgpressInc.minimumPressDuration = 0.3; //seconds
    _lgpressDec.minimumPressDuration = 0.3; //seconds
    _lgpressInc.cancelsTouchesInView = NO;
    _lgpressDec.cancelsTouchesInView = NO;
    
    [self.plusTempButton addGestureRecognizer:_lgpressInc];
    [self.minusTempButton addGestureRecognizer:_lgpressDec];
    self.minusTempButton.layer.borderWidth = 0.0f;

    [self configureButtons];
    
    if(self.detailItem.data.running)
    {
            NSLog(@"View did load and starting timer");
            [self startTimer];
            [self startlapTimer];
    }

    //Dropbox client
    self.dropBoxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.dropBoxClient.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [_temptimeTable reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"exited DJDetailView...");
    if(_detailItem){
        [_detailItem saveData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self stopTimer];
    [self stoplapTimer];
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) configureButtons
{
    if(!self.detailItem.data.running){
        self.recordButton.backgroundColor = [UIColor whiteColor];
        self.recordButton.layer.borderColor = [UIColor clearColor].CGColor;
        
        self.startButton.backgroundColor = [UIColor whiteColor];
        self.startButton.layer.borderColor = [UIColor clearColor].CGColor;
        [self.startButton setTitleColor:[UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateNormal];// forState:UIControlStateNormal];
        
    }else{
        self.startButton.backgroundColor = [UIColor whiteColor];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.startButton.layer.borderColor = [UIColor clearColor].CGColor;
        [self.startButton setTitleColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0] forState:UIControlStateNormal];         // flat red/pomegranate color #c0392b
        
        self.recordButton.backgroundColor = [UIColor whiteColor];
        self.recordButton.layer.borderColor = [UIColor clearColor].CGColor;
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.recordButton.titleLabel.textColor = [UIColor blackColor];

        _detailItem.data.resetCheck = false;
    }
    
    
    if(_detailItem.data.resetCheck == true){
        [self.recordButton setTitle:@"Reset" forState:UIControlStateNormal];
        [self.recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.recordButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0];
    }

}

#pragma mark - Button Tapping...
- (IBAction)startButtonTapped:(id)sender {
    
    //If it was not running, start it and do these things!!!
    if(self.detailItem.data.running == false)
    {
        NSLog(@"You have tapped the start button");
        if(_detailItem.data.duration != nil)
        {
            _detailItem.data.startTime = [[NSDate date] timeIntervalSinceDate:_detailItem.data.duration];
            _detailItem.data.lapstartTime =[[NSDate date] timeIntervalSinceDate:_detailItem.data.duration];
        }else{
            _detailItem.data.startTime = [[NSDate date] timeIntervalSinceReferenceDate];
        }
        
        [UIView setAnimationsEnabled:NO];
        
        [UIView setAnimationsEnabled:YES];
        [self startTimer];
        
        [self recordButtonTapped:self];


        [self configureButtons];
    }
    //This is the logic after you want to stop the roast.
    else{
        [self recordButtonTapped:self];
        [self stopTimer];
        [self stoplapTimer];

        self.detailItem.data.running = false;

        [UIView setAnimationsEnabled:NO];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [UIView setAnimationsEnabled:YES];
        [self configureButtons];
    }
}
- (IBAction)recordButtonTapped:(id)sender {
    
    if (!_detailItem.data.eventdata) {
        _detailItem.data.eventdata = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"You have tapped the record button");
    
    if(!_detailItem.data.resetCheck){
        NSMutableString *timePass = [[NSMutableString alloc] init];
        [timePass appendString:_djDetailClockView.clockLabel.text];
        [timePass appendString:@", "];
        if([_detailItem.settings.tempPreference isEqualToString:@"F"]){
            [timePass appendString:self.farenheitLabel.text];
        }else{[timePass appendString:self.celsiusLabel.text];}
        [timePass appendString:@"\n"];
    }
        if(self.detailItem.data.running)
        {
            [self stoplapTimer];
            _detailItem.data.lapstartTime = [[NSDate date]timeIntervalSinceReferenceDate];

                    _detailItem.data.lapTimer = [NSTimer
                                                 scheduledTimerWithTimeInterval:0.01
                                                 target:self
                                                 selector:@selector(timerTicklap:)
                                                 userInfo:nil
                                                 repeats:YES];
        }
        else{
            //check to see if you need to toggle the reset functionality
            if(_detailItem.data.resetCheck == true)
            {
                [_resetAlertView show]; //add are you sure?
            }
        }

            NSString* myNewString = [NSString stringWithFormat:@"%@", _djDetailClockView.clockLabel.text];
            
            if(self.detailItem.data.eventdata && _detailItem.data.resetCheck == false)
            {
                DJTempTimerData *tempTimerData;
                if([_detailItem.settings.tempPreference isEqualToString:@"F"])
                {
                    tempTimerData = [[DJTempTimerData alloc] initWithLog:[NSString stringWithFormat:@""] secondsIntoRoast:myNewString djDuration:self.detailItem.data.elapsedTime temperature:self.farenheitLabel.text];
                
                }else{
                    tempTimerData = [[DJTempTimerData alloc] initWithLog:[NSString stringWithFormat:@""] secondsIntoRoast:myNewString djDuration:self.detailItem.data.elapsedTime temperature:self.celsiusLabel.text];
                }

                [_detailItem.data.eventdata addObject:tempTimerData];
            
            
            //add data to the tableview
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_detailItem.data.eventdata.count-1 inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.temptimeTable insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
            [[self temptimeTable] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    
    NSDecimalNumber *intermediateNumberY = [[NSDecimalNumber alloc] initWithFloat:0.0];
    NSDecimal decimalY = [intermediateNumberY decimalValue];
    NSDecimalNumber *intermediateNumberX = [[NSDecimalNumber alloc] initWithFloat:600.0];
    NSDecimal decimalX = [intermediateNumberX decimalValue];
    //CPTPlotRange *rangeY = [CPTPlotRange plotRangeWithLocation:decimalY length:decimalX];
    //[self.djGraphView.plotSpaceTimeTemp setYRange:rangeY];
    //self.djGraphView.plotSpaceTimeTemp.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0)                   length:CPTDecimalFromCGFloat(_detailItem.data.elapsedTime)];
    [self.djGraphView.scatterTimeTempPlot reloadData];
    [_detailItem saveData];
}

#pragma mark - Rotation

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - timer methods
- (void)startTimer {

    self.detailItem.data.running = true;
        // This starts the timer which fires the timerTick
        // method every 0.01 seconds (to show milliseconds)
        // capture the GCD object inside the block,
        // the block retains the queue and BAM! retain cycle!

    _detailItem.data.timer = [NSTimer
                      scheduledTimerWithTimeInterval:0.01
                      target:self
                      selector:@selector(timerTick:)
                      userInfo:nil
                      repeats:YES];
    
}
- (void)startlapTimer{
    self.detailItem.data.running = true;
    // This starts the timer which fires the timerTick
    // method every 0.01 seconds (to show milliseconds)
    // capture the GCD object inside the block,
    // the block retains the queue and BAM! retain cycle!
    
    _detailItem.data.lapTimer = [NSTimer
                              scheduledTimerWithTimeInterval:0.01
                              target:self
                              selector:@selector(timerTicklap:)
                              userInfo:nil
                              repeats:YES];
}

- (void)timerTick:(NSTimer *)timer {
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    if(self.detailItem.data.running == false) return;
    
    //Grab the current time and compute the delta t
    NSTimeInterval endTime = [[NSDate date]timeIntervalSinceReferenceDate];
    _detailItem.data.elapsedTime = endTime - _detailItem.data.startTime;
    
    //format the new computed time and store it in a new NSDate object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.SS"];
    
    _detailItem.data.duration = [NSDate dateWithTimeIntervalSinceReferenceDate:_detailItem.data.elapsedTime];

    _djDetailClockView.clockLabel.text =[dateFormatter stringFromDate:_detailItem.data.duration];
    _detailItem.data.timePassed = _djDetailClockView.clockLabel.text;
    
//    [_detailItem saveData];
}

- (void) stopTimer{
    NSLog(@"Stopping...");
    _detailItem.data.resetCheck = true;
    if (_detailItem.data.timer != nil){
        [_detailItem.data.timer invalidate];
        _detailItem.data.timer = nil;
    }
}
- (void) stoplapTimer{
    NSLog(@"Stopping...");
    if (_detailItem.data.lapTimer != nil){
        [_detailItem.data.lapTimer invalidate];
        _detailItem.data.lapTimer = nil;
    }
}

- (void)timerTicklap:(NSTimer *)timer {
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    if(self.detailItem.data.running == false) return;
    //Grab the current time and compute the delta t
    NSTimeInterval endTime = [[NSDate date]timeIntervalSinceReferenceDate];
    _detailItem.data.elapsedlapTime = endTime - _detailItem.data.lapstartTime;
    
    //format the new computed time and store it in a new NSDate object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss:SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    _detailItem.data.lapduration = [NSDate dateWithTimeIntervalSinceReferenceDate:_detailItem.data.elapsedlapTime];
    
    //Change the clock label to the new time with each tick and store it in the TimerLogDoc object.
    _djDetailClockView.lapClockLabel.text =[dateFormatter stringFromDate:_detailItem.data.lapduration];
    _detailItem.data.laptimePassed = _djDetailClockView.lapClockLabel.text;
}

#pragma mark - action button "sharing" methods
- (void)actionButtonPressed:(id)sender;
{
    UIBarButtonItem *pressedButton = sender;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.actionSheet showFromBarButtonItem:pressedButton animated:YES];
    } else {
        [self.actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self emailLogInBody];
            break;
            
        case 1:
            [self emailLogAsAttachment];
            break;
            
        case 2:
            [self uploadToDropbox];
            break;
            
        default:
            break;
    }
}

- (void) emailLogInBody
{
    NSLog(@"email log in body of email");
    if ([MFMailComposeViewController canSendMail]) {
        
        // send log in body of email message
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        
        [picker setSubject:[NSString stringWithFormat:@"RoastWatch Log: %@", self.detailItem.data.title]];
        
        // Set up recipients
        NSArray* array = [NSArray arrayWithObjects:_detailItem.settings.exportEmailaddress, nil];
        [picker setToRecipients:array];
        
        // Fill out the email body text
        
        NSMutableString *emailBody = [[NSMutableString alloc] init];
        [emailBody appendString:@"<table border='1' style='border-collapse:collapse;'><th style='padding:5px;'>time</th><th style='padding:5px;'>temperature</th><th style='padding:5px;'>Note</th>"];
        for(int i=0; i < [self.detailItem.data.eventdata count];++i)
        {
            DJTempTimerData *thing = self.detailItem.data.eventdata[i];
            [emailBody appendString:@"<tr><td style='padding:5px;'>"];
            [emailBody appendString:thing.secondsIntoRoast];
            [emailBody appendString:@"</td><td style='padding:5px;'>"];
            [emailBody appendString:thing.temperature];
            [emailBody appendString:@"</td><td style='padding:5px;'>"];
            [emailBody appendString:thing.log];
            [emailBody appendString:@"</td></tr>"];
        };

        [emailBody appendString:@"</table>"];

        NSData *imageData = UIImageJPEGRepresentation(_detailItem.fullImage,80.0);
        
        [picker addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg", _detailItem.data.title]];
        
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        // tell user that we can't send email
        NSLog(@"Can't Send mail");
    }
}

- (void) emailLogAsAttachment
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
    
    NSLog(@"email log as attachment in email");
    if ([MFMailComposeViewController canSendMail]) {
        
        // send log in body of email message
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
            [[NSFileManager defaultManager] createFileAtPath: documentsDirectory contents:nil attributes:nil];
            NSLog(@"Route created...");
        }
        picker.mailComposeDelegate = self;
        
        [picker setSubject:[NSString stringWithFormat:@"RoastWatch Log Attached: %@.csv", self.detailItem.data.title]];
        
        // Set up recipients
        NSArray* array = [NSArray arrayWithObjects:_detailItem.settings.exportEmailaddress, nil];
        [picker setToRecipients:array];
        
        // Body of email
        NSMutableString *csvContent = [[NSMutableString alloc] init];
        NSMutableString *emailBody = [[NSMutableString alloc] init];
        [emailBody appendString:[NSString stringWithFormat:@"Title: %@",self.detailItem.data.title]];

        //Date creation for naming the event.
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTitle = [dateFormat stringFromDate:_detailItem.data.dateCreated];
        
        [emailBody appendString:[NSString stringWithFormat:@"\nDate: %@",dateTitle]];
        
        [picker setMessageBody:emailBody isHTML:NO];
        
        [csvContent appendString:@"Time"];
        [csvContent appendString:@","];
        [csvContent appendString:@"Temperature"];
        [csvContent appendString:@","];
        [csvContent appendString:@"Note"];
        [csvContent appendString:@"\n"];
        
        for(int i=0; i < [self.detailItem.data.eventdata count];++i)
        {
            DJTempTimerData *thing = self.detailItem.data.eventdata[i];
            [csvContent appendString:thing.secondsIntoRoast];
            [csvContent appendString:@","];
            [csvContent appendString:thing.temperature];
            [csvContent appendString:@","];
            [csvContent appendString:thing.log];
            [csvContent appendString:@"\n"];
        };

        //Moved this stuff out of the loop so that you write the complete string once and only once.
        NSLog(@"emailBody: %@",emailBody);

        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath:documentsDirectory];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[emailBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // Attach text file
        [picker addAttachmentData:[csvContent dataUsingEncoding:NSStringEncodingConversionAllowLossy] mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.csv", self.detailItem.data.title]];
        NSData *imageData = UIImageJPEGRepresentation(_detailItem.fullImage,80.0);
        [picker addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg", _detailItem.data.title]];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        // tell user that we can't send email
        NSLog(@"Can't Send mail");
    }
    
}
- (void) uploadToDropbox{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
    
    // Body of email
    NSMutableString *csvContent = [[NSMutableString alloc] init];
    
    [csvContent appendString:@"Time"];
    [csvContent appendString:@","];
    [csvContent appendString:@"Temperature"];
    [csvContent appendString:@","];
    [csvContent appendString:@"Note"];
    [csvContent appendString:@"\n"];
    
    for(int i=0; i < [self.detailItem.data.eventdata count];++i)
    {
        DJTempTimerData *thing = self.detailItem.data.eventdata[i];
        [csvContent appendString:thing.secondsIntoRoast];
        [csvContent appendString:@","];
        [csvContent appendString:thing.temperature];
        [csvContent appendString:@","];
        [csvContent appendString:thing.log];
        [csvContent appendString:@"\n"];
    };
    
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath:documentsDirectory];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    
    // Write a file to the local documents directory
    NSData *data = [csvContent dataUsingEncoding:NSStringEncodingConversionAllowLossy];
    [data writeToFile:documentsDirectory atomically:YES];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.dropBoxClient uploadFile:[NSString stringWithFormat:@"%@.csv", _detailItem.data.title] toPath:destDir withParentRev:nil fromPath:documentsDirectory];
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    if (self.timer4Temp != nil)
        [self.timer4Temp invalidate];
    if (self.timer4Temp != nil)
        [self.timer4Temp invalidate];
}

- (IBAction)onSlide:(UISlider*)sender {
    float celsius = 0.0;
    float faren = 0.0;
    NSString* farenString = @"";
    NSString* celsiusString = @"";
    
    if([_detailItem.settings.tempPreference isEqualToString:@"F"]){
        celsius = ((float)self.tempSlider.value - 32) / 1.8;
        farenString = [NSString stringWithFormat:@"%.0f", self.tempSlider.value];
        celsiusString = [NSString stringWithFormat:@"%.0f", celsius];
    }else{
        faren = ((float)self.tempSlider.value*1.8)+32;
        celsiusString = [NSString stringWithFormat:@"%.0f", self.tempSlider.value];
        farenString = [NSString stringWithFormat:@"%.0f", faren];
    }
    
    self.celsiusLabel.text = celsiusString;
    self.farenheitLabel.text = farenString;
}

- (void)decrementTemp:(NSTimer *)timer{
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    [self.tempSlider setValue:self.tempSlider.value-1];
    [self onSlide:self.tempSlider];

}
- (void)incrementTemp:(NSTimer *)timer{
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    [self.tempSlider setValue:self.tempSlider.value+1];
    [self onSlide:self.tempSlider];
}
- (IBAction)jumpUpTempbegan:(id)sender{
    [self.tempSlider setValue:self.tempSlider.value+10];
    [self onSlide:self.tempSlider];
}
- (IBAction)jumpDownTempbegan:(id)sender{
    [self.tempSlider setValue:self.tempSlider.value-10];
    [self onSlide:self.tempSlider];
}
- (IBAction)touchDecbegan:(id)sender {
    [self.tempSlider setValue:self.tempSlider.value-1];
    [self onSlide:self.tempSlider];
}

- (IBAction)touchIncbegan:(id)sender {
    [self.tempSlider setValue:self.tempSlider.value+1];
    [self onSlide:self.tempSlider];
}
- (IBAction)touchIncOutside:(id)sender {
    if (self.timer4Temp != nil)
        [self.timer4Temp invalidate];
    self.timer4Temp = nil;
}
- (IBAction)touchDecOutside:(id)sender {
    if (self.timer4Temp != nil)
        [self.timer4Temp invalidate];
    self.timer4Temp = nil;
}

- (void)longPressDec:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
        if (self.timer4Temp != nil)
            [self.timer4Temp invalidate];
        self.timer4Temp = nil;
        return;
    }
    if(gesture.state == UIGestureRecognizerStateBegan) {
    self.timer4Temp = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(decrementTemp:) userInfo:nil repeats:YES];
    }
}
- (void)longPressInc:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
        if (self.timer4Temp != nil)
            [self.timer4Temp invalidate];
        self.timer4Temp = nil;
        return;
    }
    if(gesture.state == UIGestureRecognizerStateBegan) {
    self.timer4Temp = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(incrementTemp:) userInfo:nil repeats:YES];
    }
}

#pragma mark - tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailItem.data.eventdata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell"];
    DJTempTimerData *event = [_detailItem.data.eventdata objectAtIndex:indexPath.row];

    cell.timeLabel.text = event.secondsIntoRoast;
    cell.tempLabel.text = event.temperature;
    cell.commentLabel.text = event.log;
    
/*    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1];
    cell.backgroundColor = bgColorView.backgroundColor;*/
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.detailItem.data.eventdata removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (IBAction)CommentEditingDidEnd:(UITextField *)sender {
    CGPoint pnt = [_temptimeTable convertPoint:sender.bounds.origin fromView:sender];
    NSIndexPath* path = [_temptimeTable indexPathForRowAtPoint:pnt];
    DJTempTimerData *event = [_detailItem.data.eventdata objectAtIndex:path.row];
    event.log = sender.text;
    NSLog(@"%@",event.log);
    CGRect rect = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y+90, _contentView.frame.size.height, _contentView.frame.size.height);
    [_contentView.layer setFrame:rect];
    CGRect rectClock = CGRectMake(_djDetailClockView.clockLabel.frame.origin.x, _djDetailClockView.clockLabel.frame.origin.y-68, _djDetailClockView.clockLabel.frame.size.width, _djDetailClockView.clockLabel.frame.size.height);
    [_djDetailClockView.clockLabel.layer setFrame:rectClock];
    [_temptimeTable reloadData];
}

- (IBAction)editingDidBegin:(id)sender {
    NSLog(@"editing of cell begins!");
    CGRect rect = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y-90, _contentView.frame.size.height, self.djGraphView.hostView.frame.size.height);
    CGRect rectClock = CGRectMake(_djDetailClockView.clockLabel.frame.origin.x, _djDetailClockView.clockLabel.frame.origin.y+68, _djDetailClockView.clockLabel.frame.size.width, _djDetailClockView.clockLabel.frame.size.height);
    [_djDetailClockView.clockLabel.layer setFrame:rectClock];
    [_contentView.layer setFrame:rect];

}

- (IBAction)commentTouchUp:(UITextField *)sender {
    CGPoint pnt = [_temptimeTable convertPoint:sender.bounds.origin fromView:sender];
    NSIndexPath* path = [_temptimeTable indexPathForRowAtPoint:pnt];
    [[self temptimeTable] scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"commentSegue"])
    {
        
        
//        NSString *object = [self.detailItem.data.logs objectAtIndex:indexPath.row];
//        [[segue destinationViewController] ];

        // Once you initiate the segue, you need to
        // pass the current event object at the selected row to the detailview controller.
        NSIndexPath *indexPath = [self.temptimeTable indexPathForSelectedRow];
        DJCommentView *cView =(DJCommentView *)segue.destinationViewController;
        DJTempTimerData* selectedCell = [_detailItem.data.eventdata objectAtIndex:indexPath.row];
        cView.detaildoc = selectedCell;
        cView.logDoc = self.detailItem;
        cView.commentText.text = selectedCell.log;
        cView.settings = self.settings;
        NSLog(@"%@",cView.detaildoc.log);
    }
}

- (void)addItemViewController:(DJCommentView *)controller didFinishEnteringItem:(NSString *)item
{
    NSLog(@"This was returned from DJCommentView %@",item);
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark Dropbox stuff
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"\"%@\" uploaded successfully!", _detailItem.data.title] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"You need to link your account under the settings menu." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSLog(@"Hey %ld", (long)buttonIndex);
    
    if(buttonIndex == 1){
        _detailItem.data.elapsedTime = 0;
        _detailItem.data.duration = nil;
        _detailItem.data.timePassed = @"00:00.00";
        _detailItem.data.laptimePassed = @"00:00.00";
        
        [_detailItem.data.eventdata removeAllObjects];
        [self.djGraphView.scatterTimeTempPlot reloadData];
        [_temptimeTable reloadData];
        _djDetailClockView.clockLabel.text = @"00:00.00";
        _djDetailClockView.lapClockLabel.text = @"00:00.00";
    }

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Done editing event!");
    }
}

@end
