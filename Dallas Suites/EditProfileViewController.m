//
//  EditProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/19/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "EditProfileViewController.h"
#import "DatePicker.h"
#import "systemCheck.h"
#import "CRToastManager+DallasUse.h"



#define monthArray @[@"ENE", @"FEB", @"MAR", @"ABR", @"MAY", @"JUN", @"JUL", @"AGO", @"SEP", @"OCT", @"NOV", @"DIC"]

@interface EditProfileViewController () <UITextFieldDelegate> {
    
    __weak IBOutlet UINavigationBar *navBar;
    
//    __weak IBOutlet UILabel *nicknameLabel;
//    __weak IBOutlet UITextField *nameLastnameTextfield;
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *lastNameTextField;
    __weak IBOutlet UITextField *keyWordTextField;
    __weak IBOutlet UITextField *idTextField;
    
    
    __weak IBOutlet UIButton *birthDateButton;
    __weak IBOutlet UIButton *changePasswordBtn;
    
    NSString* birthDateUglyString;
    
    //Pop Ups
    
    __weak IBOutlet UIView *popUpcontainer;
    
    __weak IBOutlet UIView *editPasswordContainer;
    __weak IBOutlet UITextField *editPasswordTextField;
    __weak IBOutlet UITextField *editConfirmPasswordTextField;
    
    
    __weak IBOutlet NSLayoutConstraint *saveBtnBottomConstraint;
    
    __weak IBOutlet UIView *editBirthDateContainer;
    __weak IBOutlet DatePicker *datePicker;
    
    
    BOOL isPopUpContainerShown;
    int wichContainerIsShown; // 1 = Birthday / 2 = Change Password / 0 = None
    BOOL isKeyboardShown;
    
    CGRect offsetRect;
    
    UIView* toolTip, *overlay;
    BOOL isToolTipShown;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_scrollView setDelaysContentTouches:NO];
    
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
    [self styleTextFieldsButtonsAndNameLabel];
   
    [self loadUserInfoToFields];
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closePopUp:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
}

-(void)viewDidLayoutSubviews{
    
    [_scrollView setContentSize:CGSizeMake(0, 350)];
}
- (IBAction)resignTextFieldsResponder:(id)sender {
    [self allTextFieldResignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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

#pragma mark - Private Styling Methods
-(void)styleTextFieldsButtonsAndNameLabel{
    //TextField Styling
    NSDictionary* attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:18.f],
                                  NSForegroundColorAttributeName : [UIColor colorWithWhite:1.f alpha:.5f]};
    NSAttributedString* string = [[NSAttributedString alloc] initWithString:@"Apellido" attributes:attributes];
    [lastNameTextField setAttributedPlaceholder:string];
    
    string = [[NSAttributedString alloc] initWithString:@"Nombre" attributes:attributes];
    [nameTextField setAttributedPlaceholder:string];
    
    string = [[NSAttributedString alloc] initWithString:@"Palabra clave" attributes:attributes];
    [keyWordTextField setAttributedPlaceholder:string];
    string = [[NSAttributedString alloc] initWithString:@"Cédula" attributes:attributes];
    [idTextField setAttributedPlaceholder:string];

    
}

-(void)styleUserNameAndNicknameWith:(NSString*)name withLastName:(NSString*)lastname withNickname:(NSString*)nickname{
    
    [nameTextField setText:name];
    [lastNameTextField setText:lastname];
    
//    nickname = [NSString stringWithFormat:@"%@ | ", nickname];
//    
//    [nicknameLabel setText:nickname];
//    
//    name = [NSString stringWithFormat:@"%@ %@", name, lastname];
//    
//    [nameLastnameTextfield setText:name];
    
}

-(void)loadUserInfoToFields{
    [self styleUserNameAndNicknameWith:_user.name withLastName:_user.lastname withNickname:_user.username];
    [keyWordTextField setText:_user.keyWord];
    [birthDateButton setTitle:[self prettyDateStringFromStringDate:_user.birthDay] forState:UIControlStateNormal];
    birthDateUglyString = _user.birthDay;
    [idTextField setText:[NSString stringWithFormat:@"%i", _user.cedula.intValue]];
    if (!_user.cedula || _user.cedula == 0) {
        [idTextField setText:@""];
    }
    [keyWordTextField setText:_user.keyWord];
//    [changePasswordBtn setTitle:_user.password forState:UIControlStateNormal];
}

-(NSString*)prettyDateStringFromStringDate:(NSString*)dateString{
    if ([dateString isEqualToString:@"0000-00-00"]) {
        return @"Fecha de nacimiento";
    }
    
    NSArray* date = [(NSString*)dateString componentsSeparatedByString:@"-"];
    NSString* prettyDateString = [NSString stringWithFormat:@"%@ - %@ - %@", [date objectAtIndex:2], [monthArray objectAtIndex:[(NSString*)[date objectAtIndex:1] intValue] - 1], [date objectAtIndex:0]];
    return prettyDateString;
}



#pragma mark - Button Action
- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveProfileEditAction:(id)sender {
    [self allTextFieldResignFirstResponder];
    
//    NSArray* nameLastname = [nameLastnameTextfield.text componentsSeparatedByString:@" "];
//    if (nameLastname.count == 0) {
//        _user.name = @"";
//        _user.lastname = @"";
//    } else if (nameLastname.count == 1){
//        _user.name = [nameLastname firstObject];
//        _user.lastname = @"";
//    } else if (nameLastname.count == 2){
//        _user.name = [nameLastname firstObject];
//        _user.lastname = [nameLastname lastObject];
//    } else if (nameLastname.count > 2){
//        [self displayErrorMsgAlertViewWithMessage:@"Coloque solo su primer nombre y primer apellido." withTitle:@"Error en el nombre"];
//        return;
//    }
    
    _user.name = nameTextField.text;
    _user.lastname = lastNameTextField.text;
    
//    if (idTextField.text.length == 0) {
////        [self displayErrorMsgAlertViewWithMessage:@"Por favor coloque su cédula." withTitle:@"Falta cédula"];
//        [CRToastManager showToastWithTitle:@"Por favor coloque su cédula." withSubTitle:nil forError:YES];
//        return;
//    } else if (idTextField.text.length > 0 && idTextField.text.length <= 4){
////        [self displayErrorMsgAlertViewWithMessage:@"Su cédula no es valida. Por favor revise su cédula." withTitle:@"Error en cédula"];
//        [CRToastManager showToastWithTitle:@"Su cédula no es valida. Por favor revise su cédula." withSubTitle:nil forError:YES];
//        return;
//    }
    
    _user.cedula = @(idTextField.text.integerValue);
    if (!_user.cedula) {
        _user.cedula = 0;
    }
    
    _user.birthDay = birthDateUglyString;

    if (_user.birthDay.length == 0) {
        _user.birthDay = @"";
    }
    
    if (keyWordTextField.text.length == 0) {
//        [self displayErrorMsgAlertViewWithMessage:@"Se recomienda el uso de una palabra clave asociada con la contraseña." withTitle:@"Falta palabra clave"];
        [CRToastManager showToastWithTitle:@"Se recomienda el uso de una palabra clave asociada con la contraseña." withSubTitle:nil forError:YES];
        return;
    }
    
    _user.keyWord = keyWordTextField.text;
    
    [self.view setUserInteractionEnabled:NO];
    
    __strong UINavigationController* strongNavController = self.navigationController;
    [_user updateUserInfoWithUser:_user copletitionHandler:^(BOOL userUpdated, NSString * msg, NSError * error) {
        [self.view setUserInteractionEnabled:YES];
        if (error) {
            NSLog(@"Error");
//            [self displayErrorMsgAlertViewWithMessage:@"Error actualizando su información. Revise su conexión a internet." withTitle:@"Opps"];
            [CRToastManager showToastWithTitle:@"Error actualizando su información. Revise su conexión a internet." withSubTitle:nil forError:YES];
            return;
        }
        
        if (!userUpdated) {
//            [self displayErrorMsgAlertViewWithMessage:msg withTitle:@"Opps"];
            [CRToastManager showToastWithTitle:msg withSubTitle:nil forError:YES];
            return;
        }
        [CRToastManager showToastWithTitle:msg withSubTitle:nil forError:NO];
        [strongNavController popViewControllerAnimated:YES];
        NSLog(@"Success");
    }];
    
}


#pragma mark - PopUp Display Methods

-(IBAction)displaySelectBirthDayPopUp:(id)sender {
    [self allTextFieldResignFirstResponder];
    
    if (isPopUpContainerShown) {
        return;
    }
    
    [self allTextFieldResignFirstResponder];
    
    isPopUpContainerShown = YES;
    wichContainerIsShown = 1;
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .2f, .2f, 1.f);
    [editBirthDateContainer.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeRotation(0, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpcontainer setAlpha:1.f];
        [editBirthDateContainer setAlpha:1.f];
        [editBirthDateContainer.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(IBAction)displayAddNewPasswordPopUp:(id)sender {
    
    [self allTextFieldResignFirstResponder];
    isPopUpContainerShown = YES;
    wichContainerIsShown = 2;
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .2f, .2f, 1.f);
    [editPasswordContainer.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeRotation(0, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpcontainer setAlpha:1.f];
        [editPasswordContainer setAlpha:1.f];
        [editPasswordContainer.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


#pragma mark End -

#pragma mark - Edit Select Pop Up Methods -
#pragma mark - Button Actions

- (IBAction)closeEditSelectBirthDayPopUp:(id)sender {
    
    isPopUpContainerShown = NO;
    [self allTextFieldResignFirstResponder];
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .1f, .1f, .1f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpcontainer setAlpha:.0f];
        [editBirthDateContainer setAlpha:.0f];
        [editBirthDateContainer.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (IBAction)okEditSelectBirthDayPopUpBtnClicked:(id)sender {
    
    [birthDateButton setTitle:[self prettyDateStringFromStringDate:[datePicker getDateAsString]]
                     forState:UIControlStateNormal];
    
    birthDateUglyString = datePicker.getDateAsString;
    
    [self closeEditSelectBirthDayPopUp:sender];
}

#pragma mark End -

#pragma mark - Add Password Pop Up Methods -
#pragma mark - Button Actions

- (IBAction)closeAddPasswordPopUp:(UIButton *)sender {
    
    
    isPopUpContainerShown = NO;
    [self allTextFieldResignFirstResponder];
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .1f, .1f, .1f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpcontainer setAlpha:.0f];
        [editPasswordContainer setAlpha:.0f];
        [editPasswordContainer.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        editPasswordTextField.text = editConfirmPasswordTextField.text = @"";
        
    }];
    
    
}

- (IBAction)addPasswordButton:(UIButton *)sender {
    [self allTextFieldResignFirstResponder];
    
    void (^block)(NSInteger, NSString*, NSError*) = ^(NSInteger flag, NSString* errorMsg, NSError* error) {
        [self closeAddPasswordPopUp:nil];
        
        if (error) {
//            [self displayErrorMsgAlertViewWithMessage:@"Problemas cambiando la clave. Verifique su conexión a internet." withTitle:@"Oops"];
            [CRToastManager showToastWithTitle:@"Problemas cambiando la clave. Verifique su conexión a internet." withSubTitle:nil forError:YES];
            return;
        }
        
        if (flag == kErrorAddingNewPassword) {
//            [self displayErrorMsgAlertViewWithMessage:errorMsg withTitle:@"Oops"];
            [CRToastManager showToastWithTitle:errorMsg withSubTitle:nil forError:YES];
            return;
        }
        
//        [self displayErrorMsgAlertViewWithMessage:errorMsg withTitle:@"Logrado!"];
        

        _user.password = editPasswordTextField.text;
        [CRToastManager showToastWithTitle:errorMsg withSubTitle:nil forError:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    };
    
    if ([editPasswordTextField.text isEqualToString:editConfirmPasswordTextField.text] &&
        ![editPasswordTextField.text isEqualToString:@""] &&
        ![editConfirmPasswordTextField.text isEqualToString:@""] &&
        editConfirmPasswordTextField.text.length > 5)
    {
        
//        [_user addPasswordToUser:_user withNewPassword:editPasswordTextField.text copletitionHandler:block];
        [_user updatePasswordForUser:_user withNewPassword:editPasswordTextField.text copletitionHandler:block];
        return;
        
    }
    
    if (editConfirmPasswordTextField.text.length <= 5) {
//        [self displayErrorMsgAlertViewWithMessage:@"La clave es muy corta." withTitle:@"Oops!"];
        [CRToastManager showToastWithTitle:@"La clave es muy corta." withSubTitle:nil forError:YES];
        return;
    }
    
//    [self displayErrorMsgAlertViewWithMessage:@"Las claves no coinciden!" withTitle:@"Oops!"];
    [CRToastManager showToastWithTitle:@"Las claves no coinciden!" withSubTitle:nil forError:YES];
    
    
    
}

#pragma mark End -

#pragma mark - Gesture Method

- (IBAction)closePopUp:(id)sender {
    
    switch (wichContainerIsShown) {
        case 1:
            [self closeEditSelectBirthDayPopUp:nil];
            break;
        case 2:
            [self closeAddPasswordPopUp:nil];
            break;
    }
    
    wichContainerIsShown = 0;
}

#pragma mark End -

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    offsetRect = textField.frame;
}

-(void)allTextFieldResignFirstResponder{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
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
                                               [self.navigationController popViewControllerAnimated:YES];
                                               
                                           } else if ([alert.title isEqualToString:@"Logrado!"]){
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                           }
                                       }];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles: nil];
        [alert show];
    }
    
    
}
#pragma mark - End

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
//    
//    saveBtnBottomConstraint.constant += keyboardRect.size.height;
//
//
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        [UIView setAnimationCurve:curve];
//        [self.view layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//        if (!isPopUpContainerShown && offsetRect.origin.y >= _scrollView.frame.size.height - 20 && [UIScreen mainScreen].bounds.size.height <= 568) {
//            offsetRect.origin.x = 0;
//            offsetRect.origin.y -= 60;
//            [_scrollView setContentOffset:offsetRect.origin animated:YES];
////            [_scrollView scrollRectToVisible:offsetRect animated:YES];
//        }
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
//    saveBtnBottomConstraint.constant = 0;
//    
////    if (!isPopUpContainerShown) {
////        [_scrollView setContentOffset:offsetPoint animated:YES];
////    }
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

#pragma mark End -


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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



@end
