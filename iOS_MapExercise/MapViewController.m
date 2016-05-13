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
}

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@end

@implementation MapViewController


#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createGestureRecognizer];
    self.mapView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    self.currentLocation = location;
    
//    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    [self createPinWithLocation:location];
    
}


#pragma mark - MapKit Methods

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
//        NSLog(@"Address: %@", fullAddress);
        [self updatePinDetailsModel:fullAddress withLatitude:[NSNumber numberWithDouble:location.latitude] andLongitude:[NSNumber numberWithDouble:location.longitude]];
    }];

}


#pragma mark - Object Model

- (void) updatePinDetailsModel:(NSString *)address withLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude {

    pinDetails = [[PinDetails alloc]init];
    pinDetails.address = address;
    pinDetails.latitude = latitude;
    pinDetails.longitude = longitude;

//    NSLog(@"%@", pinDetails);
    
}


#pragma mark - Parse

- (IBAction)savePinToParse:(id)sender {
    
}

- (void)createTestObject {
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
}

@end