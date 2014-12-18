//
//  LogInViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/18/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "LogInViewController.h"
#import "UserModel.h"
#import "ProfileViewController.h"

#import "systemCheck.h"

@interface LogInViewController () <UITextFieldDelegate>{
    
    __weak IBOutlet UINavigationBar *navBar;
    
    IBOutlet UITextField *usertextField;
    IBOutlet UITextField *passwordTextField;
    
    __weak IBOutlet UIButton *forgotPassowrdBtn;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
    
    UserModel* _user;
}

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    [navBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:20.f],
                                      NSForegroundColorAttributeName : [UIColor colorWithRed:223.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f]}];
    
    NSDictionary* attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:18.f],
                                  NSForegroundColorAttributeName : [UIColor colorWithWhite:1.f alpha:.5f]};
    NSAttributedString* string = [[NSAttributedString alloc] initWithString:@"Sobrenombre ó correo electrónico" attributes:attributes];
    [usertextField setAttributedPlaceholder:string];
    string = [[NSAttributedString alloc] initWithString:@"Contraseña" attributes:attributes];
    [passwordTextField setAttributedPlaceholder:string];
    
    attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:16.f],
                    NSForegroundColorAttributeName : [UIColor colorWithRed:223.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f],
                    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                    NSUnderlineColorAttributeName : [UIColor colorWithRed:223.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f]};
    string = [[NSAttributedString alloc] initWithString:@"Recuperar Contraseña" attributes:attributes];
    [forgotPassowrdBtn setAttributedTitle:string forState:UIControlStateNormal];
    
    attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:16.f],
                    NSForegroundColorAttributeName : [UIColor whiteColor],
                    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                    NSUnderlineColorAttributeName : [UIColor whiteColor]};
    string = [[NSAttributedString alloc] initWithString:@"Recuperar Contraseña" attributes:attributes];
    [forgotPassowrdBtn setAttributedTitle:string forState:UIControlStateHighlighted];
    
    
    _user = [[UserModel alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ChachedUser"]) {
        [usertextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailKey"]];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [usertextField becomeFirstResponder];
    
}


#pragma mark - Button Actions

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Private Methods

- (void)performLogIn{
    
    [activityIndicator startAnimating];
    [UIView animateWithDuration:.3f
                     animations:^{
                         
                         [activityIndicator setAlpha:1.f];

                     }
     ];
    
    UserModel* user = [UserModel new];
    
    [self.view setUserInteractionEnabled:NO];
    
    void (^block)(UserModel*, NSError*) = ^(UserModel* user, NSError* error){
        [self.view setUserInteractionEnabled:YES];
        [activityIndicator stopAnimating];
        [UIView animateWithDuration:.3f
                         animations:^{
                             [activityIndicator setAlpha:.0f];
                         }
         
         ];
        
        
        if (error) {
            [self displayErrorMsgAlertViewWithMessage:@"Ocurrio un error al hacer log in. Revise su conexión a internet." withTitle:@"Oops"];
            return;
        }
        
        if (!user) {
            [self displayErrorMsgAlertViewWithMessage:@"Error de log in, revise su email y/o clave" withTitle:@"Oops"];
            return;
        }
        
        
        _user = user;
        _user.password = @"";
        [[NSUserDefaults standardUserDefaults] setObject:_user.email forKey:@"UserEmailKey"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ChachedUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_user) {
            _user = user;
            
            ProfileViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
            [profile setUser:_user];
            [self.navigationController pushViewController:profile animated:YES];
            return;
        }
        
        
    };
    
    [user performUserLogInWithEmail:usertextField.text
                       withPassword:passwordTextField.text
              withComplitionHandler:block];
}

#pragma mark - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0) {
        [passwordTextField becomeFirstResponder];
    } else {
        // Perform Log In Action
        [textField resignFirstResponder];
        [self performLogIn];
    }
    
    return YES;
}


#pragma mark - Alert Methods
-(void)displayErrorMsgAlertViewWithMessage:(NSString*)msg withTitle:(NSString*)title{
 
    if (!title) {
        title = @"Opps!";
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Continuar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Continuar"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
