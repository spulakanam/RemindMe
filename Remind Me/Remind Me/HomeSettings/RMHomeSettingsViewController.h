//
//  RMHomeSettingsViewController.h
//  Remind Me
//
//  Created by Shashidhar Shenoy on 12/20/14.
//  Copyright (c) 2014 Neurlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomMapOverlay.h"

@interface RMHomeSettingsViewController : UIViewController<MKMapViewDelegate, CustomMapDelegate>
{
    MKCircle *circle;
    MKPointAnnotation *point;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
- (IBAction)onSaveAction:(UIButton *)sender;
- (IBAction)onDistanceAction:(UISlider *)sender;
@end
