//
//  RMUtility.h
//  Remind Me
//
//  Created by Fareeth John on 12/21/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMConstants.h"

#define kGeoTitle       @"geoTitle"
#define kGeoLocation    @"geoLocation"
#define kGeoRadius      @"geoRadius"
#define kGeoActionType  @"geoACtionType"
#define kGeoTriggerType @"geoTriggerType"

#define kHomeKey        @"ReminderHomeKey"
#define kHomeAddressLat    @"ReminderHomeAddressLat"
#define kHomeAddressLon    @"ReminderHomeAddressLon"
#define kHomeRadius     @"ReminderHomeRadius"

@interface RMUtility : NSObject

+(void)createGeoTriggerForData:(NSDictionary *)aData;
+ (BOOL)shouldAllowToProceedForIdentifier:(NSString *)inBusinessIdentifier;
+(NSMutableArray *)remindersForType:(reminderEntryOrExitType)bReminderType;

@end
