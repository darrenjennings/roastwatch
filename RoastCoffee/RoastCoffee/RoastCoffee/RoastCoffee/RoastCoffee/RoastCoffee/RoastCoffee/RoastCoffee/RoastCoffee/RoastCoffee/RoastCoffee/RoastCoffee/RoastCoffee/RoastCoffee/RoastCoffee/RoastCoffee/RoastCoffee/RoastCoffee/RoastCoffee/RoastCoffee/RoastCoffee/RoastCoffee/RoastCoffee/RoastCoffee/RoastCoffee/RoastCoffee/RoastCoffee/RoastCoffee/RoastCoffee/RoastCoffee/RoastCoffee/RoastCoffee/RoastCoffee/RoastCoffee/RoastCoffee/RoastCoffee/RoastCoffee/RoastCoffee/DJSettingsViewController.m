//
//  DJSettingsViewController.m
//  Roast Coffee
//
//  Created by Darren Jennings on 2/10/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJSettingsViewController.h"

@implementation DJSettingsViewController

-(void)viewDidLoad{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {

    switch( [indexPath row] ) {
        case 1: {
            UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            if( aCell == nil ) {
                aCell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
                aCell.textLabel.text = @"I Have A Switch";
                aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                aCell.accessoryView = switchView;
                [switchView setOn:NO animated:NO];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            }
            return aCell;
        }
            break;
        }
    return nil;
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

@end
