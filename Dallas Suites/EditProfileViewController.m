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



#define monthArray @[@"ENE", @"FEB", @"MAR", @"ABR", @"MAY", @"JUN", @"JUL", @"AGO", @"SEP", @"OCT", @"NOV", @"DIC"]

@interface EditProfileViewController () <UITextFieldDelegate> {
    
    __weak IBOutlet UINavigationBar *navBar;
    
    __weak IBOutlet UILabel *NameNicknameLabel;
    
    
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *keyWordTextField;
    __weak IBOutlet UITextField *idTextField;
    
    
    __weak IBOutlet UIButton *birthDateButton;
    __weak IBOutlet UIButton *changePasswordBtn;
    
    
    //Pop Ups
    
    __weak IBOutlet UIView *popUpcontainer;
    
    __weak IBOutlet UIView *editPasswordContainer;
    __weak IBOutlet UITextField *editPasswordTextField;
    __weak IBOutlet UITextField *editConfirmPasswordTextField;
    
    
    __weak IBOutlet NSLayoutConstraint *saveBtnBottomConstraint;
    
    __weak IBOutlet UIView *editBirthDateContainer;
    __weak IBOutlet DatePicker *datePicker;
    
    
    BOOL isPopUpContainerShown;
    BOOL isKeyboardShown;
    
    CGRect offsetRect;
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
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
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
}

#pragma mark - Private Styling Methods
-(void)styleTextFieldsButtonsAndNameLabel{
    //TextField Styling
    NSDictionary* attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:18.f],
                                  NSForegroundColorAttributeName : [UIColor colorWithWhite:1.f alpha:.5f]};
    NSAttributedString* string = [[NSAttributedString alloc] initWithString:@"Correo electrónico" attributes:attributes];
    [emailTextField setAttributedPlaceholder:string];
    string = [[NSAttributedString alloc] initWithString:@"Palabra clave" attributes:attributes];
    [keyWordTextField setAttributedPlaceholder:string];
    string = [[NSAttributedString alloc] initWithString:@"Cédula" attributes:attributes];
    [idTextField setAttributedPlaceholder:string];
    
    
}

-(void)styleUserNameAndNicknameWith:(NSString*)name withLastName:(NSString*)lastname withNickname:(NSString*)nickname{
    NSDictionary* attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Medium" size:18.f],
                    NSForegroundColorAttributeName : [UIColor colorWithRed:233.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f]};
    
    nickname = [NSString stringWithFormat:@"%@ | ", nickname];
    NSAttributedString* string = [[NSAttributedString alloc] initWithString:nickname attributes:attributes];
    
    NSMutableAttributedString* mString = [[NSMutableAttributedString alloc] init];
    [mString appendAttributedString:string];
    
    attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:18.f],
                    NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    name = [NSString stringWithFormat:@"%@ %@", name, lastname];
    
    string = [[NSAttributedString alloc] initWithString:name attributes:attributes];
    
    [mString appendAttributedString:string];
    
    [NameNicknameLabel setAttributedText:mString];
}

-(void)loadUserInfoToFields{
    [self styleUserNameAndNicknameWith:_user.name withLastName:_user.lastname withNickname:_user.username];
    [emailTextField setText:_user.email];
//    [keyWordTextField setText:_user.keyWord];
    [birthDateButton setTitle:[self prettyDateStringFromStringDate:_user.birthDay] forState:UIControlStateNormal];
    [idTextField setText:[NSString stringWithFormat:@"%i", _user.cedula.intValue]];
    
//    [changePasswordBtn setTitle:_user.password forState:UIControlStateNormal];
}

-(NSString*)prettyDateStringFromStringDate:(NSString*)dateString{
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
    
    _user.cedula = @(idTextField.text.integerValue);
    
    [_user updateUserInfoWithUser:_user copletitionHandler:^(BOOL userUpdated, NSString * msg, NSError * error) {
        if (error) {
            NSLog(@"Error");
            return;
        }
        
        NSLog(@"Success");
    }];
    
}


#pragma mark - PopUp Display Methods

-(IBAction)displaySelectBirthDayPopUp:(id)sender {
    if (isPopUpContainerShown) {
        return;
    }
    
    [self allTextFieldResignFirstResponder];
    
    isPopUpContainerShown = YES;
    
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
    
    _user.birthDay = datePicker.getDateAsString;
    
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
            [self displayErrorMsgAlertViewWithMessage:@"Problemas cambiando la clave. Verifique su conexión a internet." withTitle:@"Oops"];
            return;
        }
        
        if (flag == kErrorAddingNewPassword) {
            [self displayErrorMsgAlertViewWithMessage:errorMsg withTitle:@"Oops"];
            return;
        }
        
        [self displayErrorMsgAlertViewWithMessage:errorMsg withTitle:@"Logrado!"];
        _user.password = editPasswordTextField.text;
        
        
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
        [self displayErrorMsgAlertViewWithMessage:@"La clave es muy corta." withTitle:@"Oops!"];
        return;
    }
    
    [self displayErrorMsgAlertViewWithMessage:@"Las claves no coinciden!" withTitle:@"Oops!"];
    
    
    
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (isPopUpContainerShown) {
        return;
    }
    
    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    if (isKeyboardShown) {
        
        [UIView animateWithDuration:duration animations:^{
            
            [UIView setAnimationCurve:curve];
            [self.view layoutIfNeeded];
            
        } completion:nil];
        
        return;
    }
    isKeyboardShown = YES;
    
    
    
    saveBtnBottomConstraint.constant += keyboardRect.size.height;


    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (!isPopUpContainerShown && offsetRect.origin.y >= _scrollView.frame.size.height && [UIScreen mainScreen].bounds.size.height <= 568) {
            offsetRect.origin.x = 0;
            offsetRect.origin.y -= 60;
            [_scrollView setContentOffset:offsetRect.origin animated:YES];
//            [_scrollView scrollRectToVisible:offsetRect animated:YES];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    isKeyboardShown = NO;
    
    saveBtnBottomConstraint.constant = 0;
    
//    if (!isPopUpContainerShown) {
//        [_scrollView setContentOffset:offsetPoint animated:YES];
//    }
    
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark End -


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
