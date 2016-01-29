//
//  DJGraphView.m
//  RoastWatch
//
//  Created by Darren Jennings on 6/21/15.
//  Copyright (c) 2015 Darren Jennings. All rights reserved.
//

#import "DJGraphView.h"

@implementation DJGraphView

- (void)setDetailItem:(TimerLogDoc*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self initPlot];
        NSLog(@"You just declared a new detail item.");
    }
}

- (void)viewDidLoad
{
    [self initPlot];
}

-(void)initPlot {
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureGraph {
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    // 1 - Create the graph
    CGRect rect = CGRectMake(self.hostView.bounds.origin.x, self.hostView.bounds.origin.y,
                             self.hostView.bounds.size.width, (0.5*iOSDeviceScreenSize.height));
    
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:rect];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    
    graph.title = @"";
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottom;
    graph.titleDisplacement = CGPointMake(10.0f, 0.0f);
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:10.0f];
    [graph.plotAreaFrame setPaddingBottom:0.0f];
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    graph.newPlotSpace.graph.hostingView = self.hostView;
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    
}

-(void)configurePlots {
    
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    _plotSpaceTimeTemp = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    // 2 - Create the plots
    self.scatterTimeTempPlot = [[CPTScatterPlot alloc] init];
    self.scatterTimeTempPlot.dataSource = self;
    self.scatterTimeTempPlot.identifier = @"TimerPlotz";
    self.scatterTimeTempPlot.borderColor = [UIColor whiteColor].CGColor;
    
    CPTColor *scatterTimeTempPlotcolor = (CPTColor*)[UIColor colorWithRed:52/255.0 green:73/255.0 blue:94/255.0 alpha:1.0];
    //    rgb(52, 73, 94)
    // Brown color
    //    CPTColor *scatterTimeTempPlotcolor = [CPTColor colorWithComponentRed:130.0/255.0f green:90.0f/255.0f blue:44.0f/255.0f alpha:1.0f]
    ;
    [graph addPlot:self.scatterTimeTempPlot toPlotSpace:_plotSpaceTimeTemp];
    
    // 3 - Set up plot space
    
    [_plotSpaceTimeTemp scaleToFitPlots:[NSArray arrayWithObjects:self.scatterTimeTempPlot, nil]];
    
    CPTMutablePlotRange *xRange = [_plotSpaceTimeTemp.xRange mutableCopy];
    //[xRange expandRangeByFactor:CPTDecimalFromCGFloat(2.5f)];
    _plotSpaceTimeTemp.xRange = xRange;
    CPTMutablePlotRange *yRange = [_plotSpaceTimeTemp.yRange mutableCopy];
    //[yRange expandRangeByFactor:CPTDecimalFromCGFloat(2.5f)];
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
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.fontName = @"Helvetica Neue";
    axisTitleStyle.fontSize = 7.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 0.8f;
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.fontName = @"Helvetica Neue";
    axisTextStyle.fontSize = 7.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
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
//        label.tickLocation = CPTDecimalFromCGFloat(location);
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
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 20.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 1.0f;
    y.minorTickLength = 1.0f;
    y.tickDirection = CPTSignPositive;
    
    NSMutableSet *yLabels = [NSMutableSet set];
    
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.axisLabels = yLabels;
    
}


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
    NSLog(@"plotSymbolWasSelectedAtRecordIndex %lu", (unsigned long)index);
}


@end
