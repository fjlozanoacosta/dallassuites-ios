//
//  RestaurantViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantTableViewCell.h"
#import "MenuTableViewCell.h"

#define RestaurantCell @"restaurantCell"
#define MenuCell @"menuCell"

typedef enum {
    kRestaurant,
    kMenu
} tableViewElements;

@interface RestaurantViewController () <UITableViewDataSource, UITableViewDelegate>{
    
    //Main View
        //Background Image
    __weak IBOutlet UIImageView *bgImage;
        //NavBar
    __weak IBOutlet UINavigationBar *navBar;
        //NavBar Title
    __weak IBOutlet UINavigationItem *navBarTitle;
    
    
    //Control Variables
    NSInteger tableViewElementControl;
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
    
    //Variable to keep control if tableview is displaying restaurant options or menu items
    tableViewElementControl = kRestaurant;
}


#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Restaurant TableView Methods Population
//TODO: Populate table with real data!!!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableViewElementControl == kMenu) {
        //Here you return number of elements in selected restaurant item
        return 5;
    }
    
    //Here you return number of element in restaurant View
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableViewElementControl == kMenu) {
        return 95.f;
    }
    
    return 60.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableViewElementControl == kMenu) {
        //Return Menu Cell
        MenuTableViewCell* mCell = (MenuTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:MenuCell];
        [mCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        //If is the last cell remove the separator line
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            [mCell hideSeparatorLine];
        } else {
            [mCell showSeparatorLine];
        }
        
        return mCell;
    }
    
    RestaurantTableViewCell* rCell = (RestaurantTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:RestaurantCell];
    [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    //If is the last cell remove the separator line
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        [rCell hideSeparatorLine];
    } else {
        [rCell showSeparatorLine];
    }
    
    return rCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Here you do the transition to menu screen
    
    if (tableViewElementControl == kRestaurant) {
        //Use indexPath.row to get the element selected and load inner item elements and display them accordingly
        
        [UIView animateWithDuration:.25f animations:^{
            [navBar setAlpha:.0f];
        } completion:^(BOOL finished) {
           navBarTitle.title = @"AQUI TITULO ITEM"; // Here's where you get the selected items name and change nav bar name accordingly
           [UIView animateWithDuration:.25f animations:^{
               [navBar setAlpha:1.0f];
           }];
        }];
        
//        CATransform3D zoom = CATransform3DMakeScale(1.25f, 1.25f, 1.25f);
//        zoom = CATransform3DTranslate(zoom, -20.f, -40.f, .0f);
//        [UIView animateWithDuration:.5f animations:^{
//            [bgImage.layer setTransform:zoom];
//        }];
        
        tableViewElementControl = kMenu; //This now sets the tableview to display menu items
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft]; //This forces a table reload to put in the new info
        
        [_tableView setContentOffset:CGPointMake(.0f, .0f)];
        
        return; //So the method does not keep excecuting
        
        //All this should be done async and an activity indicator should be added
    } else if (tableViewElementControl == kMenu) {
        
        //Whatever has to happen when a menu element is selected
        //If nothing has to happen, then nothing goes here
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableViewElementControl == kRestaurant) {
        [(RestaurantTableViewCell*)cell tablleViewWillDisplayCellAnimationWithAnimationNumber:0];

        
        
    }
    

    
}

#pragma mark End -



#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
    
    if (tableViewElementControl == kMenu) {
        //Here you animate back to restaurant list
        
        tableViewElementControl = kRestaurant;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        [UIView animateWithDuration:.25f animations:^{
            [navBar setAlpha:.0f];
        } completion:^(BOOL finished) {
            navBarTitle.title = @"RESTAURANTE";
            [UIView animateWithDuration:.25f animations:^{
                [navBar setAlpha:1.0f];
            }];
        }];
        
//        CATransform3D unZoom = CATransform3DMakeScale(1.f, 1.f, 1.f);
//        [UIView animateWithDuration:.5f animations:^{
//           [bgImage.layer setTransform:unZoom];
//        }];
        
        [_tableView setContentOffset:CGPointMake(.0f, .0f)];
        
        return;
    }
    
//    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -


@end
