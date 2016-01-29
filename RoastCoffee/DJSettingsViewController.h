//
//  DJSettingsViewController.h
//  Roast Coffee
//
//  Created by Darren Jennings on 2/10/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSettingsDoc.h"
#import "DJSettingsCell.h"
#import "DJCustomEvents.h"

@class DJCustomEvents;

@interface DJSettingsViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) DJSettingsCell* settingsCell;
@property (strong, nonatomic) DJSettingsDoc *tehSettings;


@end
