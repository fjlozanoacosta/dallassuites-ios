//
//  RegisterEditProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/1/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RegisterEditProfileViewController.h"
#import "RegisterOrEditTableViewCell.h"

#import <sys/utsname.h>

#define RegisterEditCell @"registerEditCell"

#define RegisterTextFieldsPlaceholders @[ @"NOMBRE", @"APELLIDO", @"CORREO ELECTRÓNICO", @"FECHA DE NACIMIENTO", @"C.I.", @"NOMBRE DE USUARIO", @"CONTRASEÑA", @"REPETIR CONTRASEÑA"]

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
    
    
    bool isKeyboardShown, isSmallKeyboardFlapShown;
    
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
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
    isKeyboardShown = isSmallKeyboardFlapShown = NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Keyboard Methods -
#pragma mark - Keyboard presenting methods

- (void)keyboardWillShow:(NSNotification *)notification
{
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
        
        RegisterOrEditTableViewCell* rCell = [_tableView dequeueReusableCellWithIdentifier:RegisterEditCell];
        [rCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        rCell.textEditField.placeholder = [RegisterTextFieldsPlaceholders objectAtIndex:indexPath.row];
        rCell.textEditField.delegate = self;
        
        return rCell;
    }
    
    //Else it will be used for editing the users profile
    
    UITableViewCell* eCell = [[UITableViewCell alloc] init];
    [eCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return eCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
