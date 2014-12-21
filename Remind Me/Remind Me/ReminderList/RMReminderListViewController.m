//
//  RMReminderListViewController.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMReminderListViewController.h"
#import "RMReminderListTableViewCell.h"

@interface RMReminderListViewController ()

@end

@implementation RMReminderListViewController

- (void)viewDidLoad {
    
    [self.mReminderListView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.mReminderListView setBackgroundColor:[UIColor clearColor]];
    [super viewDidLoad];
    [self fetchRemindersAndShow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mRemindersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RMReminderListTableViewCell";
    RMReminderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *theReminderInfo = [self.mRemindersArray objectAtIndex: indexPath.row];
    cell.mReminderText.text = [theReminderInfo objectForKey:@"reminderText"];
    
    NSNumber *theReminderType = [theReminderInfo objectForKey:@"reminderType"];
    
    switch ( theReminderType.intValue)
    {
        case eOperationHomeEntry:
            cell.mReminderForType.image = [UIImage imageNamed:@"enter_home_btn@2x.png"];
            cell.mEntryOrExitLabel.text = @"ENTRY";
            cell.mColorView.backgroundColor = [UIColor colorWithRed:0.6314 green:0.3882 blue:0.8941 alpha:1.0f];
            break;
        case eOperationHomeExit:
            cell.mReminderForType.image = [UIImage imageNamed:@"exit_home_btn@2x.png"];
            cell.mEntryOrExitLabel.text = @"EXIT";
            cell.mColorView.backgroundColor = [UIColor colorWithRed:0.2039 green:0.6941 blue:0.5451 alpha:1.0f];

            break;
        case eOperationWorkEntry:
            cell.mReminderForType.image = [UIImage imageNamed:@"enter_office_btn@2x.png"];
            cell.mEntryOrExitLabel.text = @"ENTRY";
            cell.mColorView.backgroundColor = [UIColor colorWithRed:0.6314 green:0.3882 blue:0.8941 alpha:1.0f];

            break;
        case eOperationWorkExit:
            cell.mReminderForType.image = [UIImage imageNamed:@"exit_office_btn@2x.png"];
            cell.mEntryOrExitLabel.text = @"EXIT";
            cell.mColorView.backgroundColor = [UIColor colorWithRed:0.2039 green:0.6941 blue:0.5451 alpha:1.0f];

            break;
        case eOperationCarEntry:
            cell.mReminderForType.image = [UIImage imageNamed:@"enter_car_btn@2x.png"];
            cell.mEntryOrExitLabel.text = @"ENTRY";
            cell.mColorView.backgroundColor = [UIColor colorWithRed:0.6314 green:0.3882 blue:0.8941 alpha:1.0f];

            break;
        case eOperationCarExit:
            cell.mReminderForType.image = [UIImage imageNamed:@"exit_car_btn@2x.png"];
            cell.mEntryOrExitLabel.text = @"EXIT";
            cell.mColorView.backgroundColor = [UIColor colorWithRed:0.2039 green:0.6941 blue:0.5451 alpha:1.0f];

            break;
        default:
            break;
    }
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(void)fetchRemindersAndShow
{
    NSArray *theArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"];
    self.mRemindersArray = theArray;
    [self.mReminderListView reloadData];
    
    if (self.mRemindersArray.count > 0)
    {
        [self.mReminderListView setHidden:NO];
        [self.mNoRemindersLabel setHidden:YES];
    }
    else
    {
        [self.mReminderListView setHidden:YES];
        [self.mNoRemindersLabel setHidden:NO];
    }
}

@end
