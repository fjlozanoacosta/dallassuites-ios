//
//  ViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/24/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    
    //Main View
        //Button Lines Dividers
            //Upper LogIn Btn Divider
    __weak IBOutlet UIView *upperLogInBtnLine;
        //Buttons
            //LogIn (Iniciar Sesion)
    __weak IBOutlet UIButton *logInBtn; //TEMPORARY!!
            //Room (Habitación)
    __weak IBOutlet UIButton *roomsBtn;
            //Service (Servicio)
    __weak IBOutlet UIButton *servicesBtn;
            //Register-Profile (Registrar-Perfil)
    __weak IBOutlet UIButton *registerProfileBtn;
    
    
    //PopUp (pU)
    __weak IBOutlet UIView *pUViewContainer;
    
        //Frame - Form
    __weak IBOutlet UIView *pUFrameView;
    
        //Text Fields
            //Username (Usuario)
    __weak IBOutlet UITextField *pUUsernameTextField;
            //Password (Contraseña)
    __weak IBOutlet UITextField *pUPasswordTextField;
    
        //Buttons
            //LogIn Btn (Iniciar Sesión)
    __weak IBOutlet UIButton *pULogInBtn;
            //Forgot Password Btn (Recuperar Contraseña)
    __weak IBOutlet UIButton *pUForgotPasswordBtn;
            //Close PopUp Btn (Cerrar)
    __weak IBOutlet UIButton *pUCloseBtn;
    
    
    
    //Validation vars!
    BOOL isPopUpDisplayed;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#warning TODO: Check For User
    //Here is where the code that checks if there's an user logged in and changes the register bttn acordingly!!
    if(false){
        [registerProfileBtn setTitle:@"PERFIL" forState:UIControlStateNormal];
        [registerProfileBtn setTag:1];
        upperLogInBtnLine.hidden = logInBtn.hidden = YES;
    }
    
}

#pragma mark - Main View Methods -
#pragma mark - Buttons Actions

- (IBAction)displayLogInPopUp:(UIButton *)sender {

    if (isPopUpDisplayed) {
        return;
    }
    isPopUpDisplayed = YES;
    
    CATransform3D transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .5f, .5f, 1.f);
    [pUFrameView.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeRotation(0, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
       
        [pUViewContainer setAlpha:1.f];
        [pUFrameView.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark End -

#pragma mark - Pop Up Methods -
#pragma mark - Buttons Actions


- (IBAction)closeDisplayedLogInPopUp:(UIButton *)sender {
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.5f, 1.5f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [pUViewContainer setAlpha:.0f];
        [pUFrameView.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        pUUsernameTextField.text = pUPasswordTextField.text = @"";
        
        isPopUpDisplayed = NO;
        
    }];
    
}


#pragma mark End -



@end
