//
//  RMPopoverViewController.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMPopoverViewController : UIViewController

@property (strong, nonatomic) NSDictionary *mReminderInfo;
@property (weak, nonatomic) IBOutlet UITableView *mRemindersListView;
@property (weak, nonatomic) IBOutlet UIImageView *mReminderTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *mEntryOrExitLabel;
@property (weak, nonatomic) IBOutlet UILabel *mMainHeaderLabel;

- (IBAction)closePopOver:(id)sender;
-(void)refreshScreen;

@end
