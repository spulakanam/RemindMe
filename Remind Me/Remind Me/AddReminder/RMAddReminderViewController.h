//
//  RMAddReminderViewController.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMConstants.h"

@interface RMAddReminderViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mReminderText;
@property (weak, nonatomic) IBOutlet UIButton *mAddReminderBttn;
@property (weak, nonatomic) IBOutlet UIButton *mHomeButton;
@property (weak, nonatomic) IBOutlet UIButton *mWorkButton;
@property (weak, nonatomic) IBOutlet UIButton *mCarButton;
@property (assign) reminderType mReminderType;
@property (assign) reminderEntryOrExitType mReminderEntryOrExitType;

- (IBAction)addReminder:(id)sender;
- (IBAction)showHomeOption:(id)sender;
- (IBAction)showWorkOption:(id)sender;
- (IBAction)showCarOption:(id)sender;
- (void)updateStatusWithType:(BOOL)optionsType;
-(void)resetTheControls;

@end
