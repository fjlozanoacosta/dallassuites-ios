//
//  RegisterTutorialViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/22/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RegisterTutorialViewController.h"
#import "ProfileViewController.h"

@interface RegisterTutorialViewController () {
    
    __block BOOL doneWithLogIn, userClickedContinue;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

@end

@implementation RegisterTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    doneWithLogIn = NO;
    userClickedContinue = NO;
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    void (^block)(UserModel*, NSError*) = ^(UserModel* user, NSError* error){
        [self.view setUserInteractionEnabled:YES];
        [activityIndicator stopAnimating];
        [UIView animateWithDuration:.3f
                         animations:^{
                             [activityIndicator setAlpha:.0f];
                         }
         
         ];
        
        
        if (error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self displayErrorMsgAlertViewWithMessage:@"Ocurrio un error al hacer log in. Revise su conexión a internet." withTitle:@"Oops"];
            return;
        }
        
        if (!user) {
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self displayErrorMsgAlertViewWithMessage:@"Error de log in, revise su email y/o clave" withTitle:@"Oops"];
            return;
        }
        
        
        _user = user;
        doneWithLogIn = YES;
        //        _user.password = @"";
        [[NSUserDefaults standardUserDefaults] setObject:_user.email forKey:@"UserEmailKey"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ChachedUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (userClickedContinue) {
            _user = user;
            
            ProfileViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
            [profile setUser:_user];
            [self.navigationController pushViewController:profile animated:YES];
            return;
        }
        
        
    };
    
    [_user performUserLogInWithEmail:_user.email
                       withPassword:_user.password
              withComplitionHandler:block];
}


- (IBAction)goHomeBtnAction:(id)sender {
    if (doneWithLogIn) {
        ProfileViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        [profile setUser:_user];
        [self.navigationController pushViewController:profile animated:YES];
        return;
    } else {
        [activityIndicator startAnimating];
        [UIView animateWithDuration:.3f animations:^{
            [activityIndicator setAlpha:1.f];
        }];
        userClickedContinue = YES;
        [self.view setUserInteractionEnabled:NO];
        
    }
    
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
