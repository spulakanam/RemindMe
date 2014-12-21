//
//  RMMainContainerViewController.h
//  Chase
//
//  Created by Shashidhar Shenoy on 7/21/14.
//  Copyright (c) 2014 NeurLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionTypeSelectorDelegate
@required
- (void)optionDidSelect:(BOOL)optionType;
@end

@interface RMMainContainerViewController : UIViewController<OptionTypeSelectorDelegate>
@property (weak, nonatomic) IBOutlet UIView *mContentHolderView;
@property (weak, nonatomic) IBOutlet UIView *mHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *mLeftbarbutton;
@property (weak, nonatomic) IBOutlet UILabel *mHeaderTitleLabel;
@property (nonatomic, strong) UINavigationController *mContentNavController;
@property (weak, nonatomic) IBOutlet UIButton *mActualLeftBarButton;
@property (weak, nonatomic) IBOutlet UIView *mnavigationHeaderView;
@property (assign) BOOL bDirectLaunch;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *mAddApointmentButton;

- (void)setBackButtonOperations:(BOOL)bSet;
- (void)setHeaderTextAs:(NSString *)inTitle;
- (void)showMainScreen;
- (void)showHomeSettings;
- (void)showWorkSettings;
- (void)showCarSettings;
- (IBAction)showHamburgerMenu:(id)sender;
- (IBAction)addNewReminder:(id)sender;
- (void)showOptionsScreenBasedOn:(int)optionsType;
-(void)didReminderAddAndRefreshScreen;
- (void)showRemindersBasedOnInfo:(NSDictionary *)inNotificationInfo;
-(void)closePopover;

@end
