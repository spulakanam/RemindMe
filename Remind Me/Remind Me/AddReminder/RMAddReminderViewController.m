//
//  RMAddReminderViewController.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMAddReminderViewController.h"
#import "RMMainContainerViewController.h"
#import "RMUtility.h"
#import <CoreLocation/CoreLocation.h>

@interface RMAddReminderViewController ()

@end

@implementation RMAddReminderViewController

- (void)viewDidLoad
{
    self.mReminderEntryOrExitType = eNone;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addReminder:(id)sender
{
    NSLog(@"%@", self.parentViewController);
    [self.mReminderText resignFirstResponder];
    
    NSString *theReminderText = self.mReminderText.text;
    if (theReminderText == nil || theReminderText.length == 0 || [theReminderText isEqualToString:@""] == YES)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Please enter a value for reminder text." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [theAlert show];
    }
    else if ( self.mReminderEntryOrExitType == eNone)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Please choose the reminder type." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [theAlert show];
    }
    else
    {
        NSArray *theArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"];
        NSMutableArray *theReminders = [NSMutableArray array];
        if (theArray == nil)
        {
            theReminders = [NSMutableArray array];
        }
        else
        {
            theReminders = [NSMutableArray arrayWithArray: theArray];
        }
        
        NSDictionary *theNewReminder = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:theReminderText,[NSNumber numberWithInt:self.mReminderEntryOrExitType], nil] forKeys:[NSArray arrayWithObjects:@"reminderText",@"reminderType",nil]];
        
        [theReminders addObject: theNewReminder];
        
        //For checking address
        if (self.mReminderType == eHome) {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:kHomeKey] count] == 0) {
                [[[UIAlertView alloc]initWithTitle:@"" message:@"Please add your home address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject: theReminders forKey:@"reminders"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        RMMainContainerViewController *containerVC = (RMMainContainerViewController *)self.parentViewController;
        [containerVC didReminderAddAndRefreshScreen];
        
        //For Geo Trigger
        if (self.mReminderType == eHome) {
            [self createGeoTriggerForData:theNewReminder];
        }
    }
}

- (IBAction)showHomeOption:(id)sender
{
    self.mReminderType = eHome;
    [self.mReminderText resignFirstResponder];
    RMMainContainerViewController *containerVC = (RMMainContainerViewController *)self.parentViewController;
    [containerVC showOptionsScreenBasedOn: self.mReminderType];
}

- (IBAction)showWorkOption:(id)sender
{
    self.mReminderType = eWork;
    [self.mReminderText resignFirstResponder];
    RMMainContainerViewController *containerVC = (RMMainContainerViewController *)self.parentViewController;
    [containerVC showOptionsScreenBasedOn: self.mReminderType];
}

- (IBAction)showCarOption:(id)sender
{
    self.mReminderType = eCar;
    [self.mReminderText resignFirstResponder];
    RMMainContainerViewController *containerVC = (RMMainContainerViewController *)self.parentViewController;
    [containerVC showOptionsScreenBasedOn: self.mReminderType];
}

-(void)resetTheControls
{
    [self.mReminderText setText: nil];
    [self.mHomeButton setEnabled: YES];
    [self.mWorkButton setEnabled: YES];
    [self.mCarButton setEnabled: YES];
    self.mReminderType = eTypeNone;
    self.mReminderEntryOrExitType = eNone;
    [self.mHomeButton setBackgroundImage:[UIImage imageNamed:@"home_icon@2x.png"] forState:UIControlStateNormal];
    [self.mWorkButton setBackgroundImage:[UIImage imageNamed:@"work_icon@2x.png"] forState:UIControlStateNormal];
    [self.mCarButton setBackgroundImage:[UIImage imageNamed:@"car_icon@2x.png"] forState:UIControlStateNormal];
    [self.mHomeButton setTitle:@"HOME" forState:UIControlStateNormal];
    [self.mWorkButton setTitle:@"WORK" forState:UIControlStateNormal];
    [self.mCarButton setTitle:@"CAR" forState:UIControlStateNormal];
}


- (void)updateStatusWithType:(BOOL)optionsType
{
    switch (self.mReminderType)
    {
        case eHome:
            
            [self.mHomeButton setEnabled: YES];
            [self.mWorkButton setEnabled: NO];
            [self.mCarButton setEnabled: NO];
            if (optionsType == YES)
            {
                self.mReminderEntryOrExitType = eHomeEntry;
                [self.mHomeButton setBackgroundImage:[UIImage imageNamed:@"enter_home_btn@2x.png"] forState:UIControlStateNormal];
                [self.mHomeButton setTitle:@"ENTRY" forState:UIControlStateNormal];
            }
            else
            {
                self.mReminderEntryOrExitType = eHomeExit;
                [self.mHomeButton setBackgroundImage:[UIImage imageNamed:@"exit_home_btn@2x.png"] forState:UIControlStateNormal];
                [self.mHomeButton setTitle:@"EXIT" forState:UIControlStateNormal];

            }
            break;
            
        case eWork:
            
            [self.mHomeButton setEnabled: NO];
            [self.mWorkButton setEnabled: YES];
            [self.mCarButton setEnabled: NO];

            if (optionsType == YES)
            {
                self.mReminderEntryOrExitType = eWorkEntry;
                [self.mWorkButton setBackgroundImage:[UIImage imageNamed:@"enter_office_btn@2x.png"] forState:UIControlStateNormal];
                [self.mWorkButton setTitle:@"ENTRY" forState:UIControlStateNormal];

            }
            else
            {
                self.mReminderEntryOrExitType = eWorkExit;
                [self.mWorkButton setBackgroundImage:[UIImage imageNamed:@"exit_office_btn@2x.png"] forState:UIControlStateNormal];
                [self.mWorkButton setTitle:@"EXIT" forState:UIControlStateNormal];

            }
            break;
            
        case eCar:
            
            [self.mHomeButton setEnabled: NO];
            [self.mWorkButton setEnabled: NO];
            [self.mCarButton setEnabled: YES];

            if (optionsType == YES)
            {
                self.mReminderEntryOrExitType = eCarEntry;
                [self.mCarButton setBackgroundImage:[UIImage imageNamed:@"enter_car_btn@2x.png"] forState:UIControlStateNormal];
                [self.mCarButton setTitle:@"ENTRY" forState:UIControlStateNormal];
            }
            else
            {
                self.mReminderEntryOrExitType = eCarExit;
                [self.mCarButton setBackgroundImage:[UIImage imageNamed:@"exit_car_btn@2x.png"] forState:UIControlStateNormal];
                [self.mCarButton setTitle:@"EXIT" forState:UIControlStateNormal];

            }
            break;
            
        default:
            break;
    }
}

# pragma mark - MISC

-(void)createGeoTriggerForData:(NSDictionary *)aDict{
    NSString *theTitle = [aDict valueForKey:@"reminderText"];
    int theType =[[aDict valueForKey:@"reminderType"] intValue];
    NSDictionary *theAddressData = nil;
    if (self.mReminderType == eHome) {
        theAddressData = [[NSUserDefaults standardUserDefaults] valueForKey:kHomeKey];
    }
    
    if (theAddressData.count > 0) {
        NSString *theTriggerType = @"";
        NSString *theActionType = @"";
        CLLocation *theLocation = nil;
        switch (theType) {
            case eHomeEntry:
                theTriggerType = @"Home";
                theActionType = @"enter";
                theLocation = [[CLLocation alloc]initWithLatitude:[[theAddressData valueForKey:kHomeAddressLat] floatValue] longitude:[[theAddressData valueForKey:kHomeAddressLon] floatValue]];
                break;
            case eHomeExit:
                theTriggerType = @"Home";
                theActionType = @"leave";
                theLocation = [[CLLocation alloc]initWithLatitude:[[theAddressData valueForKey:kHomeAddressLat] floatValue] longitude:[[theAddressData valueForKey:kHomeAddressLon] floatValue]];
                break;
                
            default:
                break;
        }
        
        NSMutableDictionary *theInputDict = [[NSMutableDictionary alloc]init];
        [theInputDict setValue:theTitle forKey:kGeoTitle];
        [theInputDict setValue:theTriggerType forKey:kGeoTriggerType];
        [theInputDict setValue:theActionType forKey:kGeoActionType];
        [theInputDict setValue:theLocation forKey:kGeoLocation];
        [theInputDict setValue:[NSNumber numberWithInt:self.mReminderEntryOrExitType] forKey:@"reminderType"];
        [theInputDict setValue:[theAddressData valueForKey:kHomeRadius] forKey:kGeoRadius];
        [RMUtility createGeoTriggerForData:theInputDict];
    }
    else{
        
    }
}

# pragma mark - text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


@end
