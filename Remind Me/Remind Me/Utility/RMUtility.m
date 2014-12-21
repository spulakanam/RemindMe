//
//  RMUtility.m
//  Remind Me
//
//  Created by Fareeth John on 12/21/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMUtility.h"
#import <GeotriggerSDK/GeotriggerSDK.h>

static const int kTimeLimitforBeaconFoundNotification = 120;

@implementation RMUtility

+(void)createGeoTriggerForData:(NSDictionary *)aData{
    AGSGTTriggerBuilder *builder = [AGSGTTriggerBuilder new];
    builder.triggerId = [NSString stringWithFormat:@"%@-%@-%@",[AGSGTGeotriggerManager sharedManager].deviceId,[aData valueForKey:kGeoTriggerType],[aData valueForKey:kGeoActionType]];
//    builder.tags = @[[NSString stringWithFormat:@"%@-%@",[AGSGTGeotriggerManager sharedManager].deviceId,[aData valueForKey:kGeoTriggerType]]];
    builder.tags = @[[AGSGTGeotriggerManager sharedManager].deviceDefaultTag];
    builder.direction = [aData valueForKey:kGeoActionType];
    builder.notificationSound = UILocalNotificationDefaultSoundName;
    NSMutableDictionary *theInfoDictionary = [NSMutableDictionary dictionary];
    [theInfoDictionary setObject:[NSString stringWithFormat:@"Reminder:%@",[aData valueForKey:kGeoTitle]] forKey:@"Message"];
    [theInfoDictionary setObject:[aData valueForKey:@"reminderType"] forKey:@"reminderType"];
    builder.notificationData = theInfoDictionary;
    [builder setGeoWithLocation:[aData valueForKey:kGeoLocation] distance:[[aData valueForKey:kGeoRadius] floatValue]];
    builder.notificationText = [aData valueForKey:kGeoTitle];
    NSDictionary *params = [builder build];

    [[AGSGTApiClient sharedClient] postPath:@"trigger/create"
                                 parameters:params
                                    success:^(id res) {
                                        NSLog(@"Trigger created: %@", res);
                                    }
                                    failure:^(NSError *error) {
                                        NSLog(@"Trigger create error: %@", error.userInfo);
                                    }];
    
//    NSDictionary *addparams = @{@"addTags":[builder.tags lastObject]};
//    [[AGSGTApiClient sharedClient] postPath:@"device/update"
//                                 parameters:addparams
//                                    success:^(id res) {
//                                        NSLog(@"Device updated: %@", res);
//                                    }
//                                    failure:^(NSError *error) {
//                                        NSLog(@"Device update error: %@", error.userInfo);
//                                    }];
}

#if 1

// 4 Minute Logic for testing or Debugging
+(BOOL)shouldAllowToProceedForIdentifier:(NSString *)inBusinessIdentifier
{
    BOOL show = NO;
    
    NSDate *thePreviousShownDate = [[NSUserDefaults standardUserDefaults] objectForKey: inBusinessIdentifier];
    if ( thePreviousShownDate == nil)
    {
        show = YES;
    }
    else
    {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:thePreviousShownDate];
        if ( timeInterval > kTimeLimitforBeaconFoundNotification || timeInterval < 0)
        {
            show = YES;
        }
    }
    return show;
}

#else

// More than a day logic for Appstore live app
+(BOOL)shouldAllowToProceedForIdentifier:(NSString *)inBusinessIdentifier
{
    BOOL show = NO;
    
    NSDate *theCachedShownDate = [[NSUserDefaults standardUserDefaults] objectForKey: inBusinessIdentifier];
    if ( theCachedShownDate == nil)
    {
        show = YES;
    }
    else
    {
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents *currentDateComps = [cal components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *cachedDateComps = [cal components:unitFlags fromDate:theCachedShownDate];
        NSInteger currentYear = [currentDateComps year];
        NSInteger currentMonth = [currentDateComps month];
        NSInteger currentDay = [currentDateComps day];
        NSInteger cachedYear = [cachedDateComps year];
        NSInteger cachedMonth = [cachedDateComps month];
        NSInteger cachedDay = [cachedDateComps day];
        
        if (currentYear > cachedYear)
        {
            show = YES;
        }
        else if ( currentYear == cachedYear)
        {
            if (currentMonth > cachedMonth)
            {
                show = YES;
            }
            else if (currentMonth == cachedMonth)
            {
                if (currentDay > cachedDay)
                {
                    show = YES;
                }
            }
        }
    }
    return show;
}

#endif

+(NSMutableArray *)remindersForType:(reminderEntryOrExitType)bReminderType
{
    NSMutableArray *theCarRemindersArray = nil;
    NSArray *theArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"];
    
    if (theArray != nil)
    {
        for ( int i = 0; i < theArray.count; i++)
        {
            NSDictionary *theReminderInfo = [theArray objectAtIndex:i];
            NSNumber *theReminderType = [theReminderInfo objectForKey:@"reminderType"];
            if ( theReminderType.intValue == bReminderType )
            {
                if (theCarRemindersArray == nil)
                {
                    theCarRemindersArray = [NSMutableArray arrayWithObjects:[theReminderInfo objectForKey:@"reminderText"], nil];
                }
                else
                {
                    [theCarRemindersArray addObject:[theReminderInfo objectForKey:@"reminderText"]];
                }
            }
        }
    }
    return theCarRemindersArray;
}


@end
