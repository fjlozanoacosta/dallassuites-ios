//
//  RegisterEditProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/1/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RegisterEditProfileViewController.h"
#import "RegisterOrEditTableViewCell.h"
#import "RegisterEditActionTableViewCell.h"
#import "DatePicker.h"

#import <sys/utsname.h>

#define RegisterEditCell @"registerEditCell"
#define RegisterEditActionCell @"registerEditActionCell"

#define RegisterTextFieldsPlaceholders @[ @"NOMBRE", @"APELLIDO", @"CORREO ELECTRÓNICO", @"FECHA DE NACIMIENTO", @"C.I.", @"NOMBRE DE USUARIO", @"CONTRASEÑA", @"REPETIR CONTRASEÑA"]
#define RegisterIcons @[ @"registerEditIcon_1", @"registerEditIcon_1", @"registerEditIcon_2", @"registerEditIcon_3", @"registerEditIcon_4", @"registerEditIcon_1", @"registerEditIcon_5", @"registerEditIcon_5" ]

#define EditTextFieldsPlaceholders @[ @"NOMBRE", @"APELLIDO", @"CORREO ELECTRÓNICO", @"FECHA DE NACIMIENTO", @"C.I.", @"NOMBRE DE USUARIO", @"CONTRASEÑA", @"AGREGAR CONTRASEÑA"]



@interface RegisterEditProfileViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    
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
         isPopUpContainerShown;
    
    NSMutableArray* textFields;
    UILabel* birthDayLabel;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RegisterEditProfileViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self allTextFieldResignFirstResponder];
}

#pragma mark - Main View Methods -
#pragma mark - Button Actions

-(IBAction)registerOrSaveEdit:(UIButton*)sender{
    if (_isForEdit) {
        //If editing profile, do actions here
        
        return;
    }
    
    //If registering User Actions go here
}

#pragma mark End -

#pragma mark - PopUp Display Methods

-(void)displaySelectBirthDayPopUp {
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

    [self closeEditSelectBirthDayPopUp:sender];
}

#pragma mark End -

#pragma mark - TextField Methods -
#pragma mark - Utility Methods 
-(void)allTextFieldResignFirstResponder{
    [addPasswordPopUpPasswordAgainTextField resignFirstResponder];
    [addPasswordPopUpPasswordTextField resignFirstResponder];
}
#pragma mark End -
#pragma mark - Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
            
            birthDayLabel = aCell.cellLabel;
            
            [aCell.cellLabel setText:[RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row]];
            [aCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
            
            return aCell;
            
        }
        
        RegisterOrEditTableViewCell* rCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditCell];
        [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        rCell.textEditField.placeholder = [RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row];
        [rCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
        rCell.textEditField.delegate = self;
        
        if ([textFields indexOfObject:rCell.textEditField] == NSIntegerMax) {
            [textFields addObject:rCell.textEditField];
        }
        
        
        return rCell;
    }
    
    //Else it will be used for editing the users profile
    
    if (indexPath.row == 3 || indexPath.row == 7) {
        RegisterEditActionTableViewCell* aCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditActionCell];
        [aCell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if (indexPath.row == 3) {
            birthDayLabel = aCell.cellLabel;
        } else {
            //What to do keep reference of, if cell is of "Add Password type"
        }
        
        [aCell.cellLabel setText:[EditTextFieldsPlaceholders objectAtIndex:indexPath.row]]; //Should Load User Info
        [aCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
        
        return aCell;
        
    }
    
    RegisterOrEditTableViewCell* rCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditCell];
    [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    rCell.textEditField.placeholder = [EditTextFieldsPlaceholders objectAtIndex:indexPath.row]; //
    [rCell.iconImage setImage:[UIImage imageNamed:[RegisterIcons objectAtIndex:indexPath.row]]];
    rCell.textEditField.delegate = self;
    
    if ([textFields indexOfObject:rCell.textEditField] == NSIntegerMax) {
        [textFields addObject:rCell.textEditField];
    }
    
    
    return rCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3 || (_isForEdit && indexPath.row == 7)) {
        [textFields enumerateObjectsUsingBlock:^(UITextField* obj, NSUInteger idx, BOOL *stop) {
            [obj resignFirstResponder];
        }];

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

#pragma mark End -

#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
    
    //    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark End -

@end
