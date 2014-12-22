//
//  SevicesPopUpViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/22/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "SevicesPopUpViewController.h"

@interface SevicesPopUpViewController () {
    
    __weak IBOutlet UIView *popUpContainer;
    
    __weak IBOutlet UIView *popUpFrame;
    
    
    __weak IBOutlet UIImageView *iconView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *contentLabel;
}

@end

@implementation SevicesPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [titleLabel setText:_titleText];
    [contentLabel setText:_contentText];
    [contentLabel setNumberOfLines:0];
    [iconView setImage:[UIImage imageNamed:_imageName]];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CATransform3D transform = CATransform3DMakeScale(.2f, .2f, .2f);
    [popUpFrame.layer setTransform:transform];
    
    CATransform3D revertTrasnform = CATransform3DMakeScale(1.f, 1.f, 1.f);
    [UIView animateWithDuration:.5f animations:^{
        [popUpContainer setAlpha:1.f];
        [popUpFrame setAlpha:1.f];
        [popUpFrame.layer setTransform:revertTrasnform];
    }];
}


- (IBAction)closePopUp:(id)sender {
    
    CATransform3D transform = CATransform3DMakeScale(.2f, .2f, .2f);
    
    [UIView animateWithDuration:.5f animations:^{
        [popUpContainer setAlpha:.0f];
        [popUpFrame setAlpha:.0f];
        [popUpFrame.layer setTransform:transform];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
