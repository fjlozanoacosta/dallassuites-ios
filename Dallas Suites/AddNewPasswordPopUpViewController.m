//
//  AddNewPasswordPopUpViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/22/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "AddNewPasswordPopUpViewController.h"

@interface AddNewPasswordPopUpViewController () {
    
    __weak IBOutlet UITextField *passwordTextField;
    
    __weak IBOutlet UITextField *passwordAgainTextField;
    __weak IBOutlet UITextField *keyWordTextField;
    
    
    __weak IBOutlet UIView *popUpBigContainer;
    __weak IBOutlet UIView *popUpFrameContainer;
    
}

@end

@implementation AddNewPasswordPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view setAlpha:1.f];
    
    CATransform3D transform = CATransform3DMakeScale(.2f, .2f, 1.f);
    [popUpFrameContainer.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeScale(1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        [popUpBigContainer setAlpha:1.f];
        [popUpFrameContainer setAlpha:1.f];
        [popUpFrameContainer.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];

    
}

- (IBAction)closePoPUp:(id)sender {
    
    [self.view setAlpha:1.f];
    
    CATransform3D transform = CATransform3DMakeScale(.2f, .2f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        [popUpBigContainer setAlpha:.0f];
        [popUpFrameContainer setAlpha:.0f];
        [popUpFrameContainer.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
    
}

- (IBAction)addnewPassword:(id)sender {
    [self closePoPUp:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
