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
#import "SevicesPopUpViewController.h"


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

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self performSegueWithIdentifier:@"toServicesPopUp" sender:sender];
    } else {
        
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        SevicesPopUpViewController* vC = (SevicesPopUpViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"servicesPopUpViewController"];
        
        NSInteger tag = [sender tag];
        vC.titleText = [servicePopUpTitles objectAtIndex:tag];
        vC.contentText = [servicePopUpDescriptions objectAtIndex:tag];
        vC.imageName = [servicePopUpIconImageName objectAtIndex:tag];
        
        [self presentViewController:vC
                           animated:YES
                         completion:^{
                         }
         ];
    }
    
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
    } else if ([segue.identifier isEqualToString:@"toServicesPopUp"]){
        SevicesPopUpViewController* destination = (SevicesPopUpViewController*)[segue destinationViewController];
        NSInteger tag = [(UIButton*)sender tag];
        /*
         Set Service popUp Info Acrodingly
         */
        destination.titleText = [servicePopUpTitles objectAtIndex:tag];
        destination.contentText = [servicePopUpDescriptions objectAtIndex:tag];
        destination.imageName = [servicePopUpIconImageName objectAtIndex:tag];

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
