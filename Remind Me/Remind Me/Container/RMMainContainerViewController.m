//
//  CBMainContainerViewController.m
//  Chase
//
//  Created by Shashidhar Shenoy on 7/21/14.
//  Copyright (c) 2014 NeurLabs. All rights reserved.
//

#import "RMMainContainerViewController.h"
#import "RMLeftMenuViewController.h"
#import "RMAddReminderViewController.h"
#import "RMReminderListViewController.h"
#import "RMReminderOptionsViewController.h"
#import "RMHomeSettingsViewController.h"
#import "RMWorkSettingsViewController.h"
#import "RMCarSettingsViewController.h"
#import "RMPopoverViewController.h"

@interface RMMainContainerViewController ()

@property (nonatomic, strong) RMLeftMenuViewController *mLeftMenuViewController;
@property (nonatomic, strong) RMAddReminderViewController *mAddReminderViewController;
@property (nonatomic, strong) RMReminderListViewController *mReminderListViewController;
@property (nonatomic, strong) RMHomeSettingsViewController *mHomeSettingsViewController;
@property (nonatomic, strong) RMWorkSettingsViewController *mWorkSettingsViewController;
@property (nonatomic, strong) RMCarSettingsViewController *mCarSettingsViewController;
@property (nonatomic, strong) RMPopoverViewController *mPopOverViewController;

@property (nonatomic) BOOL bLeftAnimationInProgress;
@property (nonatomic) BOOL bRightAnimationInProgress;

@end

@implementation RMMainContainerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.bRightAnimationInProgress = NO;
    [self.navigationController setNavigationBarHidden:YES];

    self.mLeftMenuViewController = [[RMLeftMenuViewController alloc]
                                    initWithNibName:@"RMLeftMenuViewController"
                                    bundle:nil];
    [self addChildViewController:self.mLeftMenuViewController];
    CGRect mLeftMenuFrame = self.mLeftMenuViewController.view.frame;
    mLeftMenuFrame.origin.x = -101;
    self.mLeftMenuViewController.view.frame = mLeftMenuFrame;
    [self.view addSubview:self.mLeftMenuViewController.view];
    [self.mLeftMenuViewController didMoveToParentViewController:self];
    
    self.mReminderListViewController = [[RMReminderListViewController alloc]
                                    initWithNibName:@"RMReminderListViewController"
                                    bundle:nil];

    self.mContentNavController = [[UINavigationController alloc] initWithRootViewController:self.mReminderListViewController];
    [self addChildViewController:self.mContentNavController];
    self.mContentNavController.view.frame = self.mContentHolderView.frame;
    [self.mContentHolderView addSubview:self.mContentNavController.view];
    [self.mContentNavController didMoveToParentViewController:self];
    
    
    self.mHomeSettingsViewController = [[RMHomeSettingsViewController alloc]
                                       initWithNibName:@"RMHomeSettingsViewController"
                                       bundle:nil];
    [self addChildViewController:self.mHomeSettingsViewController];
    self.mHomeSettingsViewController.view.frame = self.mContentHolderView.frame;
    [self.mContentHolderView addSubview:self.mHomeSettingsViewController.view];
    [self.mHomeSettingsViewController didMoveToParentViewController:self];

    
    self.mWorkSettingsViewController = [[RMWorkSettingsViewController alloc]
                                        initWithNibName:@"RMWorkSettingsViewController"
                                        bundle:nil];
    [self addChildViewController:self.mWorkSettingsViewController];
    self.mWorkSettingsViewController.view.frame = self.mContentHolderView.frame;
    [self.mContentHolderView addSubview:self.mWorkSettingsViewController.view];
    [self.mWorkSettingsViewController didMoveToParentViewController:self];
    

    self.mCarSettingsViewController = [[RMCarSettingsViewController alloc]
                                        initWithNibName:@"RMCarSettingsViewController"
                                        bundle:nil];
    [self addChildViewController:self.mCarSettingsViewController];
    self.mCarSettingsViewController.view.frame = self.mContentHolderView.frame;
    [self.mContentHolderView addSubview:self.mCarSettingsViewController.view];
    [self.mCarSettingsViewController didMoveToParentViewController:self];
    

    self.mAddReminderViewController = [[RMAddReminderViewController alloc]
                               initWithNibName:@"RMAddReminderViewController"
                               bundle:nil];
    [self addChildViewController:self.mAddReminderViewController];
    CGRect reminderRect = self.mAddReminderViewController.view.frame;
    reminderRect.origin.y = -230;
    self.mAddReminderViewController.view.frame = reminderRect;
    [self.mContentHolderView addSubview:self.mAddReminderViewController.view];
    [self.mAddReminderViewController didMoveToParentViewController:self];
    
    
    self.mPopOverViewController = [[RMPopoverViewController alloc]
                                   initWithNibName:@"RMPopoverViewController"
                                   bundle:nil];
    [self addChildViewController:self.mPopOverViewController];
    self.mPopOverViewController.view.frame = self.view.frame;
    [self.view addSubview:self.mPopOverViewController.view];
    [self.mPopOverViewController didMoveToParentViewController:self];
    

    [self.mHomeSettingsViewController.view setAlpha:0.0f];
    [self.mWorkSettingsViewController.view setAlpha:0.0f];
    [self.mCarSettingsViewController.view setAlpha:0.0f];
    [self.mPopOverViewController.view setAlpha:0.0f];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark -
# pragma mark local methods


-(void)goBackToEventList
{
    [self setBackButtonOperations: NO];
    [self.mAddApointmentButton setHidden: NO];
    [self.mAddReminderViewController.view setAlpha: 1.0f];
    [self setHeaderTextAs: @"REMIND ME"];
    [self.mContentNavController popViewControllerAnimated:YES];
}

-(void)setBackButtonOperations:(BOOL)bSet
{
    if( bSet == true)
    {
        [self.mActualLeftBarButton setImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
        [self.mActualLeftBarButton removeTarget:self action:@selector(showHamburgerMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.mActualLeftBarButton addTarget:self action:@selector(goBackToEventList) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.mActualLeftBarButton setImage:[UIImage imageNamed:@"left_menu_btn.png"] forState:UIControlStateNormal];
        [self.mActualLeftBarButton removeTarget:self action:@selector(goBackToEventList) forControlEvents:UIControlEventTouchUpInside];

        [self.mActualLeftBarButton
         addTarget:self action:@selector(showHamburgerMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)setHeaderTextAs:(NSString *)inTitle
{
    [self.mHeaderTitleLabel setText: inTitle];
}

- (IBAction)showSummary:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSummary" object:self];
}

- (void)hideDonebutton:(BOOL)bYES withDelegate:(id)delegate
{
    self.doneButton.hidden = bYES;
}


- (void)showMainScreen
{
    [self setHeaderTextAs:@"REMINDER ME"];
    [self showHamburgerMenu:nil];
    [self.mContentNavController.view setAlpha:1.0f];
    [self.mHomeSettingsViewController.view setAlpha:0.0f];
    [self.mWorkSettingsViewController.view setAlpha:0.0f];
    [self.mCarSettingsViewController.view setAlpha:0.0f];
    [self.mAddApointmentButton setHidden: NO];
    [self.mAddReminderViewController.view setAlpha: 1.0f];

}

- (void)showHomeSettings
{
    [self setHeaderTextAs:@"HOME"];
    [self showHamburgerMenu:nil];
    [self.mContentNavController.view setAlpha:0.0f];
    [self.mHomeSettingsViewController.view setAlpha:1.0f];
    [self.mWorkSettingsViewController.view setAlpha:0.0f];
    [self.mCarSettingsViewController.view setAlpha:0.0f];
    [self.mAddApointmentButton setHidden: YES];
    [self.mAddReminderViewController.view setAlpha: 0.0f];
}

- (void)showWorkSettings
{
    [self setHeaderTextAs:@"WORK"];
    [self showHamburgerMenu:nil];
    [self.mContentNavController.view setAlpha:0.0f];
    [self.mHomeSettingsViewController.view setAlpha:0.0f];
    [self.mWorkSettingsViewController.view setAlpha:1.0f];
    [self.mCarSettingsViewController.view setAlpha:0.0f];
    [self.mAddApointmentButton setHidden: YES];
    [self.mAddReminderViewController.view setAlpha: 0.0f];
}

- (void)showCarSettings
{
    [self setHeaderTextAs:@"CAR"];
    [self showHamburgerMenu:nil];
    [self.mContentNavController.view setAlpha:0.0f];
    [self.mHomeSettingsViewController.view setAlpha:0.0f];
    [self.mWorkSettingsViewController.view setAlpha:0.0f];
    [self.mCarSettingsViewController.view setAlpha:1.0f];
    [self.mAddApointmentButton setHidden: YES];
    [self.mAddReminderViewController.view setAlpha: 0.0f];
}

- (IBAction)showHamburgerMenu:(id)sender
{
    if( self.bRightAnimationInProgress == NO)
    {
        int theOffset;
        self.bRightAnimationInProgress = YES;
        if (self.mActualLeftBarButton.tag == 0)
        {
            self.mActualLeftBarButton.tag = 1;
            theOffset = +101;
        }
        else
        {
            self.mActualLeftBarButton.tag = 0;
            theOffset = -101;
        }
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             CGRect theFrame = self.mLeftMenuViewController.view.frame;
             CGRect theContentHolderFrame = self.mContentHolderView.frame;
             CGRect theHeaderViewFrame = self.mHeaderView.frame;
             theFrame.origin.x += theOffset;
             theHeaderViewFrame.origin.x += theOffset;
             theContentHolderFrame.origin.x += theOffset;
             self.mLeftMenuViewController.view.frame = theFrame;
             self.mContentHolderView.frame = theContentHolderFrame;
             self.mHeaderView.frame = theHeaderViewFrame;
         }
                         completion:^(BOOL finished)
         {
             self.bRightAnimationInProgress = NO;
         }];
    }
}

- (IBAction)addNewReminder:(id)sender
{
    int theOffset;
    int theListViewOffset;

    if (self.mAddApointmentButton.tag == 0)
    {
        [self.mAddReminderViewController resetTheControls];
        self.mAddApointmentButton.tag = 1;
        theOffset = +65
        ;
        theListViewOffset = 170.0f;

    }
    else
    {
        self.mAddApointmentButton.tag = 0;
        theOffset = -230;
        theListViewOffset = 0.0f;

    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         CGRect reminderRect = self.mAddReminderViewController.view.frame;
         reminderRect.origin.y = theOffset;
         self.mAddReminderViewController.view.frame = reminderRect;
         
         CGRect reminderListViewRect = self.mReminderListViewController.mReminderListView.frame;
         reminderListViewRect.origin.y = theListViewOffset;
         self.mReminderListViewController.mReminderListView.frame = reminderListViewRect;

     }
                     completion:^(BOOL finished)
     {
         if (self.mAddApointmentButton.tag == 1)
         {
             [self.mAddApointmentButton setImage:[UIImage imageNamed:@"close.png"] forState: UIControlStateNormal];
         }
         else
         {
             [self.mAddApointmentButton setImage:[UIImage imageNamed:@"addiconbtn.png"] forState: UIControlStateNormal];
         }

     }];
}


-(void) showOptionsScreenBasedOn:(int)optionsType
{
    
    [self setBackButtonOperations: YES];
    [self.mAddApointmentButton setHidden: YES];
    [self.mAddReminderViewController.view setAlpha: 0.0f];
    switch (optionsType) {
        case 1:
            [self setHeaderTextAs: @"HOME"];
            break;
            
        case 2:
            [self setHeaderTextAs: @"WORK"];
            break;
            
        case 3:
            [self setHeaderTextAs: @"CAR"];
            break;
            
        default:
            break;
    }

    RMReminderOptionsViewController *theOptionsVC = [[RMReminderOptionsViewController alloc] initWithNibName:@"RMReminderOptionsViewController" bundle:nil];
    theOptionsVC.mOptionsType = optionsType;
    theOptionsVC.mOptionsDelegate = self;
    [self.mContentNavController pushViewController:theOptionsVC animated:YES];
}

- (void)optionDidSelect:(BOOL)optionType
{
    [self.mAddReminderViewController updateStatusWithType: optionType];
    [self goBackToEventList];
}

-(void)didReminderAddAndRefreshScreen
{
    [self addNewReminder:nil];
    [self.mReminderListViewController fetchRemindersAndShow];
    
}


- (void)showRemindersBasedOnInfo:(NSDictionary *)inNotificationInfo
{
    [self.mPopOverViewController setMReminderInfo: inNotificationInfo];
    [self.mPopOverViewController refreshScreen];
    [self.mPopOverViewController.view setAlpha:1.0f];
}


-(void)closePopover
{
    [self.mPopOverViewController.view setAlpha:0.0f];
}

@end

