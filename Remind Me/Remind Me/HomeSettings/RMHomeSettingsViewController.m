//
//  RMHomeSettingsViewController.m
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import "RMHomeSettingsViewController.h"
#import "WildcardGestureRecognizer.h"
#import "RMUtility.h"

@interface RMHomeSettingsViewController ()

-(NSDictionary *)homeData;

@property (nonatomic) BOOL isFirstTime;
@end

/* Default radius size in PX*/
double const circleRadius = 0;

/* Default Location */
#define ZOOM_DISTANCE 500
#define DEFAULT_RADIUS 50


double oldoffset;
double setRadius = DEFAULT_RADIUS;

bool panEnabled = YES;
CLLocationCoordinate2D droppedAt;
MKMapPoint lastPoint;
CustomMKCircleOverlay *circleView;



@implementation RMHomeSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.homeData.count > 0) {
        droppedAt = CLLocationCoordinate2DMake([[self.homeData valueForKey:kHomeAddressLat] floatValue], [[self.homeData valueForKey:kHomeAddressLon] floatValue]);
        setRadius = [[self.homeData valueForKey:kHomeRadius] floatValue];
        [self addCircle];
        [self setRegion];
        [self setRadius:setRadius];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude] completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 self.searchBar.text = locatedAt;
             }
         }];
        
    }
    else{
        self.isFirstTime = YES;
    }
    
    // Do any additional setup after loading the view from its nib.
    
    self.saveButton.layer.cornerRadius = 18;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onSaveAction:(UIButton *)sender {
    if (CLLocationCoordinate2DIsValid(droppedAt)) {
        [self saveData];
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Your changes saved!!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)onDistanceAction:(UISlider *)sender {
    self.distanceLabel.text = [NSString stringWithFormat:@"DISTANCE: %.0fm",sender.value];
    setRadius = sender.value;
    [circleView setCircleRadius:setRadius];
}

#pragma mark - MISC

-(void)saveData{
    NSDictionary *theDataDict = [[NSUserDefaults standardUserDefaults] valueForKey:kHomeKey];
    if (!theDataDict || theDataDict.count == 0) {
        theDataDict = @{};
    }
    NSMutableDictionary *theHomeDict = [[NSMutableDictionary alloc]init];
    [theHomeDict setDictionary:theDataDict];
    
    [theHomeDict setValue:[NSNumber numberWithFloat:droppedAt.latitude] forKey:kHomeAddressLat];
    [theHomeDict setValue:[NSNumber numberWithFloat:droppedAt.longitude] forKey:kHomeAddressLon];
    [theHomeDict setValue:[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.0f",setRadius] floatValue]] forKey:kHomeRadius];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDictionary dictionaryWithDictionary:theHomeDict] forKey:kHomeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary *)homeData{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kHomeKey];
}

-(void)setRegion{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(droppedAt, ZOOM_DISTANCE, ZOOM_DISTANCE);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

-(void)setRadius:(float)aRadius{
    self.distanceSlider.value = aRadius;
    self.distanceLabel.text = [NSString stringWithFormat:@"DISTANCE: %.0fm",aRadius];
}

#pragma mark - SeachBar notification

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!(error))
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            droppedAt = placemark.location.coordinate;
            [self addCircle];
            [self setRegion];
        }
    }];
}

#pragma mark - Map Delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    if(newState == MKAnnotationViewDragStateStarting){
        panEnabled = YES;
    }
    if (newState == MKAnnotationViewDragStateEnding) {
        droppedAt = annotationView.annotation.coordinate;
        //NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        [self addCircle];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude] completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 self.searchBar.text = locatedAt;
             }
         }];
        
        [self performSelector:@selector(setRegion) withObject:nil afterDelay:0.6];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    [annotationView setDraggable:YES];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    
    [annotationView setSelected:YES animated:YES];
    return [annotationView init];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay{
    circleView = [[CustomMKCircleOverlay alloc] initWithCircle:overlay];
    circleView.fillColor = [UIColor redColor];
    circleView.delegate = self;
    
    return circleView;
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView{
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (self.isFirstTime) {
        self.isFirstTime = NO;
        
        droppedAt = userLocation.location.coordinate;
        
        [self setRegion];
        
        /* Add Custom MKCircle with Annotation*/
        [self addCircle];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 self.searchBar.text = locatedAt;
             }
         }];

    }

}

-(void)onRadiusChange:(CGFloat)radius{
    
}

-(void)addCircle{
    
    if(circle != nil)
        [self.mapView removeOverlay:circle];
    circle = [MKCircle circleWithCenterCoordinate:droppedAt radius:circleRadius];
    
    [self.mapView addOverlay: circle];
    
    [circleView setCircleRadius:setRadius];
    
    if(point == nil){
        point = [[MKPointAnnotation alloc] init];
        
        point.coordinate = droppedAt;
        [self.mapView addAnnotation:point];
    }
    else{
        point.coordinate = droppedAt;
    }

}

@end
