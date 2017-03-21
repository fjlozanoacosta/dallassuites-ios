//
//  SevicesPopUpViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/22/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "SevicesPopUpViewController.h"
#import "BTLabel.h"

@interface SevicesPopUpViewController () {
    
    __weak IBOutlet UIView *popUpContainer;
    
    __weak IBOutlet UIView *popUpFrame;
    
    
    __weak IBOutlet UIImageView *iconView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet BTLabel *contentLabel;
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
    [contentLabel setNumberOfLines:0];
    [contentLabel setText:_contentText];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [contentLabel setVerticalAlignment:BTVerticalAlignmentTop];

    


    [iconView setImage:[UIImage imageNamed:_imageName]];

}

- (void)viewWillLayoutSubviews{
//    [contentLabel sizeToFit];
//    CGRect myFrame = contentLabel.frame;
//    // Resize the frame's width to 280 (320 - margins)
//    // width could also be myOriginalLabelFrame.size.width
//    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, 290, myFrame.size.height);
//    contentLabel.frame = myFrame;
//    [self.view updateConstraints];
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
