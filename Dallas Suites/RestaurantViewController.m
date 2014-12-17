//
//  RestaurantViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantTableViewCell.h"
#import "BeveragesTableViewCell.h"
#import "MenuViewController.h"

#define RestaurantCell @"restaurantCell"
#define BeverageCell @"beverageCell"

#define restaurantElementsTitles @[ @"Desayuno", @"Ensaladas", @"De picar", @"Sandwiches", @"Pizzas", @"A la plancha", @"Parrilla", @"Snacks 24 horas", @"Bebidas" ]
#define restaurantBeverages @[ @"Champagne", @"Espumantes", @"Vinos", @"Whiskies", @"Rones", @"Vodka", @"Gyn", @"Aperitivos y tragos preparados", @"Cocktails", @"Batidos", @"Café y té", @"Otras" ]
#define lastRestaurantElement @[ @"Postres" ]
#define tableViewData @[ restaurantElementsTitles, restaurantBeverages, lastRestaurantElement, @[] ]
#define restaurantIconsImageName @[ @"restaurantBreakfastIcon", @"restaurantSalatIcon", @"restaurantSnackIcon", @"restaurantSandwichIcon", @"restaurantPizzaIcon", @"restaurantLunchIcon", @"restaurantGrillIcon", @"restaurant24HoursSnackIcon", @"restaurantDrinkIcon", @"restaurantDessertIcon" ]


@interface MenuPreparationObject : NSObject {
    @public
    NSString * category;
    NSString * drinkSub;
}

@end

@implementation MenuPreparationObject



@end

typedef enum {
    kRestaurant,
    kWithBeverages
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

    switch (section) {
        case 0:
            return restaurantElementsTitles.count;
            break;
        case 1:
            return (tableViewElementControl == kWithBeverages)? restaurantBeverages.count : 0;
            break;
    }
    
    return lastRestaurantElement.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section == 0) {
        RestaurantTableViewCell* rCell = (RestaurantTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:RestaurantCell];
        [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [[rCell restaurantItemLabel] setText:[restaurantElementsTitles objectAtIndex:indexPath.row]];
        [[rCell iconImage] setImage:[UIImage imageNamed:[restaurantIconsImageName objectAtIndex:indexPath.row]]];
        [rCell.restaurantItemLabel setTextColor:[UIColor whiteColor]];
        
        [rCell showSeparatorLine];
        
        if (indexPath.row == restaurantElementsTitles.count - 1 && tableViewElementControl == kWithBeverages) {
            [rCell hideSeparatorLine];
            [rCell.restaurantItemLabel setTextColor:[UIColor colorWithRed:223.f/255.f
                                                                    green:188.f/255.f
                                                                     blue:149.f/255.f
                                                                    alpha:1.f]];
        }
        
        return rCell;
    } else if (indexPath.section == 1){
        BeveragesTableViewCell* bCell = [tableView dequeueReusableCellWithIdentifier:BeverageCell];
        [bCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [bCell.beverageLabel setText:[restaurantBeverages objectAtIndex:indexPath.row]];
        
        return bCell;   
    }
    
    RestaurantTableViewCell* rCell = (RestaurantTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:RestaurantCell];
    [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [[rCell restaurantItemLabel] setText:[lastRestaurantElement objectAtIndex:indexPath.row]];
    [[rCell iconImage] setImage:[UIImage imageNamed:[restaurantIconsImageName lastObject]]];
    [rCell.restaurantItemLabel setTextColor:[UIColor whiteColor]];
    
    //If is the last cell remove the separator line
    [rCell hideSeparatorLine];
    
    return rCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == restaurantElementsTitles.count - 1) {
        tableViewElementControl = (tableViewElementControl == kWithBeverages)? kRestaurant : kWithBeverages;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                 withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView reloadData];
        return;
    }
    
    MenuPreparationObject* senderObject = [[MenuPreparationObject alloc] init];
    switch (indexPath.section) {
        case 0:
        case 2:
            senderObject->category = [[(RestaurantTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] restaurantItemLabel] text];
            senderObject->drinkSub = nil;
            break;
        default:
            senderObject->category = @"bebida";
            senderObject->drinkSub = [[(BeveragesTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] beverageLabel] text];
            break;
    }
    [self performSegueWithIdentifier:@"toMenuSegue" sender:senderObject];
    
    
}


#pragma mark End -



#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MenuPreparationObject*)sender{
    if (sender) {
        MenuViewController* destination = [segue destinationViewController];
        destination.category = sender->category;
        destination.drinkSub = sender->drinkSub;
    }
}

#pragma mark End -


@end
