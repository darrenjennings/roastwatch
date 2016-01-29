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

typedef enum
{
    AtoZ = 0,
    ZtoA,
    OldestToNewest,
    NewestToOldest
}
TableSortSortCriteria;

@interface DJMasterViewController () {
}
@end

@implementation DJMasterViewController

NSArray *searchResults;

- (void)awakeFromNib
{
    /*(if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
     self.clearsSelectionOnViewWillAppear = NO;
     self.preferredContentSize = CGSizeMake(320.0, 600.0);
     }
     [super awakeFromNib];
     */
    
}

- (void)viewDidLoad
{
    self.tabBarController.tabBarItem.image = [UIImage imageNamed:@"document9.png"];
    //    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    //[UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0]];
    
    //custom navigation label settings
    self.title = @"Roasts";
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.title;
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"Avenir Next Medium"size:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    self.navigationController.navigationBar.translucent = false;
    _searchBar.backgroundColor = [UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0];
    [_searchBar setTranslucent:NO];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
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
    //
    
    self.detailViewController = (DJDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.tableView reloadData];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    //    self.tableView.contentInset = UIEdgeInsetsMake(-self.searchDisplayController.searchBar.frame.size.height-1, 0, 0, 0);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView.opaque = true;
    
    /*
     RME Sorting settings
    */
    //Create an array of titles to display as different functions are selected by the user.
        self.sortTitlesArray = @[@"Roast Title from A - Z", @"Roast Title from Z - A", @"Roast Date: OLDEST - NEWEST", @"Roast Date: NEWEST - OLDEST"];
    
    //Initializing RMEIdeasPullDownControl property using the designated initializer.
    self.rmeideasPullDownControl = [[RMEIdeasPullDownControl alloc] initWithDataSource:self
                                                                              delegate:self
                                                                      clientScrollView:self.tableView];
    CGRect originalFrame = self.rmeideasPullDownControl.frame;
    self.rmeideasPullDownControl.frame = CGRectMake(0, 65, originalFrame.size.width, originalFrame.size.height);
    
    //It is recommended that the control is placed behind the client scrollView. Remember to make its background transparent.
    [self.navigationController.view insertSubview:self.rmeideasPullDownControl atIndex:0];
    self.rmeideasPullDownControl.layer.zPosition = 1;
    self.searchBar.layer.zPosition = 100;
    if(searchResults.count == _events.count)
    {
        _searching = false;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.opaque = true;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTapped:(UIButton*)btn
{
    btn.alpha = 0;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    btn.alpha = 1;
    [UIView commitAnimations];
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
    TimerLogDoc *newDoc = [[TimerLogDoc alloc] initWithTitle:titleTemplate dateCreated:exactDate thumbImage:[UIImage imageNamed:@"fileicon.png"] fullImage:[UIImage imageNamed:@"fileicon@2x.png"] startTime:0 timePassed:@"00:00:00" eventdata:timerData settings:self.theSettings.settings];
    [_events addObject:newDoc];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_events.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
    //    [self performSegueWithIdentifier:@"mySegue" sender:self];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [newDoc saveData];
    [newDoc saveImages];
}
/*
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 {
 
 }
 - (void)reloadData:(BOOL)animated
 {
 [self.tableView reloadData];
 
 if (animated) {
 
 CATransition *animation = [CATransition animation];
 [animation setType:kCATransitionReveal];
 [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
 //        [animation setFillMode:kCAFillModeForwards];
 [animation setDuration:.3];
 [[self.tableView layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
 
 }
 }*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _searching = true;
        return [searchResults count];
        
    } else {
        return [self.events count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyBasicCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyBasicCell"];
    }
    
    TimerLogDoc *event;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _searching = true;
        event = [searchResults objectAtIndex:indexPath.row];
    } else {
        event = [self.events objectAtIndex:indexPath.row];
//        [tableView reloadData];
    }
    
    event.settings = [[DJSettings alloc] init];
    event.settings = self.theSettings.settings;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd, HH:mm"];
    NSString *datepreface = @"Date: ";
    NSString *dateTitle = [dateFormat stringFromDate:event.data.dateCreated];
    datepreface = [datepreface stringByAppendingString:dateTitle];
    cell.textLabel.text = event.data.title;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    cell.detailTextLabel.text = datepreface;
    cell.imageView.frame = (CGRect){{0.0f, 0.0f}, 45, 45};
    cell.imageView.layer.cornerRadius = (cell.imageView.frame.size.height / 2.0) - 1;
    cell.imageView.image = event.thumbImage;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searching == true){
        return NO;
    }else{
        // Return NO if you do not want the specified item to be editaoble.
        return YES;
    }
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
    if (_searching == true)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            TimerLogDoc *object = [[TimerLogDoc alloc] init];
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            object = searchResults[indexPath.row];
            [object deleteDoc];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            TimerLogDoc *doc = [_events objectAtIndex:indexPath.row];
            [doc deleteDoc];
            
            [_events removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
    //
    if (_searching==true) {
        TimerLogDoc *object = [[TimerLogDoc alloc] init];
        object = searchResults[indexPath.row];
        self.detailViewController.detailItem = object;
    }else{
        TimerLogDoc *object = [[TimerLogDoc alloc] init];
        object = _events[indexPath.row];
        self.detailViewController.detailItem = object;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

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
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    return view;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    NSLog(@"Editing %i", editing);
    [super setEditing:editing animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TimerLogDoc *object = [[TimerLogDoc alloc] init];
    if (_searching == true)
    {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        object = searchResults[indexPath.row];
    }else{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = _events[indexPath.row];
    }
    
    if([segue.identifier isEqualToString:@"detailSegue"])
    {
        [[segue destinationViewController] setDetailItem:object];
        
        // Once you initiate the segue, you need to
        // pass the current event object at the selected row to the detailview controller.
        DJDetailViewController *detailController =segue.destinationViewController;
        
        //TimerLogDoc *log = [searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        detailController.detailItem = object;
    }
    
    if([segue.identifier isEqualToString:@"infoSegue"])
    {
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma Search Bar methods...
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"data.title contains[c] %@", searchText];
    searchResults = [_events filteredArrayUsingPredicate:resultPredicate];
    self.searching = true;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0];
    return true;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if(searchResults.count != 0 && searchResults.count != _events.count){
        _searching = true;
    }else{
        _searching = false;
    }
    return true;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searching = false;
    searchResults = nil;
}
- (void)selectedScopeButtonIndexDidChange:(UISearchBar *)searchBar{
    NSLog(@"selectedScopeButtonIndexDidChange!!!!!!");
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma RME Pull Down Sort
#pragma mark - RMEIdeasePullDownControl DataSource and Delegate methods
- (void) rmeIdeasPullDownControl:(RMEIdeasPullDownControl*)rmeIdeasPullDownControl
          selectedControlAtIndex:(NSUInteger)controlIndex
{
    NSSortDescriptor *sortDescriptor = nil;
    NSArray *sortDescriptors = nil;
    switch (controlIndex)
    {
        case AtoZ:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"data.title" ascending:YES];
            sortDescriptors = @[sortDescriptor];
            break;
            
        case ZtoA:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"data.title" ascending:NO];
            sortDescriptors = @[sortDescriptor];
            break;
            
        case OldestToNewest:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"data.dateCreated" ascending:YES];
            sortDescriptors = @[sortDescriptor];
            break;
            
        case NewestToOldest:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"data.dateCreated" ascending:NO];
            sortDescriptors = @[sortDescriptor];
            break;
            
        default:
            break;
    }
    
    self.events = [[NSMutableArray alloc] initWithArray:[_events sortedArrayUsingDescriptors:sortDescriptors]];
    [self.tableView reloadData];
}

- (NSUInteger) numberOfButtonsRequired:(RMEIdeasPullDownControl*)rmeIdeasPullDownControl
{
    return 4;
}

- (UIImage*) rmeIdeasPullDownControl:(RMEIdeasPullDownControl*)rmeIdeasPullDownControl imageForControlAtIndex:(NSUInteger)controlIndex
{
    UIImage *image0 = [UIImage imageNamed:@"SortAZ.png"];
    UIImage *image1 = [UIImage imageNamed:@"SortZA.png"];
    UIImage *image2 = [UIImage imageNamed:@"HighLow.png"];
    UIImage *image3 = [UIImage imageNamed:@"LowHigh.png"];
    UIImage *image4 = [UIImage imageNamed:@"OldNew.png"];
    UIImage *image5 = [UIImage imageNamed:@"NewOld.png"];
    
    NSArray *imagesArray = @[image0, image1, image2, image3, image4, image5];
    return imagesArray[controlIndex];
}

- (UIImage*) rmeIdeasPullDownControl:(RMEIdeasPullDownControl*)rmeIdeasPullDownControl
      selectedImageForControlAtIndex:(NSUInteger)controlIndex
{
    UIImage *image0 = [UIImage imageNamed:@"SortAZSelected.png"];
    UIImage *image1 = [UIImage imageNamed:@"SortZASelected.png"];
    UIImage *image2 = [UIImage imageNamed:@"HighLowSelected.png"];
    UIImage *image3 = [UIImage imageNamed:@"LowHighSelected.png"];
    UIImage *image4 = [UIImage imageNamed:@"OldNewSelected.png"];
    UIImage *image5 = [UIImage imageNamed:@"NewOldSelected.png"];
    
    NSArray *imagesArray = @[image0, image1, image2, image3, image4, image5];
    return imagesArray[controlIndex];
}

- (NSString*) rmeIdeasPullDownControl:(RMEIdeasPullDownControl*)rmeIdeasPullDownControl
               titleForControlAtIndex:(NSUInteger)controlIndex
{
    return self.sortTitlesArray[controlIndex];
}
@end
