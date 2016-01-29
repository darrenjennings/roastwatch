//
//  DJCustomEvents.h
//  Roast Coffee
//
//  Created by Darren Jennings on 3/10/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSettingsDoc.h"

@interface DJCustomEvents : UITableViewController<UIAlertViewDelegate>

@property (strong, nonatomic) DJSettingsDoc * detailItem;
@property (strong, nonatomic) NSMutableArray *eventsCustom;

@property (strong, nonatomic) UIAlertView *editTextAlertView;
@end
