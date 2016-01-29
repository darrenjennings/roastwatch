//
//  DJDatabaseSettingsViewTableViewController.m
//  RoastWatch
//
//  Created by Darren Jennings on 8/31/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJDatabaseSettingsTableViewController.h"

@interface DJDatabaseSettingsTableViewController ()

@end

@implementation DJDatabaseSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    [super viewDidLoad];
    self.title = @"Data";
    //custom navigation label settings
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.title;
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"Avenir Next Medium"size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView reloadData];
    self.dropBoxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.dropBoxClient.delegate = self;
}

- (void)configureView
{
    if (self.detailItem) {
        self.eventsCustom = self.detailItem.settings.eventsCustom;
    }
    _emailAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Email Address"
                                                    message:@"Please enter the default email for exporting your roasts."
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    _emailAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    _dropboxLinkAlertView = [[UIAlertView alloc] initWithTitle:@"Unlink?"
                                                 message:@"Are you sure you want to disconnect the dropbox account associated with RoastWatch?"
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Unlink", nil];
    _dropboxLinkAlertView.alertViewStyle = UIAlertViewStyleDefault;
    
    [self.tableView reloadData];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if([indexPath row] == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox" forIndexPath:indexPath];
        cell.textLabel.text = @"Dropbox";
        cell.imageView.image = [UIImage imageNamed:@"dropboxicon.png"];
        if ([[DBSession sharedSession] isLinked]) {
 //           [_dropBoxClient loadAccountInfo];
//            NSLog(@"%@", [info displayName]);
            cell.detailTextLabel.text = @"LINKED";
            
        }else{
            cell.detailTextLabel.text = @"UNLINKED";
        }
        

        //add line separator for temp cell.
        UIView *lineView;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
        [cell.contentView setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height-0.5)];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
        
        return cell;
    }
    if([indexPath row] == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmailExport" forIndexPath:indexPath];
        cell.textLabel.text = @"Email Export Address";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _detailItem.settings.exportEmailaddress];
        cell.imageView.image = [UIImage imageNamed:@"envelopeicon.png"];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0){
        NSLog(@"row 0");
        if (![[DBSession sharedSession] isLinked]) {
            [[DBSession sharedSession] linkFromController:self];
            
        }else{
            [_dropboxLinkAlertView show];
        }
    }
    
    if([indexPath row] == 1){
        NSLog(@"row 1");
        [_emailAlertView textFieldAtIndex:0].text = _detailItem.settings.exportEmailaddress;
        [_emailAlertView show];
        NSLog(@"%ld", (long)[indexPath row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == self.emailAlertView){
        _detailItem.settings.exportEmailaddress = [alertView textFieldAtIndex:0].text;
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView == self.dropboxLinkAlertView){
        if (buttonIndex == 1) {
            [[DBSession sharedSession] unlinkAll];
            NSLog(@"Done unlinking event!");
            [_detailItem saveData];
            [self.tableView reloadData];
        }
    }
    if(alertView == self.emailAlertView){
        if (buttonIndex == 0) {
            NSLog(@"Done editing event!");
            [_detailItem saveData];
        }
    }
}
@end
