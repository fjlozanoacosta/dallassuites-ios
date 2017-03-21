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
#import "SmallMenuTableViewCell.h"


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
        [navBarTitleItem setTitle:[self.drinkSub uppercaseString]];
    } else {
        [navBarTitleItem setTitle:[self.category uppercaseString]];
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
    RestauranItemModel* item = [tableViewElements objectAtIndex:indexPath.row];

    static CGFloat estimatedHeigh;
    static MenuTableViewCell* cell;
    static dispatch_once_t onceToken;
    static NSString* description;
    
    dispatch_once(&onceToken, ^{
        cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MenuCell];
    });
    
    description = item.food_description;
    [cell.menuItemDescriptionLabel setText:description];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    estimatedHeigh = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return estimatedHeigh >= 55 ? estimatedHeigh : 55;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RestauranItemModel* item = [tableViewElements objectAtIndex:indexPath.row];
    
    MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MenuCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    cell.menuItemLabel.text = item.food_product;
    cell.menuItemDescriptionLabel.text = item.food_description;
    
    return cell;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -

@end
