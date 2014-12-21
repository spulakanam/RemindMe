//
//  AppDelegate.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "AppDelegate.h"
#import "RMMainContainerViewController.h"
#import "NLEstimoteBeaconController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[NLEstimoteBeaconController sharedEstimoteController] startMonitoringBeacons];

    [AGSGTGeotriggerManager setLogLevel:AGSGTLogLevelDebug];
    
    [AGSGTGeotriggerManager setupWithClientId:@"Bww0U2Zs8Lw0l7P0" isProduction:YES tags:@[@"test"] completion:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Geotrigger Service setup encountered error: %@", error);
        } else {
            NSLog(@"Geotrigger Service ready to go!");
            
            // Turn on location tracking in adaptive mode
            [AGSGTGeotriggerManager sharedManager].trackingProfile = kAGSGTTrackingProfileAdaptive;
        }
    }];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [self showMainScreen];
    
    UILocalNotification *localNotificationPayload = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if ( localNotificationPayload != nil)
    {
        
        NSLog(@"************************App launched by local notification*********************");
        
        [self processNotificationInfo: localNotificationPayload.userInfo];
        
        NSLog(@"*************************************************************************");
    }
    
    // If we were launched from a push notification, send the payload to the Geotrigger Manager
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
        [AGSGTGeotriggerManager handlePushNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] showAlert:NO];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote notifications with Apple: %@", [error debugDescription]);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo != nil)
    {
        [self processNotificationInfo:[userInfo valueForKey:@"data"]];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"************************App Received Local Notification *********************");
    if (notification != nil)
    {
        [self processNotificationInfo: notification.userInfo];
    }
    NSLog(@"*************************************************************************");
}


-(void)showMainScreen
{
    self.mContainerVC = [[RMMainContainerViewController alloc] initWithNibName:@"RMMainContainerViewController" bundle:nil];
    self.window.rootViewController = self.mContainerVC;
}


-(void)processNotificationInfo:(NSDictionary *)theNotificationInfo
{
    if (theNotificationInfo != nil )
    {
        [self.mContainerVC showRemindersBasedOnInfo: theNotificationInfo];
    }
}



@end
