//
//  RoomsViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/27/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RoomsViewController.h"
#import "RoomsTableViewCell.h"


//Constants
#define RoomCell @"roomCell"

@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate>{
    
    
    //Main View
    
    
    //Navigation Bar (nav)
        //Bar Itself
    __weak IBOutlet UINavigationBar *navBar;
    
        //Buttons
            //Back Btn
    __weak IBOutlet UIBarButtonItem *navBackBtn;
    

    
    
}
//Main View
    //TableView
@property (weak, nonatomic) IBOutlet UITableView *_tableView;

@end

@implementation RoomsViewController
@synthesize _tableView = __tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Styling 
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Room TableView Methods Population
//TODO: Populate table with data!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RoomsTableViewCell* cell = [__tableView dequeueReusableCellWithIdentifier:RoomCell];
    
    
    
    return cell;
}

#pragma mark End -

#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

#pragma mark End -


@end
