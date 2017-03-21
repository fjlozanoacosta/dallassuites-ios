//
//  ForgotPasswordViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/18/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UserModel.h"
#import "systemCheck.h"
#import "CRToastManager+DallasUse.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate, UIAlertViewDelegate> {
    
    __weak IBOutlet UINavigationBar *navBar;
    
    __weak IBOutlet UITextField *emailTextField;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}

@end

@implementation ForgotPasswordViewController

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
    NSAttributedString* string = [[NSAttributedString alloc] initWithString:@"Correo electrónico" attributes:attributes];
    [emailTextField setAttributedPlaceholder:string];
    
    //Prefill user email if needed
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ChachedUser"]) {
        [emailTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailKey"]];
    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [emailTextField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
}

#pragma mark - Button Actions

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [activityIndicator startAnimating];
    [UIView animateWithDuration:.3f animations:^{
        [activityIndicator setAlpha:1.f];
    }];
    
    [self performForgotPasswordAction:nil];
    
    return YES;
}

#pragma mark - Private Methods

-(IBAction)performForgotPasswordAction:(id)sender{
    [self.view setUserInteractionEnabled:NO];
    
    UserModel* _user = [[UserModel alloc] init];
    [_user recoverUserPasswordWithUserEmail:emailTextField.text withCompletitionHanlder:^(BOOL passwordsReseted, NSString * msg, NSError * error) {
        [self.view setUserInteractionEnabled:YES];
        [activityIndicator stopAnimating];
        [UIView animateWithDuration:.3f animations:^{
            [activityIndicator setAlpha:.0f];
        }];
        
        if (error) {
//            
//            [self displayErrorMsgAlertViewWithMessage:@"Error reestableciendo su(s) contraseña(s). Verifique su conexión a internet."
//                                            withTitle:@"Oops!"];
            [CRToastManager showToastWithTitle:@"Error reestableciendo su(s) contraseña(s)."
                                  withSubTitle:@"Verifique su conexión a internet."
                                      forError:YES];
            
            return ;
        }
        
        NSArray* array = [msg componentsSeparatedByString:@"."];
        [CRToastManager showToastWithTitle:[(NSString*)[array firstObject] stringByAppendingString:@"."]
                              withSubTitle:[(NSString*)[array objectAtIndex:1] stringByAppendingString:@"."]
                                  forError:!passwordsReseted];
        
        if (passwordsReseted) {            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
//        [self displayErrorMsgAlertViewWithMessage:msg
//                                        withTitle:((passwordsReseted)?@"Yay!":@"Oops!")];
        
    }];

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
                                           if ([title isEqualToString:@"Yay!"]) {
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }
                                           
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView.title isEqualToString:@"Yay!"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//-(void)dismissViewControllerAfter


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
