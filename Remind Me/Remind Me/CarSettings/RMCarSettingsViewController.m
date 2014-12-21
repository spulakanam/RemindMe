//
//  RMCarSettingsViewController.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMCarSettingsViewController.h"

@interface RMCarSettingsViewController ()

@end

@implementation RMCarSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *theBlutoothID = [[NSUserDefaults standardUserDefaults] objectForKey:@"bluetoothID"];
    
    if (theBlutoothID == nil)
    {
        self.mBlueToothTextField.text = @"25";
        [[NSUserDefaults standardUserDefaults] setObject:self.mBlueToothTextField.text forKey:@"bluetoothID"];
    }
    else
    {
        self.mBlueToothTextField.text = theBlutoothID;
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)saveBluetooth:(id)sender
{
    [self.mBlueToothTextField resignFirstResponder];
    NSString *theNumber = self.mBlueToothTextField.text;
    
    if (theNumber == nil || theNumber.length == 0 || [theNumber isEqualToString:@""] == YES)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please enter a value for bluetooth device ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [theAlert show];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:theNumber forKey:@"bluetoothID"];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Bluetooth device ID saved successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [theAlert show];

    }
}

# pragma mark -
# pragma mark text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

@end
