//
//  DJCustomEvents.m
//  Roast Coffee
//
//  Created by Darren Jennings on 3/10/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJCustomEvents.h"

@implementation DJCustomEvents

- (void)setDetailItem:(DJSettingsDoc*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        NSLog(@"You just declared a new detail item.");
        // Update the view.
        [self configureView];
    }
}

- (void)viewDidLoad
{
    
    self.title = @"Events";
    //custom navigation label settings
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.title;
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"Avenir Next Medium"size:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
//    UIImage* image3 = [UIImage imageNamed:@"page7.png"];
    UIImage* image4 = [UIImage imageNamed:@"page7Inverted.png"];
//    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(addTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setBackgroundImage:image4 forState:UIControlStateHighlighted];
    
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem=addButton;
    [self.tableView reloadData];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Headerview
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 20.0)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height*.1)];
    bool editng = self.tableView.editing;
    if(!editng){
        [button setTitle:@"Tap to edit" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0]]; //green
//        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0]];
    }else{
        [button setTitle:@"Commit edits!" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0]];
  //      [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0]];
    }
    button.titleLabel.font = [UIFont fontWithName:@"Avenir Next" size:16.0];
    button.tag = section;
    button.hidden = NO;
    button.titleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:button];
    return myView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return (screenRect.size.height*.1);
}
- (void)buttonPressed:(UIButton*)sender
{
    if([sender.titleLabel.text isEqual:@"Tap to edit"]){
        NSLog(@"Button pressed...");
        [sender setTitle:@"Commit edits!" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //red
        [sender setBackgroundColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0]];
        [self.tableView setEditing:true animated:true];
       // [[UITabBar appearance] setTintColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0]];
    }else{
        [_detailItem saveData];
        [sender setBackgroundColor:[UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0]];
       // [[UITabBar appearance] setTintColor:[UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0]];
        [sender setTitle:@"Tap to edit" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.tableView setEditing:FALSE animated:true];
    }
    
}

- (void) configureView{
    if (self.detailItem) {
        self.eventsCustom = self.detailItem.settings.eventsCustom;
    }
    
    _editTextAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Event Name:"
                                                    message:@"Please select the name of this custom event."
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    _editTextAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_detailItem.settings.eventsCustom count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)addTapped:(id)sender
{
    if (!_eventsCustom) {
        _eventsCustom = [[NSMutableArray alloc] init];
    }
    
    NSString* titleTemplate = @"Custom Event Name Here";
    
    [_eventsCustom addObject:titleTemplate];
    _detailItem.settings.eventsCustom = _eventsCustom;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_eventsCustom.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
    [_detailItem saveData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomEventCell"];
        NSString *event = [_detailItem.settings.eventsCustom objectAtIndex:indexPath.row];
        cell.textLabel.text = event;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Event %ld",(long)([indexPath row]+1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing == true){
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _editTextAlertView.tag = [indexPath row];
        [_editTextAlertView textFieldAtIndex:0].text = _eventsCustom[[indexPath row]];
        [_editTextAlertView show];
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
        NSObject *tempObj = [_eventsCustom objectAtIndex:fromIndexPath.row];
        [_eventsCustom removeObjectAtIndex:fromIndexPath.row];
        [_eventsCustom insertObject:tempObj atIndex:toIndexPath.row];
    [self.tableView reloadData];
    [_detailItem saveData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_eventsCustom removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [_detailItem saveData];
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    _detailItem.settings.eventsCustom[_editTextAlertView.tag] = [alertView textFieldAtIndex:0].text;
    
    [self.tableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Done editing event!");
    }
}

@end
