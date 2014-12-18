//
//  RoomDetailViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/27/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RoomDetailViewController.h"

@interface RoomDetailViewController () <UIWebViewDelegate>{
    
    //Main View
        //360 Room WebView
    __weak IBOutlet UIWebView *room360WebView;

    
    //Navigation Bar (nav)
        //Bar Itself
    __weak IBOutlet UINavigationBar *navBar;
    __weak IBOutlet UINavigationItem *navBarTitle;
    
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
    [navBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:20.f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //NSLog(@"New Title : %@", _navTitle);
    //NSLog(@"Old Title : %@", navBarTitle.title);
    
    //Change room Title    
    [navBarTitle setTitle:_navTitle];
    
    //NSLog(@"Did the Title change? : %@", navBarTitle.title);
    
    
    NSString *urlAddress = _roomWebAddress;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [room360WebView loadRequest:requestObj];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}




#pragma mark End -

#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
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
