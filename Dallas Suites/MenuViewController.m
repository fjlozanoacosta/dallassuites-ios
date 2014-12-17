//
//  MenuViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/17/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "RestauranItemModel.h"


#define MenuCell @"menuCell"

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UINavigationItem *navBarTitleItem;
    __weak IBOutlet UINavigationBar *navBar;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
    NSArray* tableViewElements;
}


//Main View
//TableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
    tableViewElements = [[NSArray alloc] init];
    if (self.drinkSub) {
        [navBarTitleItem setTitle:self.drinkSub];
    } else {
        [navBarTitleItem setTitle:self.category];
    }
    
    [activityIndicator startAnimating];
    
    RestauranItemModel* item = [[RestauranItemModel alloc] init];
    [item getMenuItemInformationOfCategory:self.category
                                 withDrink:self.drinkSub
                     WithComplitionHandler:^(NSMutableArray * array, NSError * error) {
                         [activityIndicator stopAnimating];
                         [UIView animateWithDuration:.3f
                                          animations:^{
                                              [activityIndicator setAlpha:.0f];
                         }];
                         if (!error) {
                             tableViewElements = array;
                             [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                       withRowAnimation:UITableViewRowAnimationTop];
                         }
    }];
}

#pragma mark - TableView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tableViewElements.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MenuCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    RestauranItemModel* item = [tableViewElements objectAtIndex:indexPath.row];
    
    if (indexPath.row == tableViewElements.count - 1) {
        [cell hideSeparatorLine];
    } else {
        [cell showSeparatorLine];
    }
    
    cell.menuItemLabel.text = item.food_product;
    cell.menuItemDescriptionLabel.text = item.food_description;
    
    return cell;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
