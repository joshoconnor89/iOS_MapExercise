//
//  MapViewController.h
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *saveLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *myLocationsButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

