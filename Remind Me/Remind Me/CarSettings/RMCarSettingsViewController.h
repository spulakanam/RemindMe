//
//  RMCarSettingsViewController.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCarSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mBlueToothTextField;
- (IBAction)saveBluetooth:(id)sender;

@end
