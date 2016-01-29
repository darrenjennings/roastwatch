//
//  DJCommentView.m
//  RoastMaster
//
//  Created by Darren Jennings on 1/25/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJCommentView.h"

@implementation DJCommentView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    [_EventTableView reloadData];
    _EventTableView.dataSource=self;
    _EventTableView.delegate=self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.commentText becomeFirstResponder];
}
- (void)configureView
{
    
//    self.commentText.text = self.commentText.text;

    [self.commentText setDelegate:self];
    [self.commentText setReturnKeyType:UIReturnKeyDone];
    [self.commentText addTarget:self
                       action:@selector(textFieldShouldReturn:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.roastTemp setDelegate:self];
    [self.roastTemp setReturnKeyType:UIReturnKeyDone];
    [self.roastTemp addTarget:self
                         action:@selector(textFieldShouldReturn:)
               forControlEvents:UIControlEventEditingDidEndOnExit];

    
    self.commentText.text = self.detaildoc.log;
    self.roastTemp.text = self.detaildoc.temperature;
    self.settings = _logDoc.settings;
    self.navigationItem.title = @"Edit Event";
    //[self createScrollMenu];
    self.TableViewContainer.layer.shadowOffset = CGSizeMake(-1, -1);
    self.TableViewContainer.layer.shadowOpacity = 0.5;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.commentText.text = _detaildoc.log;
    self.roastTemp.text = _detaildoc.temperature;
    [_logDoc saveData];
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
- (IBAction)editingChanged:(id)sender {
    _detaildoc.log = self.commentText.text;
    _detaildoc.temperature = self.roastTemp.text;
    
    [_logDoc saveData];
}

/*- (void)createScrollMenu
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.myEventSlider.frame.size.width, 50)];
    
    int x = 10;
    for (int i = 0; i < _settings.eventsCustom.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 150, 40)];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        [[button layer] setBorderColor:[UIColor clearColor].CGColor];
        button.layer.cornerRadius = 10;
        // flat red/pomegranate color #c0392b
        button.backgroundColor = [UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0];

        [button setTitle:[NSString stringWithFormat:@"%@", _settings.eventsCustom[i]] forState:UIControlStateNormal];
 
        if(i==1){
            [button setTitle:[NSString stringWithFormat:@"First Crack End"] forState:UIControlStateNormal];
        }
        if(i==2){
            [button setTitle:[NSString stringWithFormat:@"Second Crack Begin"] forState:UIControlStateNormal];
        }
        if(i==3){
            [button setTitle:[NSString stringWithFormat:@"Second Crack End"] forState:UIControlStateNormal];
        }
        [scrollView addSubview:button];
        x += button.frame.size.width + 10;
        [button addTarget:self
                       action:@selector(methodTouchDown:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self.myEventSlider addSubview:scrollView];
    
}*/
-(void)methodTouchDown:(UIButton*)sender{
    _commentText.text = sender.titleLabel.text;
    _detaildoc.log = self.commentText.text;
}

#pragma tableview methods
#pragma mark - tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.eventsCustom.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Eventz"];    NSString *event = _settings.eventsCustom[indexPath.row];
    
    cell.textLabel.text = event;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%ld",(long)[indexPath row]+1];
    
    /*    UIView *bgColorView = [[UIView alloc] init];
     bgColorView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1];
     cell.backgroundColor = bgColorView.backgroundColor;*/

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _commentText.text = _settings.eventsCustom[indexPath.row];
    _detaildoc.log = self.commentText.text;
    [_EventTableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
