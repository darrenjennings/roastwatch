//
//  DJMasterViewController.h
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJDetailViewController;

@interface DJMasterViewController : UITableViewController

@property (strong, nonatomic) DJDetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *events;

@end
