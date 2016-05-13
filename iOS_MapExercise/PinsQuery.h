//
//  PinsQuery.h
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PinDetails.h"


@protocol PinsQueryDelegate <NSObject>

@required

-(void)tableReloadData: (NSArray *)queryResponse;

@end

@interface PinsQuery : NSObject

@property (strong, nonatomic) NSArray *queryResponse;
@property (weak, nonatomic) id <PinsQueryDelegate> delegate;
-(void)fetchPinObject;

@end
