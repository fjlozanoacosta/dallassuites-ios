//
//  RestaurantViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantTableViewCell.h"

#define RestaurantCell @"restaurantCell"

@interface RestaurantViewController () <UITableViewDataSource, UITableViewDelegate>{
    
    //Main View
        //NavBar
    __weak IBOutlet UINavigationBar *navBar;
    
}
//Main View
    //TableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RestaurantViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
}


#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Restaurant TableView Methods Population
//TODO: Populate table with data!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 60.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RestaurantTableViewCell* cell = (RestaurantTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:RestaurantCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    //If is the last cell remove the separator line
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        [cell hideSeparatorLine];
    } else {
        [cell showSeparatorLine];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Here you do the transition to menu screen
    
    
}

#pragma mark End -



#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -


@end
