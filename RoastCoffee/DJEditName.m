//
//  DJEditName.m
//  RoastCoffee
//
//  Created by Darren Jennings on 2/7/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJEditName.h"
#import "SVProgressHUD.h"
#import "UIImageExtras.h"

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
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = NO;
    self.imageView.image = self.detailItem.fullImage;
    self.navigationItem.title = @"Rename";

/*    CGRect firstFrame = self.view.bounds;
    CGRect bigFrame = firstFrame;
    bigFrame.size.height *= 4.0;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:firstFrame];
    scrollView.delegate = self;
    [scrollView addSubview:_imageView];
    [scrollView setContentSize:bigFrame.size];*/
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

- (IBAction)addPictureTapped:(id)sender {
    if (self.picker == nil) {
        
        // 1) Show status
        [SVProgressHUD showWithStatus:@"Loading picker..."];
        
        // 2) Get a concurrent queue form the system
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // 3) Load picker in background
        dispatch_async(concurrentQueue, ^{
            
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.allowsEditing = NO;
            
            // 4) Present picker in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController presentViewController:_picker animated:YES completion:nil];
                [SVProgressHUD dismiss];
            });
            
        });
        
    }  else {
        [self.navigationController presentViewController:_picker animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    // 1) Show status
    [SVProgressHUD showWithStatus:@"Resizing image..."];
    
    // 2) Get a concurrent queue form the system
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 3) Resize image in background
    dispatch_async(concurrentQueue, ^{
        UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        
        // 4) Present image in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailItem.fullImage = fullImage;
            self.detailItem.thumbImage = thumbImage;
            self.imageView.image = fullImage;
            [_detailItem saveImages];
            [SVProgressHUD dismiss];
        });        
    });
    
}

@end
