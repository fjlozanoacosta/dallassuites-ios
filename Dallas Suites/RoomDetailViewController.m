//
//  RoomDetailViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/27/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RoomDetailViewController.h"

@interface RoomDetailViewController () {
    
    //Navigation Bar (nav)
        //Bar Itself
    __weak IBOutlet UINavigationBar *navBar;
    
    //Buttons
        //Back Btn
    __weak IBOutlet UIBarButtonItem *navBackBtn;
    
}

@end

@implementation RoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //Nav Bar Styling!!
    [navBar setBackgroundColor:[UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.45f]];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
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
