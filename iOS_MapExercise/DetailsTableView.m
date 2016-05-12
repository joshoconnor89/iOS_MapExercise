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
@property (nonatomic, strong) NSArray *dummyData;


@end

@implementation DetailsTableView


#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dummyData = @[@"39.2824", @"50.3845", @"84.4847", @"36.4757"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dummyData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    cell.latitudeLabel.text = self.dummyData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

