//
//  AddNewPasswordPopUpViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/22/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "AddNewPasswordPopUpViewController.h"
#import "systemCheck.h"
#import "CRToastManager+DallasUse.h"

@interface AddNewPasswordPopUpViewController () <UITextFieldDelegate> {
    
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePoPUp:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
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
    
    if (passwordTextField.text.length == 0 ) {
//        [self displayErrorMsgAlertViewWithMessage:@"Por favor coloque una contraseña." withTitle:@"Falta contraseña"];
        [CRToastManager showToastWithTitle:@"Por favor coloque una contraseña." withSubTitle:nil forError:YES];
        return;
    } else if (passwordTextField.text > 0 && passwordTextField.text.length <= 5){
//        [self displayErrorMsgAlertViewWithMessage:@"La contraseña es muy corta. Se recomienda minimo 6 caracteres alfanumericos." withTitle:@"Contraseña débil"];
        [CRToastManager showToastWithTitle:@"La contraseña es muy corta." withSubTitle:@"Se recomienda minimo 6 caracteres alfanumericos." forError:YES];
        return;
    } else if (![passwordTextField.text isEqualToString:passwordAgainTextField.text]){
//        [self displayErrorMsgAlertViewWithMessage:@"Las contraseñas no coinciden. Por favor revise sus contraseñas." withTitle:@"Opps"];
        [CRToastManager showToastWithTitle:@"Las contraseñas no coinciden." withSubTitle:@"Por favor revise sus contraseñas." forError:YES];
        return;
    }
    
    if (keyWordTextField.text.length == 0) {
//        [self displayErrorMsgAlertViewWithMessage:@"Se recomienda el uso de una plabra clave asociada a las contraseñas." withTitle:@"Falta palabra clave"];
        [CRToastManager showToastWithTitle:@"Se recomienda el uso de una plabra clave asociada a las contraseñas." withSubTitle:nil forError:YES];
        return;
    }
    
    __strong id strongSelf = self;
    [_user addPasswordToUser:_user withNewPassword:passwordTextField.text withKeyWord:keyWordTextField.text copletitionHandler:^(NSInteger passwordAdded, NSString * msg, NSError * error) {
        if (error) {
//            [strongSelf displayErrorMsgAlertViewWithMessage:@"Problemas agregando la contraseña nueva. Revise su conexión a internet." withTitle:@"Opps"];
            [CRToastManager showToastWithTitle:@"Problemas agregando la contraseña nueva." withSubTitle:@"Revise su conexión a internet." forError:YES];
            return;
        }
        
        if (passwordAdded == kErrorAddingNewPassword) {
//            [strongSelf displayErrorMsgAlertViewWithMessage:msg withTitle:@"Opps"];
            [CRToastManager showToastWithTitle:msg withSubTitle:nil forError:YES];
            return;
        }
        
        [strongSelf closePoPUp:nil];

    }];
    
//    [self closePoPUp:nil];
    
    
}

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
                                           if ([alert.title isEqualToString:@"Yay!"]) {
                                               //                                               [self.navigationController popViewControllerAnimated:YES];
                                               [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"]
                                                                                    animated:YES];
                                               
                                           } else if ([alert.title isEqualToString:@"Logrado!"]){
                                               //                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                               [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"]
                                                                                    animated:YES];
                                           }
                                       }];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Yay!"]) {
        //        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"]
                                             animated:YES];
        
    } else if ([alertView.title isEqualToString:@"Logrado!"]){
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"]
                                             animated:YES];
    }
}

#pragma mark End -

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
