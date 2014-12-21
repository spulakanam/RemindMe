//
//  RMReminderOptionsViewController.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMReminderOptionsViewController.h"
#import "RMMainContainerViewController.h"

@interface RMReminderOptionsViewController ()

@end

@implementation RMReminderOptionsViewController

- (void)viewDidLoad
{
    switch (self.mOptionsType) {
        case 1:
            [self.mEnterButton setBackgroundImage:[UIImage imageNamed:@"enter_home_btn@2x.png"] forState:UIControlStateNormal];
            [self.mExitButton setBackgroundImage:[UIImage imageNamed:@"exit_home_btn@2x.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.mEnterButton setBackgroundImage:[UIImage imageNamed:@"enter_office_btn@2x.png"] forState:UIControlStateNormal];
            [self.mExitButton setBackgroundImage:[UIImage imageNamed:@"exit_office_btn@2x.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.mEnterButton setBackgroundImage:[UIImage imageNamed:@"enter_car_btn@2x.png"] forState:UIControlStateNormal];
            [self.mExitButton setBackgroundImage:[UIImage imageNamed:@"exit_car_btn@2x.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)entryClicked:(id)sender
{
    [(RMMainContainerViewController *)self.mOptionsDelegate optionDidSelect:YES];
}

- (IBAction)exitClicked:(id)sender
{
    [(RMMainContainerViewController *)self.mOptionsDelegate optionDidSelect:NO];
}
@end
