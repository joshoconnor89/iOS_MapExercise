//
//  MapViewController.m
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTestObject];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTestObject {
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}


@end