//
//  NavigationViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/31/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

// This class is needed so the status bar can be set to white!

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews{
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -

@end
