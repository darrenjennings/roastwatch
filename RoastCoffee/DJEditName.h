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

@interface DJEditName : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) TimerLogDoc * detailItem;
@property (weak, nonatomic) IBOutlet UITextField *roastName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController * picker;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (retain) UIActionSheet *actionSheet;

- (IBAction)addPictureTapped:(id)sender;

@end
