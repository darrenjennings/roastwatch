//
//  DJMasterViewController.m
//  RoastMaster
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//

#import "DJMasterViewController.h"
#import "DJDetailViewController.h"
#import "TimerLogDoc.h"
#import "TimerLogData.h"

@interface DJMasterViewController () {
}
@end

@implementation DJMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{

	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addTapped:)];
    
    self.detailViewController = (DJDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.tableView reloadData];
    self.title = @"Roasts";

    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.title;
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"Helvetica Neue"size:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    self.tableView.allowsSelectionDuringEditing = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTapped:(id)sender
{
    if (!_events) {
        _events = [[NSMutableArray alloc] init];
    }

    //Date creation for naming the event.
    NSDate *exactDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTitle = [dateFormat stringFromDate:exactDate];
    NSMutableArray* timerData = [[NSMutableArray alloc] init];
    NSString* titleTemplate = [[NSString alloc] initWithFormat:@"Roast %@", dateTitle];
    TimerLogDoc *newDoc = [[TimerLogDoc alloc] initWithTitle:titleTemplate dateCreated:exactDate thumbImage:[UIImage imageNamed:@""] startTime:0 timePassed:@"00:00:00" eventdata:timerData];
    [_events addObject:newDoc];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_events.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
//    [self performSegueWithIdentifier:@"mySegue" sender:self];
    [newDoc saveData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell"];
    
    TimerLogDoc *event = [self.events objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd, HH:mm"];
    NSString *datepreface = @"Date: ";
    NSString *dateTitle = [dateFormat stringFromDate:event.data.dateCreated];
    datepreface = [datepreface stringByAppendingString:dateTitle];
    cell.textLabel.text = event.data.title;
    cell.detailTextLabel.text = datepreface;
    cell.imageView.image = event.thumbImage;
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 /*   if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_logs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  */
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimerLogDoc *doc = [_events objectAtIndex:indexPath.row];
        [doc deleteDoc];

        [_events removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSObject *tempObj = [_events objectAtIndex:fromIndexPath.row];
    [_events removeObjectAtIndex:fromIndexPath.row];
    [_events insertObject:tempObj atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimerLogDoc *object = _events[indexPath.row];
    self.detailViewController.detailItem = object;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if(self.editing == true)
        {
            [self performSegueWithIdentifier:@"infoSegue" sender:cell];
            NSLog(@"Editing %i", self.editing);
        }
        if(self.editing == false){
            NSLog(@"Editing %i", self.editing);
           [self performSegueWithIdentifier:@"detailSegue" sender:cell];
        }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderIn:(NSInteger)section {
    
    NSString *sectionTitle = @"Just a title";
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view addSubview:label];
    
    return view;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    NSLog(@"Editing %i", editing);
    [super setEditing:editing animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TimerLogDoc *object = _events[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    
    // Once you initiate the segue, you need to
    // pass the current event object at the selected row to the detailview controller.
    DJDetailViewController *detailController =segue.destinationViewController;
    TimerLogDoc *log = [self.events objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.detailItem = log;
    }
    if([segue.identifier isEqualToString:@"infoSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TimerLogDoc *object = _events[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
