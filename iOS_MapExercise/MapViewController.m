//
//  MapViewController.m
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344


@interface MapViewController ()

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@end

@implementation MapViewController

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
    
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    [self createPinWithLocation:location];
    
}


- (void)createPinWithLocation:(CLLocationCoordinate2D)location {
    [self removeLastAnnotation];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:location];
    [self.mapView addAnnotation:annotation];
    
}

- (void)removeLastAnnotation {
    [self.mapView removeAnnotation:self.mapView.annotations.lastObject];
    
}

- (void)createTestObject {
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
}

@end