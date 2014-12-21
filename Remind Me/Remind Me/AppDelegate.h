//
//  AppDelegate.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GeotriggerSDK/GeotriggerSDK.h>

@class RMMainContainerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RMMainContainerViewController *mContainerVC;


@end

