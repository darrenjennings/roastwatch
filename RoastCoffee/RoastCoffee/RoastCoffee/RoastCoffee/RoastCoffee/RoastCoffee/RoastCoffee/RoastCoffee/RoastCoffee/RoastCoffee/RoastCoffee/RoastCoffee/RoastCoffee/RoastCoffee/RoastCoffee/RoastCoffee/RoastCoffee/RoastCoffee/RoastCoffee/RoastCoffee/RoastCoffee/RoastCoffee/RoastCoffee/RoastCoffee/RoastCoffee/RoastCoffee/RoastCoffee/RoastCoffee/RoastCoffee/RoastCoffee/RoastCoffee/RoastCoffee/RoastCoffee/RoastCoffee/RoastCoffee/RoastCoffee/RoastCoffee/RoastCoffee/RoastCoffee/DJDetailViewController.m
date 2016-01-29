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
    
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.clockLabel.text = self.detailItem.data.timePassed;
        //TODO
        //update the detailview
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                              target:self action:@selector(actionButtonPressed:)];
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                          otherButtonTitles:@"Email in Body",@"Email Attachment", nil];
       [self initPlot];
    //TODO
    //add copy to clipboard, and email as attachment
    //

}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}
-(void)configureHost {
	
}

-(void)configureGraph {
	// 1 - Create the graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
	self.hostView.hostedGraph = graph;
	// 2 - Set graph title
//	NSString *title = [NSString stringWithFormat:@"Roasting %@", self.detailItem.data.title];
    
	graph.title = @"";
    
	// 3 - Create and set text style
	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
//	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottom;
	graph.titleDisplacement = CGPointMake(10.0f, 0.0f);
	
    // 4 - Set padding for plot area
	[graph.plotAreaFrame setPaddingLeft:10.0f];
	[graph.plotAreaFrame setPaddingBottom:0.0f];
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border


	// 5 - Enable user interactions for plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
	plotSpace.allowsUserInteraction = YES;
}
- (IBAction)titleButtonChangetouchUp:(id)sender {
    NSLog(@"You've touched the button title.");
    
}

-(void)configurePlots {
	// 1 - Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	_plotSpaceTimeTemp = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    // 2 - Create the plots
	self.scatterTimeTempPlot = [[CPTScatterPlot alloc] init];
	self.scatterTimeTempPlot.dataSource = self;
    self.scatterTimeTempPlot.identifier = @"TimerPlotz";
    self.scatterTimeTempPlot.borderColor = [UIColor blackColor].CGColor;
    CPTColor *scatterTimeTempPlotcolor = [CPTColor colorWithComponentRed:130.0/255.0f green:90.0f/255.0f blue:44.0f/255.0f alpha:1.0f]
;
    [graph addPlot:self.scatterTimeTempPlot toPlotSpace:_plotSpaceTimeTemp];

    // 3 - Set up plot space
    
    [_plotSpaceTimeTemp scaleToFitPlots:[NSArray arrayWithObjects:self.scatterTimeTempPlot, nil]];
    
	CPTMutablePlotRange *xRange = [_plotSpaceTimeTemp.xRange mutableCopy];
	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(2.5f)];
	_plotSpaceTimeTemp.xRange = xRange;
	CPTMutablePlotRange *yRange = [_plotSpaceTimeTemp.yRange mutableCopy];
	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(2.5f)];
	_plotSpaceTimeTemp.yRange = yRange;
    


	// 4 - Create styles and symbols
	CPTMutableLineStyle *djLineStyle = [self.scatterTimeTempPlot.dataLineStyle mutableCopy];
	djLineStyle.lineWidth = 2.5;
	djLineStyle.lineColor = scatterTimeTempPlotcolor;
	self.scatterTimeTempPlot.dataLineStyle = djLineStyle;
	CPTMutableLineStyle *djSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	djSymbolLineStyle.lineColor = scatterTimeTempPlotcolor;
	CPTPlotSymbol *djSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	djSymbol.fill = [CPTFill fillWithColor:scatterTimeTempPlotcolor];
	djSymbol.lineStyle = djSymbolLineStyle;
	djSymbol.size = CGSizeMake(6.0f, 6.0f);
	self.scatterTimeTempPlot.plotSymbol = djSymbol;
    
    graph.paddingLeft = 10.0;
    graph.paddingTop = 10.0;
    graph.paddingRight = 0.0;
    graph.paddingBottom = 10.0;
    //self.scatterTimeTempPlot.plotSymbolMarginForHitDetection = aaplSymbol.size.height;
}
-(void)configureAxes {
	// 1 - Create styles
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
//	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 7.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 0.8f;
//	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
//	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold";
	axisTextStyle.fontSize = 7.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
//	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 1.0f;
//	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
//	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 0.8f;

    // 2 - Get axis set
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
	// 3 - Configure x-axis
	CPTAxis *x = axisSet.xAxis;
    
	x.title = @"Time (seconds)";
	x.titleTextStyle = axisTitleStyle;
	x.titleOffset = 15.0f;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	x.labelTextStyle = axisTextStyle;
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 1.0f;
	x.tickDirection = CPTSignNone;
	
    CGFloat dateCount = [self.detailItem.data.eventdata count];
	NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
	NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
	NSInteger i = 0;
	
    for (DJTempTimerData *data in self.detailItem.data.eventdata) {
		CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:data.secondsIntoRoast  textStyle:x.labelTextStyle];
		CGFloat location = i++;
		label.tickLocation = CPTDecimalFromCGFloat(location);
		label.offset = x.majorTickLength;
		if (label) {
			[xLabels addObject:label];
			[xLocations addObject:[NSNumber numberWithFloat:location]];
		}
    }
    

	x.axisLabels = xLabels;
	x.majorTickLocations = xLocations;

	// 4 - Configure y-axis
	CPTAxis *y = axisSet.yAxis;
    
	y.title = @"Temperature";
	y.titleTextStyle = axisTitleStyle;
	y.titleOffset = -40.0f;
	y.axisLineStyle = axisLineStyle;
//	y.majorGridLineStyle = gridLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.labelTextStyle = axisTextStyle;
	y.labelOffset = 20.0f;
	y.majorTickLineStyle = axisLineStyle;
	y.majorTickLength = 1.0f;
	y.minorTickLength = 1.0f;
	y.tickDirection = CPTSignPositive;
    
	NSInteger majorIncrement = 100;
	NSInteger minorIncrement = 50;
    CGFloat yMax = 600.0;//[_detailItem.data.eventdata count];  // should determine dynamically based on max temp
	NSMutableSet *yLabels = [NSMutableSet set];
	NSMutableSet *yMajorLocations = [NSMutableSet set];
	NSMutableSet *yMinorLocations = [NSMutableSet set];
    
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;

	/*for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
		NSUInteger mod = j % majorIncrement;
		if (mod == 0) {
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
			NSDecimal location = CPTDecimalFromInteger(j);
			label.tickLocation = location;
			label.offset = - y.majorTickLength - y.labelOffset;
			if (label) {
				[yLabels addObject:label];
			}
			[yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
		} else {
			[yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
		}
	}*/
    
//    y.visibleRange   = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(17.0)
//                                                  length:CPTDecimalFromInteger(600)];
    /*y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(2)
                                                        length:CPTDecimalFromInteger(3)];*/

	y.axisLabels = yLabels;
	//y.majorTickLocations = yMajorLocations;
	//y.minorTickLocations = yMinorLocations;

/*        axisSet.yAxis.axisConstraints =[CPTConstraints constraintWithLowerOffset:0.0];
        axisSet.xAxis.axisConstraints =[CPTConstraints constraintWithLowerOffset:0.0];*/
}



#pragma mark - View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_temptimeTable reloadData];
    NSLog(@"You are inside the Detail View");
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
/*    // pickerview options
    self.toggle = 0;
    self.pickerView = [[UIPickerView alloc] initWithFrame:(CGRect){{0, 0}, 320, 480}];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.center = (CGPoint){160, 640};
    self.pickerView.hidden = YES;
    [self.view addSubview:self.pickerView];
 */
    self.temptimeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    
    self.title = _detailItem.data.title;
    [self.titleButton setTitle:_detailItem.data.title forState:UIControlStateNormal];
    
    //Button Graphics editing...
    self.startButton.layer.borderWidth = 1.5f;
    self.startButton.layer.cornerRadius = 40;
    self.recordButton.layer.borderWidth = 1.5f;
    self.recordButton.layer.cornerRadius = 40;
    
    if(!self.detailItem.data.running){
        self.startButton.backgroundColor = [UIColor whiteColor];
        self.recordButton.backgroundColor = [UIColor whiteColor];
        self.startButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0].CGColor;
            [self.startButton setTitleColor:[UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateNormal];
        
            self.recordButton.layer.borderColor = [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0].CGColor;
            [self.recordButton setTitleColor:[UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else{
        self.startButton.backgroundColor = [UIColor clearColor];
        self.recordButton.backgroundColor = [UIColor clearColor];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.startButton.layer.borderColor = [UIColor redColor].CGColor;

        // flat red/pomegranate color #c0392b
        [self.startButton setTitleColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0] forState:UIControlStateNormal];

    }
            self.recordButton.backgroundColor = [UIColor clearColor];
        self.minusTempButton.layer.borderWidth = 0.0f;
            self.minusTempButton.layer.borderColor = [UIColor clearColor].CGColor;
//            self.minusTempButton.layer.cornerRadius = 5;
            self.plusTempButton.layer.borderWidth = 0.0f;
            self.plusTempButton.layer.borderColor = [UIColor clearColor].CGColor;
    
    if(self.detailItem.data.running)
    {
            NSLog(@"View did load and starting timer");
        
            [self startTimer];
            [self startlapTimer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [_temptimeTable reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"exited DJDetailView...");
//    [self stopTimer];
//    [self stoplapTimer];
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

#pragma mark - Button Tapping...
- (IBAction)startButtonTapped:(id)sender {
    if(self.detailItem.data.running == false)
    {
        NSLog(@"You have tapped the start button");
        if(_detailItem.data.duration != nil)
        {
            _detailItem.data.startTime = [[NSDate date] timeIntervalSinceDate:_detailItem.data.duration];
            _detailItem.data.lapstartTime =[[NSDate date] timeIntervalSinceDate:_detailItem.data.duration];
        }else{_detailItem.data.startTime = [[NSDate date] timeIntervalSinceReferenceDate];
        }
        [UIView setAnimationsEnabled:NO];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
         _detailItem.data.resetCheck = false;
        [UIView setAnimationsEnabled:YES];
        [self startTimer];
        
        self.startButton.layer.borderColor = [UIColor redColor].CGColor;
        self.recordButton.backgroundColor = [UIColor whiteColor];
        self.recordButton.titleLabel.text = @"Record";
 
        // flat red/pomegranate color #c0392b
        [self.startButton setTitleColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0] forState:UIControlStateNormal];
        //self.startButton.backgroundColor = [UIColor clearColor];
    }
    
    else{
        [self stopTimer];
        [self stoplapTimer];
        if(_detailItem.data.resetCheck == true){
            self.recordButton.titleLabel.text = @" Reset";
        }
        //self.startButton.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:214.0/255.0 blue:107.0/255.0 alpha:1];
        self.startButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0].CGColor;
        self.startButton.backgroundColor = [UIColor whiteColor];
        // flat green/emerald color #2ecc71
        [self.startButton setTitleColor:[UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.detailItem.data.running = false;

        [UIView setAnimationsEnabled:NO];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [UIView setAnimationsEnabled:YES];
    }
}
- (IBAction)recordButtonTapped:(id)sender {
    
    if (!_detailItem.data.eventdata) {
        _detailItem.data.eventdata = [[NSMutableArray alloc] init];
    }
    NSLog(@"You have tapped the record button");
    
        NSMutableString *timePass = [[NSMutableString alloc] init];
        [timePass appendString:self.clockLabel.text];
        [timePass appendString:@", "];
        [timePass appendString:self.celsiusLabel.text];
        [timePass appendString:@"\n"];

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
                _detailItem.data.elapsedTime = 0;
                _detailItem.data.duration = nil;
                _detailItem.data.timePassed = nil;
                
                [_detailItem.data.eventdata removeAllObjects];
                [_scatterTimeTempPlot reloadData];
                                [_temptimeTable reloadData];
                self.clockLabel.text = @"00:00.00";
                self.recordButton.backgroundColor = [UIColor clearColor];
            }
        }
        if(_detailItem.data.resetCheck == false){
            NSString* myNewString = [NSString stringWithFormat:@"%@", self.clockLabel.text];
            
            if(self.detailItem.data.eventdata)
            {
                DJTempTimerData *tempTimerData = [[DJTempTimerData alloc] initWithLog:[NSString stringWithFormat:@""] secondsIntoRoast:myNewString djDuration:self.detailItem.data.elapsedTime temperature:self.celsiusLabel.text];
                [_detailItem.data.eventdata addObject:tempTimerData];
            }
            
            //add data to the tableview
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_detailItem.data.eventdata.count-1 inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.temptimeTable insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
            [[self temptimeTable] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    _plotSpaceTimeTemp.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0)                   length:CPTDecimalFromCGFloat(600)];
    _plotSpaceTimeTemp.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0)                   length:CPTDecimalFromCGFloat(_detailItem.data.elapsedTime)];
    [_scatterTimeTempPlot reloadData];
}
#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return [_detailItem.data.eventdata count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	NSInteger valueCount = [_detailItem.data.eventdata count];
	switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (index < valueCount) {
//				return [NSNumber numberWithUnsignedInteger:index];
                DJTempTimerData *xobject = [_detailItem.data.eventdata objectAtIndex:index];
                NSNumberFormatter * f1 = [[NSNumberFormatter alloc] init];
                [f1 setNumberStyle:NSNumberFormatterDecimalStyle];
                
                return [NSNumber numberWithDouble:xobject.djDuration];
			}
			break;
			
		case CPTScatterPlotFieldY:
			if ([plot.identifier isEqual:@"TimerPlotz"] == YES) {
                DJTempTimerData *yobject = [_detailItem.data.eventdata objectAtIndex:index];
                NSNumberFormatter * f2 = [[NSNumberFormatter alloc] init];
                [f2 setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber * myNumber2 = [f2 numberFromString:yobject.temperature];
				return myNumber2;
			}
			break;
	}
	return [NSDecimalNumber zero];
}
-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSLog(@"plotSymbolWasSelectedAtRecordIndex %d", index);
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
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    _detailItem.data.duration = [NSDate dateWithTimeIntervalSinceReferenceDate:_detailItem.data.elapsedTime];

    _clockLabel.text =[dateFormatter stringFromDate:_detailItem.data.duration];
    _detailItem.data.timePassed = _clockLabel.text;
//    self.hostView.hostedGraph.plotAreaFrame.plotArea
    [_detailItem saveData];
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
    //NSLog(@"result: %@", [dateFormatter stringFromDate:self.lapduration]);
    _lapClockLabel.text =[dateFormatter stringFromDate:_detailItem.data.lapduration];
    _detailItem.data.laptimePassed = _lapClockLabel.text;
    NSLog(@"%@",_detailItem.data.laptimePassed);
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

        [picker setSubject:[NSString stringWithFormat:@"New Roasting Log: %@", self.detailItem.data.title]];
        
        // Set up recipients
        
        [picker setToRecipients:[NSArray array]];
        
        // Fill out the email body text
        
        NSMutableString *emailBody = [[NSMutableString alloc] init];
        [emailBody appendString:@"<table border='1' style='border-collapse:collapse;'><th style='padding:5px;'>time</th><th style='padding:5px;'>log</th><th style='padding:5px;'>temperature°C</th>"];
        for(int i=0; i < [self.detailItem.data.eventdata count];++i)
        {
            DJTempTimerData *thing = self.detailItem.data.eventdata[i];
            [emailBody appendString:@"<tr><td style='padding:5px;'>"];
            [emailBody appendString:thing.secondsIntoRoast];
            [emailBody appendString:@"</td><td style='padding:5px;'>"];
            [emailBody appendString:thing.log];
            [emailBody appendString:@"</td><td style='padding:5px;'>"];
            [emailBody appendString:thing.temperature];
            [emailBody appendString:@"</td></tr>"];
        };
            [emailBody appendString:@"</table>"];
        
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
        
        [picker setSubject:[NSString stringWithFormat:@"New Timer Log Attached: %@.txt", self.detailItem.data.title]];
        
        // Set up recipients
        
        [picker setToRecipients:[NSArray array]];
        

        // Body of email
        NSMutableString *emailBody = [[NSMutableString alloc] init];
        [picker setMessageBody:emailBody isHTML:NO];
        
        for(int i=0; i < [self.detailItem.data.eventdata count];++i)
        {
            DJTempTimerData *thing = self.detailItem.data.eventdata[i];
            [emailBody appendString:thing.secondsIntoRoast];
            [emailBody appendString:@","];
            [emailBody appendString:thing.log];
            [emailBody appendString:@","];
            [emailBody appendString:thing.temperature];
            [emailBody appendString:@", \n"];
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
        [picker addAttachmentData:[emailBody dataUsingEncoding:NSStringEncodingConversionAllowLossy] mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.txt", emailBody]];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        // tell user that we can't send email
        NSLog(@"Can't Send mail");
    }
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)onSlide:(UISlider*)sender {
    float faren = (9/5)*self.tempSlider.value + 32;
    NSString* celsiusString = [NSString stringWithFormat:@"%d", (int)self.tempSlider.value];
    NSString* farenheitString = [NSString stringWithFormat:@"%d", (int)faren];
    self.celsiusLabel.text = celsiusString;
    self.farenheitLabel.text = farenheitString;
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
- (IBAction)touchDecbegan:(id)sender {
    self.timer4Temp = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(decrementTemp:) userInfo:nil repeats:YES];
}
-(IBAction)touchesDecEnded:(id)sender{
    if (self.timer4Temp != nil)
        [self.timer4Temp invalidate];
    self.timer4Temp = nil;
}

- (IBAction)touchIncbegan:(id)sender {
    
    self.timer4Temp = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(incrementTemp:) userInfo:nil repeats:YES];
}
-(IBAction)touchesIncEnded:(id)sender{

    if (self.timer4Temp != nil)
        [self.timer4Temp invalidate];
    self.timer4Temp = nil;
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
    [_temptimeTable reloadData];
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
@end
