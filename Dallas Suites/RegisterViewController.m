//
//  RegisterViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/23/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"
#import "DatePicker.h"
#import "systemCheck.h"
#import "RegisterTutorialViewController.h"
#import "CRToastManager+DallasUse.h"
//#import <sys/utsname.h>

#define monthArray @[@"ENE", @"FEB", @"MAR", @"ABR", @"MAY", @"JUN", @"JUL", @"AGO", @"SEP", @"OCT", @"NOV", @"DIC"]

@interface RegisterViewController () {
    
    __weak IBOutlet UINavigationBar *navBar;
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *lastnameTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UIButton *birthDateBtn;
    __weak IBOutlet UITextField *cedulaTextfield;
    __weak IBOutlet UITextField *usernameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *passwordAgainTextField;
    __weak IBOutlet UITextField *keyWordTextField;
    
    NSString* uglyDate;
    
    __weak IBOutlet UIView *popUpBigContainer;
    __weak IBOutlet UIView *datePickerFrame;
    __weak IBOutlet DatePicker *datePicker;
    
    __weak IBOutlet NSLayoutConstraint *registerBtnBottomConstraint;
    
    BOOL isKeyboardShown,
         isSmallKeyboardFlapShown,
         isPopUpContainerShown,
         validEmail,
         userInfoGotEdited,
         dateSelected;
    
    UIView* toolTip, *overlay;
    BOOL isToolTipShown;
    
    BOOL isOver18;
    __weak IBOutlet UIButton *over18Btn;
    
    CGSize scrollViewContentSize;
    
    UserModel* user;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
    [_scrollView setDelaysContentTouches:NO];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    
    scrollViewContentSize = CGSizeZero;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(scrollViewContentSize.height == 0 && _scrollView.contentSize.height != 0){
        scrollViewContentSize = _scrollView.contentSize;
        scrollViewContentSize.height += 20;
        scrollViewContentSize.width = 0;
    }
    if (scrollViewContentSize.height != 0){
        [_scrollView setContentSize:scrollViewContentSize];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self allTextFieldResignFirstResponder];
    
    if (isToolTipShown) {
        [UIView animateWithDuration:.3f animations:^{
            [toolTip setAlpha:0.f];
        } completion:^(BOOL finished) {
            [overlay removeFromSuperview];
            [toolTip removeFromSuperview];
            isToolTipShown = NO;
        }];
        
    }
    
}

#pragma mark - Button Actions

- (IBAction)displayBirthDatePicker:(id)sender {
    [self allTextFieldResignFirstResponder];
    
    if (isPopUpContainerShown) {
        return;
    }
    isPopUpContainerShown = YES;
    
    CATransform3D transform = CATransform3DMakeScale(.2f, .2f, .2f);
    [datePickerFrame.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeScale(1.f, 1.f, 1.f);
    [UIView animateWithDuration:.5f animations:^{
        [popUpBigContainer setAlpha:1.f];
        [datePickerFrame setAlpha:1.f];
        [datePickerFrame.layer setTransform:revertTransform];
    }];

}

- (IBAction)closeBirthDatePicker:(id)sender {
    isPopUpContainerShown = NO;
    
    CATransform3D transform = CATransform3DMakeScale(.2f, .2f, .2f);
    [UIView animateWithDuration:.5f animations:^{
        [popUpBigContainer setAlpha:.0f];
        [datePickerFrame setAlpha:.0f];
        [datePickerFrame.layer setTransform:transform];
    }];
    
}

- (IBAction)acceptSelectedDateInPicker:(id)sender {
    
    [birthDateBtn setTitle:[self prettyDateStringFromStringDate:[datePicker getDateAsString]]
                  forState:UIControlStateNormal];
    [birthDateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uglyDate = [datePicker getDateAsString];
    
    dateSelected = YES;
    
    [self closeBirthDatePicker:nil];
    
}

- (IBAction)displayKeyWordTip:(UIButton*)sender {
    [self allTextFieldResignFirstResponder];
    
    if (isToolTipShown) {
        return;
    }
    isToolTipShown = YES;
    
    CGPoint point = sender.frame.origin;
    CGFloat width = sender.frame.size.width;
    
    toolTip = [[UIView alloc] initWithFrame:CGRectMake(point.x - 200 + width , point.y -130, 200, 120)];
    [toolTip setBackgroundColor:[UIColor whiteColor]];
    [toolTip setHidden:NO];
    [toolTip setAlpha:0.f];
    [toolTip setClipsToBounds:NO];
    
    CGRect frame = CGRectMake(200 - (width - 10) - 5 , 120 - 13, width - 10, width - 10);
    UIView* toolTipTip = [[UIView alloc] initWithFrame:frame];
    [toolTipTip setBackgroundColor:[UIColor whiteColor]];
    [toolTipTip setHidden:NO];
    [toolTipTip setAlpha:1.f];
    [toolTipTip setTransform:CGAffineTransformMakeRotation(M_PI_4)];
    
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 170, 120)];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setTextColor:[UIColor colorWithRed:233.f/255.f
                                       green:188.f/255.f
                                        blue:149.f/255.f
                                       alpha:1.f]];
    [text setFont:[UIFont fontWithName:@"BrandonGrotesque-Regular" size:15.f]];
    [text setText:@"La Palabra Clave te ayudará a recuperar tu contraseña. Cada contraseña tendrá su palabra clave."];
    [text setNumberOfLines:4];
    [text setAlpha:1.f];
    
    
    [toolTip addSubview:text];
    
    
    //    [_scrollView addSubview:toolTipTip];
    [toolTip addSubview:toolTipTip];
    [_scrollView addSubview:toolTip];
    
    overlay = [[UIView alloc] initWithFrame:self.view.frame];
    [overlay setBackgroundColor:[UIColor clearColor]];
    [overlay setAlpha:1.f];
    
    [self.view addSubview:overlay];
    
    [UIView animateWithDuration:.3f animations:^{
        [toolTip setAlpha:1.f];
    }];
    
    
}

- (IBAction)over18CheckAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    isOver18 = sender.selected;
    
}


- (IBAction)registerButtonAction:(id)sender {
    [self allTextFieldResignFirstResponder];
    
    user = [[UserModel alloc] init];
    
    user.name = nameTextField.text;
    user.lastname = lastnameTextField.text;
    
    user.email = emailTextField.text;
    
    if(emailTextField.text.length == 0){
        //Display Missing Email Msg
//        [self displayErrorMsgAlertViewWithMessage:@"Por favor coloque su correo." withTitle:@"Dato faltante"];
        [CRToastManager showToastWithTitle:@"Por favor coloque su correo." withSubTitle:nil forError:YES];
        return;
    } else if (![self validateEmailWithString:user.email]) {
        //Display wrong Email Msg
//        [self displayErrorMsgAlertViewWithMessage:@"Cuenta de correo invalida. Por favor revise su correo." withTitle:@"Dato errado"];
        [CRToastManager showToastWithTitle:@"Cuenta de correo invalida." withSubTitle:@"Por favor revise su correo." forError:YES];
        return;
    }
    
    user.birthDay = uglyDate;
    
    if (!dateSelected) {
        user.birthDay = @"";
    }
    
//    if (!dateSelected) {
//        //Display missing birthdate
////        [self displayErrorMsgAlertViewWithMessage:@"Por favor seleccione su fecha de nacimiento." withTitle:@"Dato faltante"];
//        [CRToastManager showToastWithTitle:@"Por favor seleccione su fecha de nacimiento." withSubTitle:nil forError:YES];
//        return;
//    }
    
    user.cedula = @(cedulaTextfield.text.integerValue);
    if (!user.cedula) {
        user.cedula = 0;
    }
//    if (cedulaTextfield.text.length == 0){
//        //Display Missing Cedula
////        [self displayErrorMsgAlertViewWithMessage:@"Por favor coloque su cédula." withTitle:@"Dato faltante"];
//        [CRToastManager showToastWithTitle:@"Por favor coloque su cédula." withSubTitle:nil forError:YES];
//        return;
//    } else if (cedulaTextfield.text.length <= 4 && cedulaTextfield.text > 0) {
//        //Display error on cedula field
////        [self displayErrorMsgAlertViewWithMessage:@"Su cédula es invalida." withTitle:@"Dato errado"];
//        [CRToastManager showToastWithTitle:@"Su cédula es invalida." withSubTitle:nil forError:YES];
//        return;
//    }
    
    user.username = usernameTextField.text;
    
    if (user.username.length == 0) {
        //Display missing username
//        [self displayErrorMsgAlertViewWithMessage:@"Por favor coloque un sobrenombre." withTitle:@"Dato faltante"];
        [CRToastManager showToastWithTitle:@"Por favor coloque un usuario." withSubTitle:nil forError:YES];
        return;
    }
    
    user.password = passwordAgainTextField.text;
    
    if (passwordTextField.text.length == 0) {
        //Display Missing password
//        [self displayErrorMsgAlertViewWithMessage:@"Por favor coloque una contraseña." withTitle:@"Dato faltante"];
        [CRToastManager showToastWithTitle:@"Por favor coloque una contraseña." withSubTitle:nil forError:YES];
        return;
    } else if (passwordTextField.text.length > 0 && passwordTextField.text.length <=5){
        //Display password too short msg
//        [self displayErrorMsgAlertViewWithMessage:@"Su contraseña es muy corta. Se recomienda que contenga al menos 6 caracteres alfanumericos." withTitle:@"Dato errado"];
        [CRToastManager showToastWithTitle:@"Su contraseña es muy corta." withSubTitle:@"Se recomienda que contenga al menos 6 caracteres alfanumericos." forError:YES];
        return;
    } else if (![passwordTextField.text isEqualToString:passwordAgainTextField.text]){
        //Display password missmatch msg
//        [self displayErrorMsgAlertViewWithMessage:@"Las contraseñas no coinciden. Por favor revise sus contraseñas." withTitle:@"Dato errado"];
        [CRToastManager showToastWithTitle:@"Las contraseñas no coinciden." withSubTitle:@"Por favor revise sus contraseñas." forError:YES];
        return;
    }
    
    user.keyWord = keyWordTextField.text;
    
    if (user.keyWord.length == 0) {
        //Display missing keyword
//        [self displayErrorMsgAlertViewWithMessage:@"Se recomienda el uso de palabras claves para asociar con sus contraseñas." withTitle:@"Dato faltante"];
        [CRToastManager showToastWithTitle:@"Se recomienda el uso de palabras claves para asociar con sus contraseñas." withSubTitle:nil forError:YES];
        return;
    }

    if (!isOver18) {
        [CRToastManager showToastWithTitle:@"Debe confirmar que es mayor de 18 años." withSubTitle:nil forError:YES];
        return;
    }
    
    
    void (^block)(BOOL, NSString*, NSError*) = ^(BOOL wasUserCreated, NSString* errorMsg, NSError* error) {
        [self.view setUserInteractionEnabled:YES];
        if (error) {
//            [self displayErrorMsgAlertViewWithMessage:@"Problemas registrando el usuario. Verifique su conexión a internet." withTitle:@"Opps"];
            [CRToastManager showToastWithTitle:@"Problemas registrando el usuario." withSubTitle:@"Verifique su conexión a internet." forError:YES];
            return;
        }
        if (errorMsg && !wasUserCreated) {
//            [self displayErrorMsgAlertViewWithMessage:errorMsg withTitle:@"Opps"];
            [CRToastManager showToastWithTitle:errorMsg withSubTitle:nil forError:YES];
            return;
        }
        
//        [self displayErrorMsgAlertViewWithMessage:errorMsg withTitle:@"Yay!"];
        [CRToastManager showToastWithTitle:errorMsg withSubTitle:nil forError:NO];
        
        RegisterTutorialViewController* destination = (RegisterTutorialViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"];
        [destination setUser:user];
        [self.navigationController pushViewController:destination
                                             animated:YES];
        
    };
    
    [self.view setUserInteractionEnabled:NO];
    [user registerUserWithUser:user copletitionHandler:block];
    
    
}

#pragma mark - TextField Methods -
#pragma mark - Utility Methods
-(void)allTextFieldResignFirstResponder{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
}

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark End -
#pragma mark - Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 2) {
        if ([self validateEmailWithString:[textField text]]) {
            validEmail = YES;
        } else {
            validEmail = NO;
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //Validate input on C.I. Field
    if (textField.tag == 4) {
        
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        NSNumberFormatter *formater = [NSNumberFormatter new];
        NSNumber* number = [formater numberFromString:string];
        if ((!number || textField.text.length > 7) && isBackSpace != -8) {
            return NO;
        }
    }
    
    return YES;
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
                                           if ([alert.title isEqualToString:@"Yay!"]) {
                                               //                                               [self.navigationController popViewControllerAnimated:YES];
                                               
                                               RegisterTutorialViewController* destination = (RegisterTutorialViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"];
                                               [destination setUser:user];
                                               [self.navigationController pushViewController:destination
                                                                                    animated:YES];
                                               
                                           } else if ([alert.title isEqualToString:@"Logrado!"]){
                                               //                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                               RegisterTutorialViewController* destination = (RegisterTutorialViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"];
                                               [destination setUser:user];
                                               [self.navigationController pushViewController:destination
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
        RegisterTutorialViewController* destination = (RegisterTutorialViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"];
        [destination setUser:user];
        [self.navigationController pushViewController:destination
                                             animated:YES];
        
    } else if ([alertView.title isEqualToString:@"Logrado!"]){
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        RegisterTutorialViewController* destination = (RegisterTutorialViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"registerTutorialView"];
        [destination setUser:user];
        [self.navigationController pushViewController:destination
                                             animated:YES];
    }
}

#pragma mark End -

#pragma mark - String Styling Method
-(NSString*)prettyDateStringFromStringDate:(NSString*)dateString{
    NSArray* date = [(NSString*)dateString componentsSeparatedByString:@"-"];
    NSString* prettyDateString = [NSString stringWithFormat:@"%@ - %@ - %@", [date objectAtIndex:2], [monthArray objectAtIndex:[(NSString*)[date objectAtIndex:1] intValue] - 1], [date objectAtIndex:0]];
    return prettyDateString;
}


#pragma mark - Status Bar Styling

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation
- (IBAction)navBarbackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Keyboard Methods -
#pragma mark - Keyboard presenting methods

//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    if (isPopUpContainerShown) {
//        return;
//    }
//    
//    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
//    
//    if (isKeyboardShown) {
//        int smallFlapOffset = 29;
////        if ([machineName() isEqualToString:@"iPhone7,1"]) {
////            smallFlapOffset += 6;
////        }
//        if (isSmallKeyboardFlapShown) {
//            isSmallKeyboardFlapShown = NO;
//            registerBtnBottomConstraint.constant -= smallFlapOffset;
//        } else {
//            isSmallKeyboardFlapShown = YES;
//            registerBtnBottomConstraint.constant += smallFlapOffset;
//        }
//        
//        [UIView animateWithDuration:duration animations:^{
//            
//            [UIView setAnimationCurve:curve];
//            [self.view layoutIfNeeded];
//            
//        } completion:nil];
//        
//        return;
//    }
//    isKeyboardShown = YES;
//    
//    
//    if (keyboardRect.size.height <= 225.f) {
//        isSmallKeyboardFlapShown = NO;
//    } else if (keyboardRect.size.height > 225.f) {
//        isSmallKeyboardFlapShown = YES;
//    }
//    
//    
//    registerBtnBottomConstraint.constant += keyboardRect.size.height;
//    
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        [UIView setAnimationCurve:curve];
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    
//    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
//    
//    isKeyboardShown = NO;
//    
//    registerBtnBottomConstraint.constant = 0;
//    
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        [UIView setAnimationCurve:curve];
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}

#pragma mark @ Special Function to get Current Device

//NSString* machineName()
//{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    
//    return [NSString stringWithCString:systemInfo.machine
//                              encoding:NSUTF8StringEncoding];
//}

#pragma mark End -



@end
