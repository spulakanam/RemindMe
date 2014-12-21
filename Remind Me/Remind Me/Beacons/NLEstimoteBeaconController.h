//
//  NLEstimoteBeaconController.h
//  Proximity
//
//  Created by Shashidhar Shenoy on 16.06.2014.
//  Copyright (c) 2014 NeurLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

@interface NLEstimoteBeaconController : NSObject

+(NLEstimoteBeaconController *)sharedEstimoteController;
- (void) startMonitoringBeacons;
- (void) stopMonitoringBeacons;
-(NSString *)getBeaconMajorValue;
-(void)resetValues;
-(void)ForceBeaconRanging;
-(CLLocation *)getUserLocation;
-(void)updateAdminWithBeaconsExit;
-(void)doLogoutOperations;
-(void)getUserLocationForDelegate:(id)inDelegate;

@end
