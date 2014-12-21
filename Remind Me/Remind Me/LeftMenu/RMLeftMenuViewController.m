//
//  BELeftMenuViewController.m
//  Bigevents
//
//  Created by Samarth Shetty on 11/11/14.
//  Copyright (c) 2014 NeurLabs. All rights reserved.
//

#import "RMLeftMenuViewController.h"
#import "RMLeftMenuTableViewCell.h"
#import "RMMainContainerViewController.h"

typedef enum
{
    kMainScreen,
    kHomeSettings,
    kWorkSettings,
    kCarSettings
}TableViewMenu;

@interface RMLeftMenuViewController ()

@end

@implementation RMLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:true];
    [self SetUpMenuTableView];
}

-(void)SetUpMenuTableView
{
    self.mMenuTableView.dataSource = self;
    self.mMenuTableView.delegate = self;
    [self.mMenuTableView setSectionFooterHeight:0.0f];
    [self.mMenuTableView setTableHeaderView:nil];
    self.mMenuTableView.backgroundColor = [UIColor clearColor];
    self.mMenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mMenuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RMLeftMenuTableViewCell";
    RMLeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }


    switch (indexPath.row)
    {
        case kMainScreen:
            cell.mCellImageView.image = [UIImage imageNamed:@"home_icon@2x.png"];
            cell.mCellText.text = @"MAIN";
            break;

        case kHomeSettings:
            cell.mCellImageView.image = [UIImage imageNamed:@"home_icon@2x.png"];
            cell.mCellText.text = @"HOME";
            break;

        case kWorkSettings:
            cell.mCellImageView.image = [UIImage imageNamed:@"work_icon@2x.png"];
            cell.mCellText.text = @"WORK";
            break;
            
        case kCarSettings:
            cell.mCellImageView.image = [UIImage imageNamed:@"car_icon@2x.png"];
            cell.mCellText.text = @"CAR";
            break;

        default:
            break;
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMMainContainerViewController *mainContainerVC = (RMMainContainerViewController *)self.parentViewController;
    switch (indexPath.row) {
            
        case kMainScreen:
            [mainContainerVC showMainScreen];
            break;
            
        case kHomeSettings:
            [mainContainerVC showHomeSettings];
            break;
            
        case kWorkSettings:
            [mainContainerVC showWorkSettings];
            break;

        case kCarSettings:
            [mainContainerVC showCarSettings];
            break;

        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0f;
}



@end