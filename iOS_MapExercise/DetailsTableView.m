//
//  DetailsTableView.m
//  iOS_MapExercise
//
//  Created by Joshua O'Connor on 5/12/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "DetailsTableView.h"

@interface DetailsTableView ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView* activityView;
@property (nonatomic, strong) NSArray *pinObjectData;
@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) NSArray *latitudeArray;
@property (nonatomic, strong) NSArray *longitudeArray;
@property (nonatomic, strong) NSArray *dateArray;

@end

@implementation DetailsTableView


#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showActivityViewer];
    self.navigationItem.title = @"Pins";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    PinsQuery *pinsQuery = [[PinsQuery alloc]init];
    pinsQuery.delegate = self;
    [pinsQuery fetchPinObject];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pinObjectData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    cell.addressLabel.text = self.addressArray[indexPath.row];

    NSString *coordinates = [NSString stringWithFormat:@"%@, %@", [self.latitudeArray[indexPath.row]stringValue], [self.longitudeArray[indexPath.row]stringValue]];
    cell.coordinatesLabel.text = coordinates;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy 'at' hh:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:self.dateArray[indexPath.row]];
    cell.dateLabel.text = stringFromDate;
    
    return cell;
}


#pragma mark - PinsQueryDelegate Methods

-(void)tableReloadData: (NSArray *)queryResponse {
    self.pinObjectData = queryResponse;
    self.addressArray = [queryResponse valueForKey:@"Address"];
    self.latitudeArray = [queryResponse valueForKey:@"Latitude"];
    self.longitudeArray = [queryResponse valueForKey:@"Longitude"];
    self.dateArray = [queryResponse valueForKey:@"createdAt"];
    
    [self hideActivityViewer];
    [self.tableView reloadData];
    
}


#pragma mark - UI

-(void)showActivityViewer {
    
    self.activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.activityView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    self.activityView.alpha = 1;
    [self.navigationController.view addSubview: self.activityView];
    
    
    
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/2-35, 0, 70, 70)];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityWheel.color = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    [self.activityView addSubview:activityWheel];
    
    [[[self.activityView subviews] objectAtIndex:0] startAnimating];
    
}

-(void)hideActivityViewer {
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    
}

@end

