//
//  DJSettingsViewController.m
//  Roast Coffee
//
//  Created by Darren Jennings on 2/10/14.
//  Copyright (c) 2014 Darren Jennings. All rights reserved.
//

#import "DJSettingsViewController.h"
#import "DJSettingsCell.h"
#import "DJMasterViewController.h"

@implementation DJSettingsViewController

-(void)viewDidLoad{
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.title = @"Settings";
    if(_settingsCell.tempSwitch == nil)
    {
        if(_tehSettings.settings.tempPreference != nil){
            if([self.tehSettings.settings.tempPreference  isEqual: @"F"]){
                UISwitch *swtch = [[UISwitch alloc]initWithFrame:CGRectZero];
                _settingsCell.tempSwitch = swtch;
                swtch.on = true;
                _settingsCell.tempSwitch.on = swtch.on;
            }else{
                UISwitch *swtch = [[UISwitch alloc]initWithFrame:CGRectZero];
                _settingsCell.tempSwitch = swtch;
                swtch.on = FALSE;
                _settingsCell.tempSwitch.on = swtch.on;
                }
        }else{
           // _tehSettings.settings = [[DJSettings alloc] initWithTemp:@"F"];
            UISwitch *swtch = [[UISwitch alloc]initWithFrame:CGRectZero];
            _settingsCell.tempSwitch = swtch;
            swtch.on = true;
            _settingsCell.tempSwitch.on = swtch.on;
        }
        
    }
    
    //custom navigation label settings
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.title;
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"Avenir Next Medium"size:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
    
    self.tableView.allowsSelectionDuringEditing = YES;
        [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else if(section==1){
        return 1;
    }else if(section==2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    switch( [indexPath row] ) {
        case 0: {
            if(indexPath.section == 0)
            {
                if(_settingsCell == nil){
                    _settingsCell = [tableView dequeueReusableCellWithIdentifier:@"SettingTempCell"];
                    _settingsCell.textLabel.text = @"Temp Scale";
                    _settingsCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _settingsCell.imageView.image = [UIImage imageNamed:@"tachometericon.png"];

                    
                    if(_settingsCell.tempSwitch == nil){
                        _settingsCell.accessoryView = _settingsCell.tempSwitch;
                    }
                    
                    NSString *temp = [NSString stringWithFormat:@"%@", _tehSettings.settings.tempPreference];
                    _settingsCell.tempLabel.text = temp;
                    
                    //add line separator for temp cell.
                    UIView *lineView;
                    lineView = [[UIView alloc] initWithFrame:CGRectMake(15, _settingsCell.contentView.frame.size.height - 0.5, _settingsCell.contentView.frame.size.width, 0.5)];
                    [_settingsCell.contentView setFrame:CGRectMake(0, 0, _settingsCell.contentView.frame.size.width, _settingsCell.contentView.frame.size.height-0.5)];
                    [_settingsCell.textLabel setBackgroundColor:[UIColor clearColor]];
                    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
                    [_settingsCell.contentView addSubview:lineView];
                    
                    if([temp  isEqual:@"F"])
                    {
                        [_settingsCell.tempSwitch setOn:YES animated:NO];
                    }
                    else{
                        [_settingsCell.tempSwitch setOn:NO animated:NO];
                    }
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:temp forKey:@"temp"];
                    [defaults synchronize];
                }
                NSLog(@"The switch should be %d",_settingsCell.tempSwitch.on);
                return _settingsCell;
            }else if(indexPath.section == 1){
                UITableViewCell* aCell;
                if( aCell == nil ) {
                    aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"EventsCell"];
                    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    aCell.textLabel.text = @"Events";
                    aCell.imageView.image = [UIImage imageNamed:@"bolticon_green.png"];
                    
                    //add line separator for temp cell.
                    UIView *lineView;
                    lineView = [[UIView alloc] initWithFrame:CGRectMake(15, aCell.contentView.frame.size.height - 0.5, aCell.contentView.frame.size.width, 0.5)];
                    [aCell.contentView setFrame:CGRectMake(0, 0, aCell.contentView.frame.size.width, aCell.contentView.frame.size.height-0.5)];
                    [aCell.textLabel setBackgroundColor:[UIColor clearColor]];
                    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
                    [aCell.contentView addSubview:lineView];
                }
                return aCell;
                
            }else if(indexPath.section == 2){
                UITableViewCell* dataCell;
                if( dataCell == nil ) {
                    dataCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DataCell"];
                    dataCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    dataCell.textLabel.text = @"Data";
                    dataCell.imageView.image = [UIImage imageNamed:@"databaseicon_blue.png"];
                }
                return dataCell;
            }
        }
/*       case 0: {
            UITableViewCell* aCell;
            if( aCell == nil ) {
                aCell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
                aCell.textLabel.text = @"About";
                
            }
            return aCell;
        }*/
            break;
        }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"";
    }
    else if(section == 1)
    {
        return @"";
    }
    else
    {
        return @"";
    }
}
- (IBAction)switchValueChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    _settingsCell.tempSwitch.on = switchControl.on;
    
    //_tehSettings = [[DJSettings alloc]initWithTemp:[NSString stringWithFormat:@"%@", _settingsCell.tempSwitch.on ? @"F" : @"C"]];
    
    _tehSettings.settings.tempPreference = [NSString stringWithFormat:@"%@", _settingsCell.tempSwitch.on ? @"F" : @"C"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(reloadTableData)
                                   userInfo:nil
                                    repeats:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.tehSettings.settings.tempPreference forKey:@"temp"];
    [defaults synchronize];
    [_tehSettings saveData];
}

-(void)reloadTableData{
    [self.tableView reloadData];
    _settingsCell.tempLabel.text = self.tehSettings.settings.tempPreference;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([cell.textLabel.text isEqual:@"Events"])
    {
        NSLog(@"Editing %i", self.editing);
        [self performSegueWithIdentifier:@"CustomEventsSegue" sender:cell];
    }else if([cell.textLabel.text isEqual:@"Data"])
    {
        NSLog(@"Editing %i", self.editing);
        [self performSegueWithIdentifier:@"DatabaseSettingsSegue" sender:cell];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CustomEventsSegue"])
    {
        DJSettingsDoc *object = _tehSettings;
        [[segue destinationViewController] setDetailItem:object];
    }else if([segue.identifier isEqualToString:@"DatabaseSettingsSegue"])
    {
        DJSettingsDoc *object = _tehSettings;
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
