//
//  ViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/24/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "HomeAndServiceViewController.h"

#define servicePopUpTitles @[@"ROOM SERVICE", @"PRIVACIDAD Y SEGURIDAD", @"DOBLE RECEPCIÓN", @"CONFORT Y AMENIDADES"]
#define servicePopUpDescriptions @[ @"Para complementar su estadía, le ofrecemos una gran variedad de platos y una extensa carta de bebidas paraque las disfrute tanto en nuestro Bar/Restaurant, como en la comodidad de su Suite.", @"No sólo la calidad de nuestros servicios nos distinguen, sino también la Privacidad y Seguridad de nuestras instalaciones.", @"Sólo en Dallas Suites Hotel tenemos una Doble Recepción que le garantiza fluidez a su llegada y el menor tiempo de espera posible.", @"Sauna, Vapor, Jacuzzi, Pole Dance, son algunas de las Amenidades que le esperan en nuestras Suites, para que su visita se Única en su Estilo."]
#define servicePopUpIconImageName @[@"roomServiceIcon", @"privacyAndSecurityIcon", @"dobleReceptionIcon", @"comfortIcon"]

@interface HomeAndServiceViewController () {
    
    //Main View
        //Services Nav Bar
    __weak IBOutlet UINavigationBar *servicesNavBar;
    
    __weak IBOutlet UIImageView* bgImage;
    
        //Buttons
            //LogIn (Iniciar Sesion)
    __weak IBOutlet UIButton *logInBtn;
            //LogIn Btn Right Margin Constraint
    __weak IBOutlet NSLayoutConstraint *logInBtnRightMarginConstraint;
            //Room (Habitación)
    __weak IBOutlet UIButton *roomsBtn;
            //Service (Servicio)
    __weak IBOutlet UIButton *servicesBtn;
            //Register-Profile (Registrar-Perfil)
    __weak IBOutlet UIButton *registerProfileBtn;
    
        //Home Buttons Container Constraint
    __weak IBOutlet NSLayoutConstraint *homeButtonsContainerBottomSpaceConstraint;
    
        //Service Buttons Container Constraint
    __weak IBOutlet NSLayoutConstraint *serviceButtonsContainerBottomSpaceConstraint;
    
        //Center Logo Image Constraints
            //Height
    __weak IBOutlet NSLayoutConstraint *logoImageHeightConstraint;
            //Y Position
    __weak IBOutlet NSLayoutConstraint *logoImageYPositionConstraint;
    
    
    // Log In PopUp (pU)
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
    
    // Log In PopUp (pU)
    __weak IBOutlet UIView *sPUViewContainer;
        //Frame
    __weak IBOutlet UIView *sPUFrameView;
        //Service Icon
    __weak IBOutlet UIImageView *sPUServiceIconImage;
        //Service Name
    __weak IBOutlet UILabel *sPUServiceNameLabel;
        //Service Description
    __weak IBOutlet UILabel *sPUServicesDescriptionLabel;
        //Ok PopUp Button
    __weak IBOutlet UIButton *sPUOkBtn;
    
    //Validation vars!
    BOOL isLogInPopUpDisplayed;
    BOOL isServicePopUpDisplayed;
}

@end

@implementation HomeAndServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Service Nav Bar Styling!!!
    [servicesNavBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    servicesNavBar.shadowImage = [UIImage new];
    servicesNavBar.translucent = YES;
    
    [self.navigationController.navigationBar setHidden:YES];
    
    //Service Pop Up Description Label Multiline
    [sPUServicesDescriptionLabel setNumberOfLines:0];
    
#warning TODO: Check For User
    //Here is where the code that checks if there's an user logged in and changes the register bttn acordingly!!
    if(false){
        [registerProfileBtn setTitle:@"PERFIL" forState:UIControlStateNormal];
        [registerProfileBtn setTag:1];
    }
    
}

#pragma mark - Main View Methods -
#pragma mark - Buttons Actions

- (IBAction)displayLogInPopUp:(UIButton *)sender {

    if (isLogInPopUpDisplayed) {
        return;
    }
    isLogInPopUpDisplayed = YES;
    
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

- (IBAction)displayServicesOptionsMenuButtons:(UIButton *)sender {
    
    
    [homeButtonsContainerBottomSpaceConstraint setConstant:-250.f];
    [logInBtnRightMarginConstraint setConstant: -40.f];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [logoImageHeightConstraint setConstant:165.f];
        logoImageYPositionConstraint.constant -= 22;
    }

    
    [UIView animateWithDuration:.4f animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [serviceButtonsContainerBottomSpaceConstraint setConstant:.0f];
        
        [UIView animateWithDuration:.4f animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }];
    
    [UIView animateWithDuration:.8f animations:^{
        [servicesNavBar setAlpha:1.f];
    }];
    
    bgImage.image = [UIImage imageNamed:@"serviceBg"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .8f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [bgImage.layer addAnimation:transition forKey:nil];
    
}


#pragma mark End -

#pragma mark - NavBar Methods -
#pragma mark - Buttons Actions

- (IBAction)serviceNavBarBackBtn:(UIBarButtonItem *)sender {
    
    [serviceButtonsContainerBottomSpaceConstraint setConstant:-250.f];
    

    [UIView animateWithDuration:.4f animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [homeButtonsContainerBottomSpaceConstraint setConstant:.0f];
        [logInBtnRightMarginConstraint setConstant: 10.f];
        
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            [logoImageHeightConstraint setConstant:186.f];
            logoImageYPositionConstraint.constant += 22;
        }
        
        [UIView animateWithDuration:.4f animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }];
    
    [UIView animateWithDuration:.8f animations:^{
        [servicesNavBar setAlpha:0.f];
    }];
    
    bgImage.image = [UIImage imageNamed:@"homeBg"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .8f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [bgImage.layer addAnimation:transition forKey:nil];
    
}


#pragma mark End -


#pragma mark - Log In Pop Up Methods -
#pragma mark - Buttons Actions


- (IBAction)closeDisplayedLogInPopUp:(UIButton *)sender {
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.5f, 1.5f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [pUViewContainer setAlpha:.0f];
        [pUFrameView.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        pUUsernameTextField.text = pUPasswordTextField.text = @"";
        
        isLogInPopUpDisplayed = NO;
        
    }];
    
}


#pragma mark End -

#pragma mark - Service View Methods -
#pragma mark - Buttons Actions


- (IBAction)displayServicePopUp:(UIButton *)sender {
    
    if (isServicePopUpDisplayed) {
        return;
    }
    isServicePopUpDisplayed = YES;
    
    /*
     Set Service popUp Info Acrodingly
    */
    sPUServiceNameLabel.text = [servicePopUpTitles objectAtIndex:sender.tag];
    sPUServicesDescriptionLabel.text = [servicePopUpDescriptions objectAtIndex:sender.tag];
    [sPUServiceIconImage setImage:[UIImage imageNamed:[servicePopUpIconImageName objectAtIndex:sender.tag]]];
        
    CATransform3D transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .5f, .5f, 1.f);
    [sPUFrameView.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeRotation(0, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [sPUViewContainer setAlpha:1.f];
        [sPUFrameView.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark End -

#pragma mark - Service Pop Up Methods -
#pragma mark - Buttons Actions


- (IBAction)closeDisplayedServiePopUp:(UIButton *)sender {
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.5f, 1.5f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [sPUViewContainer setAlpha:.0f];
        [sPUFrameView.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        isServicePopUpDisplayed = NO;
        
    }];
}


#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;

}
#pragma mark End -
@end
