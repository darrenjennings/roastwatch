//
//  DJGraphView.h
//  RoastWatch
//
//  Created by Darren Jennings on 6/21/15.
//  Copyright (c) 2015 Darren Jennings. All rights reserved.
//
#import "TimerLogDoc.h"
#import "TimerLogData.h"
#import "CorePlot-CocoaTouch.h"

@interface DJGraphView : UIView <CPTPlotDataSource, CPTPlotDelegate, CPTScatterPlotDelegate>

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTXYPlotSpace *plotSpaceTimeTemp;
@property (retain) CPTScatterPlot *scatterTimeTempPlot;

@property (strong, nonatomic) TimerLogDoc* detailItem;

@end