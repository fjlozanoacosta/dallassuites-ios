//
//  ViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/24/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "HomeAndServiceViewController.h"
#import "UserModel.h"
#import "ProfileViewController.h"
#import "systemCheck.h"


//Segues
#define goToProfile @"toProfileView"
#define goToRegister @"toRegisterView"
#define allSegues @[ goToRegister, goToProfile ]

#define servicePopUpTitles @[@"ROOM SERVICE", @"PRIVACIDAD Y SEGURIDAD", @"DOBLE RECEPCIÓN", @"CONFORT Y AMENIDADES"]
#define servicePopUpDescriptions @[ @"Para complementar su estadía, le ofrecemos una gran variedad de platos y una extensa carta de bebidas para que las disfrute tanto en nuestro bar/restaurant, como en la comodidad de su Suite.", @"No sólo la calidad de nuestros servicios nos distinguen, sino también la privacidad y seguridad de nuestras instalaciones.", @"Sólo en Dallas Suites Hotel tenemos una doble recepción que le garantiza fluidez a su llegada y el menor tiempo de espera posible.", @"Sauna, vapor, jacuzzi, pole dance, son algunas de las amenidades que le esperan en nuestras Suites, para que su visita se única en su estilo."]
#define servicePopUpIconImageName @[@"roomServiceIcon", @"privacyAndSecurityIcon", @"dobleReceptionIcon", @"comfortIcon"]

@interface HomeAndServiceViewController () <UITextFieldDelegate, UIAlertViewDelegate> {
    
    //Main View
        //Services Nav Bar
    __weak IBOutlet UINavigationBar *servicesNavBar;
    
    __weak IBOutlet UIImageView* bgImage;
    __weak IBOutlet UIImageView *temporaryBgLayer;
    
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
    
    //User
    UserModel* _user;
    
    CGFloat logoYOriginalOrigin;
    BOOL notFirstTime;
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
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ChachedUser"]){
        _user = [UserModel new];
        _user.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailKey"];
//        [self setUserIsPreLoggedIn];
    }
    
    logoYOriginalOrigin = logoImageYPositionConstraint.constant;
    [homeButtonsContainerBottomSpaceConstraint setConstant:-250.f];
    [logoImageYPositionConstraint setConstant:.0f];
    [self.view layoutIfNeeded];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (notFirstTime) {
        return;
    }
    [homeButtonsContainerBottomSpaceConstraint setConstant:.0f];
    [logoImageYPositionConstraint setConstant:125.f];
    [UIView animateWithDuration:.8f
                          delay:.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [temporaryBgLayer setAlpha:.0f];
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         notFirstTime = YES;
                     }
     ];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self allTextFieldResignFirstResponder];
}

#pragma mark - Main View Methods -
#pragma mark - Buttons Actions

- (IBAction)displayServicesOptionsMenuButtons:(UIButton *)sender {
    
    
    [homeButtonsContainerBottomSpaceConstraint setConstant:-250.f];
//    [logInBtnRightMarginConstraint setConstant: -40.f];
    
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

- (IBAction)goToRegisterOrProfileView:(UIButton*)sender {
    
    [self performSegueWithIdentifier:[allSegues objectAtIndex:sender.tag] sender:sender];
    
}

#pragma mark End -
#pragma mark - Methods

-(void)setUserIsPreLoggedIn{
    [logInBtn setHidden:YES];
    [registerProfileBtn setTitle:@"PERFIL" forState:UIControlStateNormal];
    [registerProfileBtn setTag:1];
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
//        [logInBtnRightMarginConstraint setConstant: 10.f];
        
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
        
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .2f, .2f, 1.f);
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
    transform = CATransform3DScale(transform, .2f, .2f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [sPUViewContainer setAlpha:.0f];
        [sPUFrameView.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        isServicePopUpDisplayed = NO;
        
    }];
}


#pragma mark End -

#pragma mark - TextField Methods -
#pragma mark - Utility Methods
-(void)allTextFieldResignFirstResponder{
}
#pragma mark End -
#pragma mark - Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;

}
#pragma mark End -

#pragma mark - Prepare For Segue -
#pragma mark - Pass User
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:goToProfile]) {
        ProfileViewController* destination = (ProfileViewController*)[segue destinationViewController];
        destination.user = _user;
    }
}
#pragma mark End -

#pragma mark - AlertView -
#pragma mark - Display Alert View

- (void)displayErrorMsgAlertViewWithMessage:(NSString*)message withTitle:(NSString*)title{
    
    if (!title) {
        title = @"Opps!";
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Continuar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles: nil];
        [alert show];
    }
    

    
}

#pragma mark End -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}
@end
