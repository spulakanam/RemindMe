//
//  NLEstimoteBeaconController.m
//  Proximity
//
//  Created by Shashidhar Shenoy on 16.06.2014.
//  Copyright (c) 2014 NeurLabs. All rights reserved.
//

#import "NLEstimoteBeaconController.h"
#import "ESTBeaconManager.h"
#import "AppDelegate.h"
#import "RMUtility.h"
#import "RMConstants.h"

static NLEstimoteBeaconController *sNLEstimoteController = nil;

static const int kMajor = 36;

static const int kMinor = 25;

static const int kMaxTrialRange = 3; // number of range tries at a time

static const int kNoOfSecondsBetweenFiringsOfTimer = 20; // The number of seconds between firings of the timer

static  NSString *kBigEventsProximityIdentifier = @"BigEvents36ProximityRegion";

@interface NLEstimoteBeaconController () <ESTBeaconManagerDelegate , CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *mLocationManager;
@property (nonatomic, strong) ESTBeaconManager  *mBeaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *mPetBeaconRegion;
@property (nonatomic, strong) NSMutableArray    *mBeaconsArray;
@property (nonatomic, strong) NSMutableArray    *mFreshBeaconsIDArray;
@property (nonatomic, strong) NSTimer           *mBeaconsRangeSchedulerTimer;
@property (nonatomic, strong) id                 mCLDelegateHolder;
@property (nonatomic) int mTrials;
@property (nonatomic) float mLat;
@property (nonatomic) float mLong;
@property (nonatomic, strong)CLLocation *mUserLocation;
@property (assign) BOOL mRangeInProgress;
@property (assign) BOOL mDidBeaconsDataAlreadySend;
@property (assign) BOOL bCLLock;
@property (assign) BOOL bEntry;
@property (assign) BOOL isAlertShownNow;


@end

@implementation NLEstimoteBeaconController

+(NLEstimoteBeaconController *)sharedEstimoteController
{
    if (sNLEstimoteController == nil)
    {
        sNLEstimoteController = [[NLEstimoteBeaconController alloc] init];
    }
    return sNLEstimoteController;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.mBeaconsArray = [[NSMutableArray alloc] init];
        self.mLocationManager = [[CLLocationManager alloc] init];
        self.mLocationManager.delegate = self;
        
        self.mBeaconManager = [[ESTBeaconManager alloc] init];
        self.mBeaconManager.delegate = self;
        self.mBeaconManager.avoidUnknownStateBeacons = YES;
        self.mDidBeaconsDataAlreadySend = NO;
        self.mPetBeaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                         major:kMajor
                                                                         minor: kMinor
                                                                    identifier:kBigEventsProximityIdentifier];
        self.mPetBeaconRegion.notifyOnEntry = YES;
        self.mPetBeaconRegion.notifyOnExit = YES;
        
        self.mLat = 0.0f;
        self.mLong = 0.0f;
        self.bEntry = NO;
        self.isAlertShownNow = NO;
    }
    return self;
}

-(NSString *)getBeaconMajorValue;
{
    return [NSString stringWithFormat:@"%d", kMajor];
}


- (void)startMonitoringBeacons
{
    if ([self.mLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.mLocationManager requestAlwaysAuthorization];
    }
    [self.mBeaconManager startMonitoringForRegion:self.mPetBeaconRegion];
    [self startRangingBeacons];
}

- (void)stopMonitoringBeacons
{
    if ( [self.mBeaconsRangeSchedulerTimer isValid])
    {
        [self.mBeaconsRangeSchedulerTimer invalidate];
        self.mBeaconsRangeSchedulerTimer = nil;
    }
    [self.mBeaconManager stopMonitoringForRegion:self.mPetBeaconRegion];
    [self stopRangingBeacons];
}

-(void)ForceBeaconRanging
{
    self.mTrials = 0;
    self.mRangeInProgress = false;
    self.mDidBeaconsDataAlreadySend = false;
    [self startRangingBeacons];
}

- (void) startRangingBeacons
{
    if ( self.mTrials == 0 && self.mRangeInProgress == false)
    {
        if ( [self.mBeaconsRangeSchedulerTimer isValid])
        {
            [self.mBeaconsRangeSchedulerTimer invalidate];
            self.mBeaconsRangeSchedulerTimer = nil;
        }
        self.mRangeInProgress = true;
        [self.mBeaconManager startRangingBeaconsInRegion:self.mPetBeaconRegion];
    }
}

- (void) stopRangingBeacons
{
    [self.mBeaconManager stopRangingBeaconsInRegion:self.mPetBeaconRegion];
    self.mTrials = 0;
    self.mRangeInProgress = false;
}

-(void)resetValues
{
    self.mDidBeaconsDataAlreadySend = NO;
}

#pragma mark - CLLocationManager methods and delegates

-(void)getUserLocationForDelegate:(id)inDelegate
{
    self.bCLLock = NO;
    self.mCLDelegateHolder = inDelegate;
    [self.mLocationManager startUpdatingLocation];
}

-(CLLocation *)getUserLocation
{
    return self.mUserLocation;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ( self.bCLLock == NO )
    {
        self.bCLLock = YES;
        NSLog(@"NewLocation -> %@",   newLocation);
        self.mUserLocation = newLocation;
        [self.mLocationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.mLocationManager stopUpdatingLocation];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    NSString *theRegionIdentifier = region.identifier;
    NSString *theMessage = [NSString stringWithFormat:@"Entering In region %@", theRegionIdentifier];
    NSLog(@"%@",theMessage);
# if DEBUG
    //[self postLocalNotificationForMessage:theMessage withInfo:nil];
    self.bEntry = YES;
#endif
    [self ForceBeaconRanging];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    NSString *theMessage = [NSString stringWithFormat:@"Exiting from region %@", region.identifier];
    NSLog(@"%@",theMessage);
# if DEBUG
    //[self postLocalNotificationForMessage:theMessage withInfo:nil];
    self.bEntry = YES;
#endif
    self.mDidBeaconsDataAlreadySend = NO;
    [self ForceBeaconRanging];
}

-(void)beaconManager:(ESTBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(ESTBeaconRegion *)region
{
    if ( state == CLRegionStateInside)
    {
        [self startRangingBeacons];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    self.mTrials++;
    NSLog(@"%d", self.mTrials);
    if ( self.mTrials > kMaxTrialRange)
    {
        [self stopRangingBeacons];
        if ( 1)//[PFUser currentUser] != nil)
        {
            NSLog(@"Perform Beacon operation: Location -> %@" , self.mLocationManager.location);
            self.mDidBeaconsDataAlreadySend = YES;
            [self performOperationsBasedOnFoundBeacons];
        }
        self.mBeaconsRangeSchedulerTimer = [NSTimer scheduledTimerWithTimeInterval:kNoOfSecondsBetweenFiringsOfTimer
                                                                            target:self
                                                                          selector:@selector(handleRangeBeaconsTimer:)
                                                                          userInfo:nil
                                                                           repeats:NO];
        [self.mBeaconsArray removeAllObjects];
    }
    else
    {
        NSLog(@"%d attempt and beacons -> %@" ,self.mTrials, beacons);
        [self.mBeaconsArray setArray: beacons];
        [self addBeaconsInfoToMasterBeaconArray];
        
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region
           withError:(NSError *)error
{
    NSLog(@"Error -> %@", error);
    if ( self.isAlertShownNow == NO  /*&&  [PFUser currentUser] != nil*/ )
    {
        self.isAlertShownNow = YES;
        [[[UIAlertView alloc] initWithTitle:@"Info"
                                    message:@"It looks like Blutooth is turned off. Please check the device bluetooth settings to get the desired results."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    [self updateAdminWithBeaconsExit];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    self.isAlertShownNow = NO;
}


#pragma mark - local methods

-(void)doLogoutOperations
{
    [self.mFreshBeaconsIDArray removeAllObjects];
    [self updateAdminWithBeaconsExit];
}

- (void)handleRangeBeaconsTimer:(NSTimer *)theTimer
{
    [self startRangingBeacons];
}

-(void)postLocalNotificationForMessage:(NSString *)aMsg withInfo:(NSDictionary *)info
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = aMsg;
    notification.userInfo = info;
    if ( [[UIApplication sharedApplication] applicationState] !=  UIApplicationStateActive)
    {
        notification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


-(void)performOperationsBasedOnFoundBeacons
{
# if DEBUG
    if (self.bEntry == YES)
    {
        self.bEntry = NO;
        [self showFoundBeaconsNotification];
    }
#endif
    for (ESTBeacon *beacon in self.mBeaconsArray)
    {
        NSString *inCarEntryIdentifier = [NSString stringWithFormat:@"Car_Entry_%@_%@",beacon.major,beacon.minor];
        NSLog(@"Check for Showing message for %@", inCarEntryIdentifier);
        if ( [RMUtility shouldAllowToProceedForIdentifier: inCarEntryIdentifier] == YES)
        {
            NSArray *theReminders = [RMUtility remindersForType:eCarEntry];
            if (theReminders.count > 0)
            {
                NSString *theThanksMessage = [NSString stringWithFormat:@"Reminder: %@", theReminders.firstObject];
                NSMutableDictionary *theInfoDictionary = [NSMutableDictionary dictionary];
                [theInfoDictionary setObject:theThanksMessage forKey:@"Message"];
                [theInfoDictionary setObject:[NSNumber numberWithInt:eCarEntry] forKey:@"reminderType"];
                [self postLocalNotificationForMessage:theThanksMessage withInfo:theInfoDictionary];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:inCarEntryIdentifier];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    [self updateAdminWithBeaconsExit];
}


-(void)addBeaconsInfoToMasterBeaconArray
{
    if ( self.mBeaconsArray.count > 0)
    {
        NSMutableArray *theBeaconsMasterArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"kMasterBeaconsArray"]];
        if ( theBeaconsMasterArray == nil)
        {
            theBeaconsMasterArray = [[NSMutableArray alloc] init];
        }
        
        if (self.mFreshBeaconsIDArray == nil)
        {
            self.mFreshBeaconsIDArray = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.mFreshBeaconsIDArray  removeAllObjects];
        }
        
        for (ESTBeacon *beacon in self.mBeaconsArray)
        {
            NSString *inBusinessIdentifier = [NSString stringWithFormat:@"BankID_%@_%@",beacon.major,beacon.minor];
            
            if ( [theBeaconsMasterArray containsObject: inBusinessIdentifier] == NO)
            {
                [theBeaconsMasterArray addObject: inBusinessIdentifier];
            }
            
            if ( [self.mFreshBeaconsIDArray containsObject: inBusinessIdentifier] == NO)
            {
                [self.mFreshBeaconsIDArray addObject: inBusinessIdentifier];
            }
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:theBeaconsMasterArray forKey:@"kMasterBeaconsArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)updateAdminWithBeaconsExit
{
    NSMutableArray *theBeaconsMasterArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"kMasterBeaconsArray"];
    for (NSString *theBeaconID in theBeaconsMasterArray)
    {
        NSArray *theSpiltArray = [theBeaconID componentsSeparatedByString:@"_"];
        if( theSpiltArray.count == 3)
        {
            NSString *theMajor = [theSpiltArray objectAtIndex: 1];
            NSString *theMinor = [theSpiltArray objectAtIndex: 2];
            NSString *theExitUserIdentifier = [NSString stringWithFormat:@"Car_Exit_%@_%@",theMajor,theMinor];
            if( [self.mFreshBeaconsIDArray containsObject:theBeaconID] == NO)
            {
                if ( [RMUtility shouldAllowToProceedForIdentifier: theExitUserIdentifier] == YES)
                {
                    NSArray *theReminders = [RMUtility remindersForType:eCarExit];
                    if (theReminders.count > 0)
                    {
                        NSString *theThanksMessage = [NSString stringWithFormat:@"Reminder: %@", theReminders.firstObject];
                        NSMutableDictionary *theInfoDictionary = [NSMutableDictionary dictionary];
                        [theInfoDictionary setObject:theThanksMessage forKey:@"Message"];
                        [theInfoDictionary setObject:[NSNumber numberWithInt:eCarExit] forKey:@"reminderType"];
                        [self postLocalNotificationForMessage:theThanksMessage withInfo:theInfoDictionary];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:theExitUserIdentifier];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.mFreshBeaconsIDArray forKey:@"kMasterBeaconsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mFreshBeaconsIDArray removeAllObjects];
    
}


-(BOOL)isUserRangeIsVeryNearToBeacon:(ESTBeacon *)inBeacon
{
    BOOL isNear = NO;
    NSString *theRange = @"Unknown";
    
    if( inBeacon.proximity == CLProximityImmediate)
    {
        isNear = YES;
        theRange = @"Immediate";
    }
    else if ( inBeacon.proximity == CLProximityNear)
    {
        isNear = YES;
        theRange = @"Near";
    }
    else if ( inBeacon.proximity == CLProximityFar)
    {
        theRange = @"Far";
    }
    
    NSLog(@"Beacon with ID %@ range is %@", inBeacon.minor, theRange);
    return isNear;
}

-(void)showFoundBeaconsNotification
{
    NSString *theFoundBeacons = nil;
    for (ESTBeacon *beacon in self.mBeaconsArray)
    {
        if ( theFoundBeacons == nil)
        {
            theFoundBeacons = [NSString stringWithFormat:@"Found Beacons %@", beacon.minor];
        }
        else
        {
            theFoundBeacons = [NSString stringWithFormat:@"%@ , %@", theFoundBeacons, beacon.minor];
        }
    }
    
    if (theFoundBeacons != nil)
    {
        //[self postLocalNotificationForMessage:theFoundBeacons withInfo:nil];
    }
    else
    {
        //[self postLocalNotificationForMessage:@"No beacons found !!!" withInfo:nil];
    }
}


@end
