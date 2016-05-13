//
//  MapViewController.m
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344


@interface MapViewController () {
    PinDetails *pinDetails;
    CLLocationManager *locationManager;
}

@property (nonatomic, assign) CLLocationCoordinate2D droppedPinLocation;

@end

@implementation MapViewController


#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createGestureRecognizer];
    [self initiateLocationManager];
    self.mapView.delegate = self;
    pinDetails = [[PinDetails alloc]init];
    self.navigationItem.title = @"Map";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Location Manager

- (void)initiateLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = location.coordinate.latitude;
    zoomLocation.longitude= location.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    [locationManager stopUpdatingLocation];

}

- (IBAction)refreshCurrentLocation:(id)sender {
    [self initiateLocationManager];
}

#pragma mark - Gesture Recognizer

- (void)createGestureRecognizer {
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];

}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    if (sender.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    self.droppedPinLocation = location;
    
    [self createPinWithLocation:location];
    
}


#pragma mark - MapKit

- (void)createPinWithLocation:(CLLocationCoordinate2D)location {
    [self removeLastAnnotation];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:location];
    [self.mapView addAnnotation:annotation];
    [self reverseGeolocatePinLocation:location];
    
}

- (void)removeLastAnnotation {
    [self.mapView removeAnnotation:self.mapView.annotations.lastObject];
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
{
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] init];
    newAnnotation.pinTintColor = [UIColor blueColor];
    newAnnotation.animatesDrop = YES;
    newAnnotation.canShowCallout = NO;
    [newAnnotation setSelected:YES animated:YES];
    return newAnnotation;
}


#pragma mark - Navigation

- (IBAction)showMyLocations:(id)sender {
    [self performSegueWithIdentifier:@"showDetails" sender:self];
}


#pragma mark - Reverse Geolocation

- (void)reverseGeolocatePinLocation:(CLLocationCoordinate2D)location  {
    
    CLLocation *locationToGeocode = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:locationToGeocode completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = placemarks[0];
        NSString *fullAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.name, placemark.locality, placemark.administrativeArea, placemark.postalCode];
        [self updatePinDetailsModel:fullAddress withLatitude:[NSNumber numberWithDouble:location.latitude] andLongitude:[NSNumber numberWithDouble:location.longitude]];
    }];

}


#pragma mark - Object Model

- (void) updatePinDetailsModel:(NSString *)address withLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude {

    pinDetails.address = address;
    pinDetails.latitude = latitude;
    pinDetails.longitude = longitude;

}


#pragma mark - Parse

- (IBAction)savePinToParse:(id)sender {
    
    if (pinDetails.address != nil){
        PFObject *pinObject = [PFObject objectWithClassName:@"Pin"];
        pinObject[@"Address"] = pinDetails.address;
        pinObject[@"Latitude"] = pinDetails.latitude;
        pinObject[@"Longitude"] = pinDetails.longitude;
        [pinObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                [self presentAlertControllerWithTitle:@"Success!" message:@"Your pin's location was saved." actionTitle:@"Ok"];
                
            } else {
                
                [self presentAlertControllerWithTitle:@"Error!" message:@"Your pin's location could not be saved." actionTitle:@"Ok"];
            }
        }];
    }
    
    else{
        [self presentAlertControllerWithTitle:@"Error!" message:@"Your pin's location could not be saved.  Make sure that there is a valid pin on the map before saving." actionTitle:@"Ok"];
    }
}


#pragma mark - UI

- (void)presentAlertControllerWithTitle: (NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* action = [UIAlertAction
                               actionWithTitle:actionTitle
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end