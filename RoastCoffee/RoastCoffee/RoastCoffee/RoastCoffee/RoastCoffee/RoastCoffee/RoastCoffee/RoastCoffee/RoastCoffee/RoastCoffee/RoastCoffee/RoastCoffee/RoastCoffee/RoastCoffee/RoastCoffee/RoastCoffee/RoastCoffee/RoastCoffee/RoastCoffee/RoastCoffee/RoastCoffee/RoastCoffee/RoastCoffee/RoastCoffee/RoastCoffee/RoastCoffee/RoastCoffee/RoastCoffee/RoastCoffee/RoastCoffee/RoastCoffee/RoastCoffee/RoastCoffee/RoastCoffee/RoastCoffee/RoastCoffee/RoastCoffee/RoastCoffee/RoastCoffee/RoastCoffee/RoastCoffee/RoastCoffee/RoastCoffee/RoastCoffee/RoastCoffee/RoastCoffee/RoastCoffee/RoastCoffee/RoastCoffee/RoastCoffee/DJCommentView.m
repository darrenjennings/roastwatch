//
//  DJCommentView.m
//  RoastMaster
//
//  Created by Darren Jennings on 1/25/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJCommentView.h"

@implementation DJCommentView

- (void)setDetailItem:(id)newDetailItem
{
    if (_detaildoc != newDetailItem) {
        _detaildoc = newDetailItem;
        
        // Update the view.
        [self configureView];
        NSLog(@"You just declared a new detail item.");
        NSLog(@"The comment box text is '%@'", _detaildoc.log);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.commentText becomeFirstResponder];
}
- (void)configureView
{
//    self.commentText.text = self.commentText.text;
//    self.navigationItem.title = @"Rename";
    [self.commentText setDelegate:self];
    [self.commentText setReturnKeyType:UIReturnKeyDone];
    [self.commentText addTarget:self
                       action:@selector(textFieldShouldReturn:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    self.commentText.text = self.detaildoc.log;
    self.navigationItem.title = @"Rename";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.commentText.text = _detaildoc.log;
    [_logDoc saveData];
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
- (IBAction)editingChanged:(id)sender {
    _detaildoc.log = self.commentText.text;
    
    [_logDoc saveData];
}

@end
