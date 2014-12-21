//
//  RMReminderListTableViewCell.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMReminderListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mReminderText;
@property (weak, nonatomic) IBOutlet UIImageView *mReminderForType;
@property (weak, nonatomic) IBOutlet UILabel *mEntryOrExitLabel;
@property (weak, nonatomic) IBOutlet UIView *mColorView;
@end
