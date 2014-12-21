//
//  RMReminderOptionsViewController.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMReminderOptionsViewController : UIViewController
@property (assign) int mOptionsType;
@property (weak, nonatomic) IBOutlet UIButton *mEnterButton;
@property (weak, nonatomic) IBOutlet UIButton *mExitButton;
@property (strong, nonatomic) id mOptionsDelegate;

- (IBAction)entryClicked:(id)sender;
- (IBAction)exitClicked:(id)sender;
@end
