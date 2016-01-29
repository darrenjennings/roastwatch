//
//  DJSettingsCell.h
//  Roast Coffee
//
//  Created by Darren Jennings on 2/14/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJSettingsCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UISwitch *tempSwitch;

@end
