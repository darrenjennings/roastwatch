//
//  DJEditName.m
//  RoastCoffee
//
//  Created by Darren Jennings on 2/7/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJEditName.h"

@implementation DJEditName

- (void)setDetailItem:(TimerLogDoc*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        NSLog(@"You just declared a new detail item.");
        // Update the view.
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.roastName becomeFirstResponder];
}

- (void)configureView
{
    //    self.commentText.text = self.commentText.text;
    //    self.navigationItem.title = @"Rename";
    [self.roastName setDelegate:self];
    [self.roastName setReturnKeyType:UIReturnKeyDone];
    [self.roastName addTarget:self
                         action:@selector(textFieldShouldReturn:)
               forControlEvents:UIControlEventEditingDidEndOnExit];
    self.roastName.text = self.detailItem.data.title;
    self.navigationItem.title = @"Rename";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.roastName.text = self.detailItem.data.title;
    [_detailItem saveData];
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
- (IBAction)editingChanged:(id)sender {
    _detailItem.data.title = self.roastName.text;
    [_detailItem saveData];
}
@end
