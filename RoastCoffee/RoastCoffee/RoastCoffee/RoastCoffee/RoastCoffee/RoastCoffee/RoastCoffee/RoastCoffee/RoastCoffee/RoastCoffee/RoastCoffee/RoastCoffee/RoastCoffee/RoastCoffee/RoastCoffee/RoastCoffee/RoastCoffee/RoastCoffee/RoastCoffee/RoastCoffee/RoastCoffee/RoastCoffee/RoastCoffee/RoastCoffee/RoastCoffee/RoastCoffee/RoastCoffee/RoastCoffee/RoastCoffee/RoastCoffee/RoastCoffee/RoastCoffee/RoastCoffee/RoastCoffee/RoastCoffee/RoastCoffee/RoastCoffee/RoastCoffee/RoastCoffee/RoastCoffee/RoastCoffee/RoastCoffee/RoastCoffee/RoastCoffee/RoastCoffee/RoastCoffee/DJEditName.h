//
//  DJEditName.h
//  RoastCoffee
//
//  Created by Darren Jennings on 2/7/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerLogDoc.h"
#import "TimerLogData.h"

@interface DJEditName : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) TimerLogDoc * detailItem;
@property (weak, nonatomic) IBOutlet UITextField *roastName;

@end
