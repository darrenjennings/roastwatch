//
//  DJTableViewCell.m
//  RoastMaster
//
//  Created by Darren Jennings on 1/28/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJTableViewCell.h"

@implementation DJTableViewCell

- (void)viewDidLoad
{
    [self.commentLabel setDelegate:self];
    [self.commentLabel setReturnKeyType:UIReturnKeyDone];
    [self.commentLabel addTarget:self
                          action:@selector(textFieldShouldReturn:)
                forControlEvents:UIControlEventEditingDidEndOnExit];

    [self configureView];
}

- (void)configureView
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
