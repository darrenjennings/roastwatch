//
//  DJMasterViewController.h
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSettings.h"
#import "DJSettingsViewController.h"
#import "RMEIdeasPullDownControl.h"

@class DJDetailViewController;

@interface DJMasterViewController : UITableViewController<RMEIdeasPullDownControlDataSource, RMEIdeasPullDownControlProtocol>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) DJDetailViewController *detailViewController;
@property (strong, nonatomic) DJSettingsDoc *theSettings;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSArray *sortTitlesArray;
@property (strong, nonatomic) RMEIdeasPullDownControl *rmeideasPullDownControl;

@property BOOL searching;

@end
