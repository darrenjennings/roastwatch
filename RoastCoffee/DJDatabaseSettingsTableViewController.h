//
//  DJDatabaseSettingsViewTableViewController.h
//  RoastWatch
//
//  Created by Darren Jennings on 8/31/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSettingsDoc.h"
#import <DropboxSDK/DropboxSDK.h>

@interface DJDatabaseSettingsTableViewController : UITableViewController<DBRestClientDelegate>

@property (strong, nonatomic) DJSettingsDoc * detailItem;
@property (strong, nonatomic) NSMutableArray *eventsCustom;
@property (strong, nonatomic) UIAlertView *emailAlertView;
@property (strong, nonatomic) UIAlertView *dropboxLinkAlertView;
@property (nonatomic, strong) DBRestClient *dropBoxClient;

@end
