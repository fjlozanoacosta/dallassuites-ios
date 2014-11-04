//
//  RegisterEditProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/1/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

//Missing all the code for adding new password!!!!!

#import "RegisterEditProfileViewController.h"
#import "RegisterOrEditTableViewCell.h"
#import "RegisterEditActionTableViewCell.h"
#import "DatePicker.h"

#import <sys/utsname.h>

#define RegisterEditCell @"registerEditCell"
#define RegisterEditActionCell @"registerEditActionCell"

#define RegisterTextFieldsPlaceholders @[ @"NOMBRE", @"APELLIDO", @"CORREO ELECTRÓNICO", @"FECHA DE NACIMIENTO", @"C.I. (V-1234567)", @"NOMBRE DE USUARIO", @"CONTRASEÑA", @"REPETIR CONTRASEÑA"]
#define RegisterIcons @[ @"registerEditIcon_1", @"registerEditIcon_1", @"registerEditIcon_2", @"registerEditIcon_3", @"registerEditIcon_4", @"registerEditIcon_1", @"registerEditIcon_5", @"registerEditIcon_5" ]

#define EditTextFieldsPlaceholders @[ @"NOMBRE", @"APELLIDO", @"CORREO ELECTRÓNICO", @"FECHA DE NACIMIENTO", @"C.I.", @"NOMBRE DE USUARIO", @"CONTRASEÑA", @"AGREGAR CONTRASEÑA"]

//Testing without service conection to server
typedef struct {
    __unsafe_unretained NSString* nombre;
    __unsafe_unretained NSString* apellido;
    __unsafe_unretained NSString* fechaDeNacimiento;
    __unsafe_unretained NSString* email;
    __unsafe_unretained NSString* cedula;
    __unsafe_unretained NSString* usuario;
    __unsafe_unretained NSString* clave;
    
}User;


@interface RegisterEditProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate> {
    
    
    //Nav Bar Outlets
        //Nav Bat itself
    __weak IBOutlet UINavigationBar *navBar;
        //Nav Bar Tittle
    __weak IBOutlet UINavigationItem *navBarTitle;
    
    
    //Main View Outlets
        //Register Save Btn
    __weak IBOutlet UIButton *registerOrSaveEditBtn;
        //Register Edit Btn Bottom Constraint
    __weak IBOutlet NSLayoutConstraint *registerOrEditBtnBottomConstraint;
    
    
    //PopUp Container
    __weak IBOutlet UIView *popUpsContainer;
    
    //Add Password PopUp
        //Frame
    __weak IBOutlet UIView *addPasswordPopUpFrame;
        //TextField
    __weak IBOutlet UITextField *addPasswordPopUpPasswordTextField;
    __weak IBOutlet UITextField *addPasswordPopUpPasswordAgainTextField;
        //Add (Agregar) Btn
    __weak IBOutlet UIButton *addPasswordPopUpAddBtn;
        //Close Btn
    __weak IBOutlet UIButton *addPasswordPopUpCloseBtn;
    
    //Edit/Select BirthDay PopUp
        //Frame
    __weak IBOutlet UIView *editSelectBirthDayPopUpFrame;
        //Picker
    __weak IBOutlet DatePicker *editSelectBirthDayPopUpDatePicker;
        //Close Btn
    __weak IBOutlet UIButton *editSelectBirthDayPopUpCloseBtn;
        //Ok Btn
    __weak IBOutlet UIButton *editSelectBirthDayPopUpOkBtn;
    
    
    bool isKeyboardShown,
         isSmallKeyboardFlapShown,
         isPopUpContainerShown,
         validEmail;
    
    NSMutableArray* textFields;
    NSMutableArray* addedTextFields;
    
    User user;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RegisterEditProfileViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Testing wothout server connection - Should load user info from server
    user.nombre = @"Uno";
    user.apellido = @"Dos";
    user.email = @"email@email.com";
    user.fechaDeNacimiento = @"14 - NOV - 1996";
    user.cedula = @"V-123456";
    user.usuario = @"UnUsuario";
    user.clave = @"123456";
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
    if (_isForEdit) {
        navBarTitle.title = @"EDITAR";
        [registerOrSaveEditBtn setTitle:@"GUARDAR" forState:UIControlStateNormal];
        
        //Load current user info to display
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
    
    isKeyboardShown = isSmallKeyboardFlapShown = NO;
    textFields = [NSMutableArray new];
    addedTextFields = [NSMutableArray new];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self allTextFieldResignFirstResponder];
}

#pragma mark - Main View Methods -
#pragma mark - Button Actions

-(IBAction)registerOrSaveEdit:(UIButton*)sender{
    [self allTextFieldResignFirstResponder];
    
    //From here the code only works locally, should be adapted to work with services!!!
    
    if (_isForEdit) {
        //If editing profile, do actions here
        __block BOOL completeRegister = YES;
        [textFields enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:@""]) {
                completeRegister = NO;
                *stop = YES;
                return;
            }
        }];
        if (completeRegister) {
            if(!validEmail){
                return;
            }
            [textFields enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@ = %@", [RegisterTextFieldsPlaceholders objectAtIndex:idx], obj);
            }];
        }

        return;
    }
    
    //If registering User Actions go here
    __block BOOL completeRegister = YES;
    [textFields enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@""]) {
            completeRegister = NO;
            *stop = YES;
            return;
        }
    }];
    if (completeRegister) {
        if(!validEmail){
            return;
        }
        [textFields enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"%@ = %@", [RegisterTextFieldsPlaceholders objectAtIndex:idx], obj);
        }];
    }
}

#pragma mark End -

#pragma mark - PopUp Display Methods

-(void)displaySelectBirthDayPopUp {
    [self allTextFieldResignFirstResponder];
    
    isPopUpContainerShown = YES;
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .2f, .2f, 1.f);
    [editSelectBirthDayPopUpFrame.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeRotation(0, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpsContainer setAlpha:1.f];
        [editSelectBirthDayPopUpFrame setAlpha:1.f];
        [editSelectBirthDayPopUpFrame.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)displayAddNewPasswordPopUp {
    
    isPopUpContainerShown = YES;
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, .2f, .2f, 1.f);
    [addPasswordPopUpFrame.layer setTransform:transform];
    
    CATransform3D revertTransform = CATransform3DMakeRotation(0, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.f, 1.f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpsContainer setAlpha:1.f];
        [addPasswordPopUpFrame setAlpha:1.f];
        [addPasswordPopUpFrame.layer setTransform:revertTransform];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


#pragma mark End -

#pragma mark - Add Password Pop Up Methods -
#pragma mark - Button Actions

- (IBAction)closeAddPasswordPopUp:(UIButton *)sender {
    

    isPopUpContainerShown = NO;
    [self allTextFieldResignFirstResponder];
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.8f, 1.8f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpsContainer setAlpha:.0f];
        [addPasswordPopUpFrame setAlpha:.0f];
        [addPasswordPopUpFrame.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        addPasswordPopUpPasswordTextField.text = addPasswordPopUpPasswordAgainTextField.text = @"";
        
    }];
    
    
}

- (IBAction)addPasswordButton:(UIButton *)sender {
}

#pragma mark End -

#pragma mark - Edit Select Pop Up Methods -
#pragma mark - Button Actions

- (IBAction)closeEditSelectBirthDayPopUp:(id)sender {
    
    isPopUpContainerShown = NO;
    [self allTextFieldResignFirstResponder];
    
    CATransform3D transform = CATransform3DMakeRotation(180.0 * M_PI, 0, 0, 1);
    transform = CATransform3DScale(transform, 1.8f, 1.8f, 1.f);
    
    [UIView animateWithDuration:.5f animations:^{
        
        [popUpsContainer setAlpha:.0f];
        [editSelectBirthDayPopUpFrame setAlpha:.0f];
        [editSelectBirthDayPopUpFrame.layer setTransform:transform];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (IBAction)okEditSelectBirthDayPopUpBtnClicked:(id)sender {
    
    //NSLog(@"Date: %@", [editSelectBirthDayPopUpDatePicker getDateAsString]);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
    
    [[(RegisterEditActionTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath] cellLabel] setText:[editSelectBirthDayPopUpDatePicker getDateAsString]];

    [textFields replaceObjectAtIndex:3 withObject:[editSelectBirthDayPopUpDatePicker getDateAsString]];
    
    [self closeEditSelectBirthDayPopUp:sender];
}

#pragma mark End -

#pragma mark - TextField Methods -
#pragma mark - Utility Methods 
-(void)allTextFieldResignFirstResponder{
    [addPasswordPopUpPasswordAgainTextField resignFirstResponder];
    [addPasswordPopUpPasswordTextField resignFirstResponder];
    for (int i = 0; i < textFields.count; i++) {
        if (i == 3 || (_isForEdit && i == 7)) {
            continue;
        }
        [[(RegisterOrEditTableViewCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]] textEditField] resignFirstResponder];
    }
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
//        NSLog(@"%@", ([self validateEmailWithString:[textField text]])?@"YES":@"NO");
        if ([self validateEmailWithString:[textField text]]) {
            [textField setTextColor:[UIColor greenColor]];
            validEmail = YES;
        } else {
            [textField setTextColor:[UIColor redColor]];
            validEmail = NO;
        }
    }
    if (textFields.count - 1 >= textField.tag) {
        [textFields replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //Validate input on C.I. Field
    if (textField.tag == 4) {
        if (range.location == 0 && range.length == 0) {
            if ([string isEqualToString:@"v"] || [string isEqualToString:@"V"]) {
                textField.text = @"V-";
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
                [textField resignFirstResponder];
                [textField becomeFirstResponder];
                //[textFields replaceObjectAtIndex:textField.tag withObject:textField.text.copy];
                return NO;
            } else if ([string isEqualToString:@"e"] || [string isEqualToString:@"E"]){
                textField.text = @"E-";
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
                [textField resignFirstResponder];
                [textField becomeFirstResponder];
                //[textFields replaceObjectAtIndex:textField.tag withObject:textField.text.copy];
                return NO;
            } else {
                //[textFields replaceObjectAtIndex:textField.tag withObject:textField.text.copy];
                return NO;
            }
        } else if (range.location == 1 && range.length == 1 && [string isEqualToString:@""]) {
            textField.text = @"";
            [textField setKeyboardType:UIKeyboardTypeAlphabet];
            [textField resignFirstResponder];
            [textField becomeFirstResponder];
            //[textFields replaceObjectAtIndex:textField.tag withObject:textField.text.copy];
            return NO;
        }
    }
    
    //[textFields replaceObjectAtIndex:textField.tag withObject:textField.text];
    
    return YES;
}

-(void)textFieldDidChange:(UITextField*)textField{
    //Replace the local instance of the users info that has been changed.
    [self replaceUserinfo:textField.text andTag:textField.tag];
}

//Testing without server conection
-(void)replaceUserinfo:(NSString*)s andTag:(NSInteger)idx{

    switch (idx) {
        case 0:
            user.nombre = s;
            break;
        case 1:
            user.apellido = s;
            break;
        case 2:
            user.email = s;
            break;
        case 3:
            user.fechaDeNacimiento = s;
            break;
        case 4:
            user.cedula = s;
            break;
        case 5:
            user.usuario = s;
            break;
        case 6:
            user.clave = s;
            break;
    }
}

#pragma mark End -

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
        int smallFlapOffset = 29;
        if ([machineName() isEqualToString:@"iPhone7,1"]) {
            smallFlapOffset += 6;
        }
        if (isSmallKeyboardFlapShown) {
            isSmallKeyboardFlapShown = NO;
            registerOrEditBtnBottomConstraint.constant -= smallFlapOffset;
        } else {
            isSmallKeyboardFlapShown = YES;
            registerOrEditBtnBottomConstraint.constant += smallFlapOffset;
        }
        
        [UIView animateWithDuration:duration animations:^{
            
            [UIView setAnimationCurve:curve];
            [self.view layoutIfNeeded];
            
        } completion:nil];
        
        return;
    }
    isKeyboardShown = YES;

    
    if (keyboardRect.size.height <= 225.f) {
        isSmallKeyboardFlapShown = NO;
    } else if (keyboardRect.size.height > 225.f) {
        isSmallKeyboardFlapShown = YES;
    }
    

    registerOrEditBtnBottomConstraint.constant += keyboardRect.size.height;
    
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    isKeyboardShown = NO;
    
    registerOrEditBtnBottomConstraint.constant = 0;
    
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark @ Special Function to get Current Device

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

#pragma mark End -

#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Register/Edit Profile TableView Methods Population
//TODO: Populate table with data!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [RegisterTextFieldsPlaceholders count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //If the view will be used for Registering new user

    
    if (!_isForEdit) {
        
        if (indexPath.row == 3) {
            RegisterEditActionTableViewCell* aCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditActionCell];
            [aCell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
            
            [aCell.cellLabel setText:[RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row]];
            [aCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
            
            if ((textFields.count - 1) >= indexPath.row && textFields.count != 0 && ![(NSString*)[textFields objectAtIndex:indexPath.row] isEqualToString:@""]) {
                aCell.cellLabel.text = (NSString*)[textFields objectAtIndex:indexPath.row];
            } else {
                aCell.cellLabel.text = [RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row];
            }
            
            __block BOOL hasBeenAdded = NO;
            [addedTextFields enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL *stop) {
                if (obj.integerValue == indexPath.row) {
                    hasBeenAdded = YES;
                    return;
                }
            }];
            if (!hasBeenAdded) {
                [textFields addObject:@""];
                [addedTextFields addObject:@(indexPath.row)];
            }
            
            return aCell;
            
        }
        
        RegisterOrEditTableViewCell* rCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditCell];
        [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [rCell.textEditField setTag:indexPath.row];
        
        
        if ((textFields.count - 1) >= indexPath.row && textFields.count != 0 && ![(NSString*)[textFields objectAtIndex:indexPath.row] isEqualToString:@""]) {
            rCell.textEditField.text = (NSString*)[textFields objectAtIndex:indexPath.row];
        } else {
            rCell.textEditField.placeholder = [RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row];
            rCell.textEditField.text = @"";
        }
        [rCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
        rCell.textEditField.delegate = self;
        
//        if (indexPath.row == 4) {
//            [[rCell textEditField] setSpellCheckingType:UITextSpellCheckingTypeNo];
//        }
        
        if (indexPath.row == 6 || indexPath.row == 7) {
            [[rCell textEditField] setSecureTextEntry:YES];
        } else {
            [[rCell textEditField] setSecureTextEntry:NO];
        }
        
        if (indexPath.row == 2 && ![rCell.textEditField.text isEqualToString:@""]) {
            [rCell.textEditField.delegate textFieldDidEndEditing:rCell.textEditField];
        } else {
            [rCell.textEditField setTextColor:[UIColor whiteColor]];
        }
        
        __block BOOL hasBeenAdded = NO;
        [addedTextFields enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL *stop) {
            if (obj.integerValue == indexPath.row) {
                hasBeenAdded = YES;
                return;
            }
        }];
        if (!hasBeenAdded) {
            [textFields addObject:rCell.textEditField.text.copy];
            [addedTextFields addObject:@(indexPath.row)];
        }

        
        
        return rCell;
    }
    
    //Else it will be used for editing the users profile
    
    if (indexPath.row == 3 || indexPath.row == 7) {
        RegisterEditActionTableViewCell* aCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditActionCell];
        [aCell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
       
        
        [aCell.cellLabel setText:[EditTextFieldsPlaceholders objectAtIndex:indexPath.row]]; //Should Load User Info
        [aCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
       
        if (indexPath.row == 3) {
            
            if ((textFields.count - 1) >= indexPath.row && textFields.count != 0 && ![(NSString*)[textFields objectAtIndex:indexPath.row] isEqualToString:@""]) {
                aCell.cellLabel.text = (NSString*)[textFields objectAtIndex:indexPath.row];
            } else {
                aCell.cellLabel.text = [self userinfo:indexPath.row];
            }
            
            __block BOOL hasBeenAdded = NO;
            [addedTextFields enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL *stop) {
                if (obj.integerValue == indexPath.row) {
                    hasBeenAdded = YES;
                    return;
                }
            }];
            if (!hasBeenAdded) {
                [textFields addObject:aCell.cellLabel.text];
                [addedTextFields addObject:@(indexPath.row)];
            }

            
        } else {
            //What to do keep reference of, if cell is of "Add Password type"
        }
        
        
        return aCell;
        
    }
    
    RegisterOrEditTableViewCell* rCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditCell];
    [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [rCell.textEditField setTag:indexPath.row];
    
    if ((textFields.count - 1) >= indexPath.row && textFields.count != 0 && ![(NSString*)[textFields objectAtIndex:indexPath.row] isEqualToString:@""]) {
        rCell.textEditField.text = (NSString*)[textFields objectAtIndex:indexPath.row];
    } else {
        rCell.textEditField.placeholder = [RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row];
        rCell.textEditField.text = [self userinfo:indexPath.row];
    }
    [rCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
    rCell.textEditField.delegate = self;
    
    if (indexPath.row == 6) {
        [[rCell textEditField] setSecureTextEntry:YES];
    } else {
        [[rCell textEditField] setSecureTextEntry:NO];
    }
    
    if (indexPath.row == 2 && ![rCell.textEditField.text isEqualToString:@""]) {
        [rCell.textEditField.delegate textFieldDidEndEditing:rCell.textEditField];
    } else {
        [rCell.textEditField setTextColor:[UIColor whiteColor]];
    }
    
    if (indexPath.row == 4) {
        [rCell.textEditField setKeyboardType:UIKeyboardTypeNumberPad];
    } else {
        [rCell.textEditField setKeyboardType:UIKeyboardTypeAlphabet];
    }
    
    __block BOOL hasBeenAdded = NO;
    [addedTextFields enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL *stop) {
        if (obj.integerValue == indexPath.row) {
            hasBeenAdded = YES;
            return;
        }
    }];
    if (!hasBeenAdded) {
        [rCell.textEditField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textFields addObject:rCell.textEditField.text.copy];
        [addedTextFields addObject:@(indexPath.row)];
    }
    
    return rCell;
    
}

//Testing whithout server connection!!
-(NSString*)userinfo:(NSInteger)idx{
    NSString* s;
    switch (idx) {
        case 0:
            s = user.nombre;
            break;
        case 1:
            s = user.apellido;
            break;
        case 2:
            s = user.email;
            break;
        case 3:
            s = user.fechaDeNacimiento;
            break;
        case 4:
            s = user.cedula;
            break;
        case 5:
            s = user.usuario;
            break;
        case 6:
            s = user.clave;
            break;
    }
    return s;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3 || (_isForEdit && indexPath.row == 7)) {
        for (int i = 0; i < textFields.count; i++) {
            if (i == 3 || (_isForEdit && i == 7)) {
                continue;
            }
            [[(RegisterOrEditTableViewCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]] textEditField] resignFirstResponder];
        }

        //[_tableView beginUpdates];
        //isBigger = !isBigger;
        //[_tableView endUpdates];
    }
    
    if (indexPath.row == 3) {
        [self displaySelectBirthDayPopUp];
    }
    
    if (_isForEdit && indexPath.row == 7) {
        [self displayAddNewPasswordPopUp];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //if ( (indexPath.row == 3 || indexPath.row == 7) && isBigger ) {
        //return 100.f;
    //}
    
    return [_tableView rowHeight];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

#pragma mark End -

#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
    
    //    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark End -

@end
