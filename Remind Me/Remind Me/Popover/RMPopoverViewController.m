//
//  RMPopoverViewController.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMPopoverViewController.h"
#import "RMPopOverTableViewCell.h"
#import "RMMainContainerViewController.h"
#import "RMUtility.h"
#import "RMConstants.h"

@interface RMPopoverViewController ()

@end

@implementation RMPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mRemindersListView setBackgroundColor:[UIColor clearColor]];
    [self.mRemindersListView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshScreen
{
    [self.mRemindersListView reloadData];
    NSNumber *theReminderType = [self.mReminderInfo objectForKey:@"reminderType"];
    switch (theReminderType.intValue) {
        case eHomeEntry:
            self.mReminderTypeImageView.image = [UIImage imageNamed:@"enter_home_btn@2x.png"];
            self.mEntryOrExitLabel.text = @"ENTRY";
            self.mMainHeaderLabel.text = @"@HOME REMINDER";
            break;
        case eHomeExit:
            self.mReminderTypeImageView.image = [UIImage imageNamed:@"exit_home_btn@2x.png"];
            self.mEntryOrExitLabel.text = @"EXIT";
            self.mMainHeaderLabel.text = @"@HOME REMINDER";
            break;
        case eWorkEntry:
            self.mReminderTypeImageView.image = [UIImage imageNamed:@"enter_office_btn@2x.png"];
            self.mEntryOrExitLabel.text = @"ENTRY";
            self.mMainHeaderLabel.text = @"@WORK REMINDER";
            break;
        case eWorkExit:
            self.mReminderTypeImageView.image = [UIImage imageNamed:@"exit_office_btn@2x.png"];
            self.mEntryOrExitLabel.text = @"EXIT";
            self.mMainHeaderLabel.text = @"@WORK REMINDER";
            break;
        case eCarEntry:
            self.mReminderTypeImageView.image = [UIImage imageNamed:@"enter_car_btn@2x.png"];
            self.mEntryOrExitLabel.text = @"ENTRY";
            self.mMainHeaderLabel.text = @"@CAR REMINDER";
            break;
        case eCarExit:
            self.mReminderTypeImageView.image = [UIImage imageNamed:@"exit_car_btn@2x.png"];
            self.mEntryOrExitLabel.text = @"EXIT";
            self.mMainHeaderLabel.text = @"@CAR REMINDER";
            break;
        default:
            break;
    }

    
}

- (IBAction)closePopOver:(id)sender
{
    RMMainContainerViewController *containerVC = (RMMainContainerViewController *)self.parentViewController;
    [containerVC closePopover];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *theReminderType = [self.mReminderInfo objectForKey:@"reminderType"];
    NSArray *theRemindersArray = [RMUtility remindersForType:theReminderType.intValue];
    NSLog(@"theRemindersArray -> %@", theRemindersArray);
    return theRemindersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RMPopOverTableViewCell";
    RMPopOverTableViewCell *cell = (RMPopOverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSNumber *theReminderType = [self.mReminderInfo objectForKey:@"reminderType"];
    NSArray *theRemindersArray = [RMUtility remindersForType:theReminderType.intValue];
    cell.mReminderTextLabel.text = [theRemindersArray objectAtIndex:indexPath.row];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


@end
