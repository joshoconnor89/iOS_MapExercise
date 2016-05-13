//
//  PinsQuery.m
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "PinsQuery.h"

@implementation PinsQuery


-(void)fetchPinObject{
    PFQuery *query = [PFQuery queryWithClassName:@"Pin"];
    [query selectKeys:@[@"Address", @"Latitude", @"Longitude"]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil){
            self.queryResponse = objects;
            [self requestSuccessful: objects];
            NSLog(@"%@", [objects valueForKey:@"Address"]);
        }
        else{
            
        }
    }];
}

-(void)requestSuccessful: (NSArray *)queryResponse {
    [self.delegate tableReloadData:queryResponse];
}


@end
