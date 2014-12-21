//
//  RMReminderListViewController.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eOperationNone,
    eOperationHomeEntry,
    eOperationHomeExit,
    eOperationWorkEntry,
    eOperationWorkExit,
    eOperationCarEntry,
    eOperationCarExit,
}reminderOperationType;

@interface RMReminderListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mNoRemindersLabel;
@property (weak, nonatomic) IBOutlet UITableView *mReminderListView;
@property (strong, nonatomic) NSArray *mRemindersArray;

-(void)fetchRemindersAndShow;

@end
