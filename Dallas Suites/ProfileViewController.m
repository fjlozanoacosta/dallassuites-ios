//
//  ProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/31/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "UserHistoryModel.h"
#import "EditProfileViewController.h"
#import "AddNewPasswordPopUpViewController.h"
#import "systemCheck.h"

#define ProfileCell @"profileCell"

#define EditProfileSegue @"toEditProfile"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>{
    
    //Main View
        //Nav Bar
    __weak IBOutlet UINavigationBar *navBar;
        //User Name Label
    __weak IBOutlet UILabel *userNameLabel;
        //Points Label
    __weak IBOutlet UILabel *pointsLabel;
        //Activity Indicator
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    

    NSMutableArray* userHistory;
    
    __weak IBOutlet UIView *profileContainer;
    UIView* overlayProfile;
    
    __weak IBOutlet UIView *menuContainer;
    BOOL menuShown;
    __weak IBOutlet NSLayoutConstraint *menuLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *profileRightConstraint;
}
//History Tableview
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;


@end

@implementation ProfileViewController
@synthesize historyTableView = historyTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userHistory = [NSMutableArray new];
    
    [self loadUserHistory];
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [menuContainer setAlpha:1.f];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [menuContainer setAlpha:.0f];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString* user = _user.username; //User's Full Name Goes Here
    CGFloat points = _user.points.floatValue; //User's Points Go Here
    
    //Animation presets
    [userNameLabel setText:@""];
    [pointsLabel setText:@"0 PTS"];
    
    //Points animation block
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (int i=0; i<=points; i++)
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [pointsLabel setText:[NSString stringWithFormat:@"%i PTS",i]];
                           });
            
            [NSThread sleepForTimeInterval:.3f/points];
        }
        
    });
    
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Bold" size:18.f],
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:233.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f]};
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | ", _user.username] attributes:attributes];
    
    attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:18.f],
                   NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSAttributedString* namelastname = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", _user.name, _user.lastname] attributes:attributes];
    
    [string appendAttributedString:namelastname];
    
    [userNameLabel setAttributedText:string];
    //User's full name animation block
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        
//        for (int i=0; i<user.length; i++)
//        {
//            dispatch_async(dispatch_get_main_queue(),
//                           ^{
//                               [userNameLabel setText:[NSString stringWithFormat:@"%@%C", userNameLabel.text, [user characterAtIndex:i]]];
//                           });
//            
//            [NSThread sleepForTimeInterval:1.f/user.length];
//        }
//        
//    });
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
//    CGPoint location = [touch locationInView:touch.view];
    
    if (touch.view == overlayProfile) {
        [self openMenu:nil];
    }
}

-(void)loadUserHistory{
    
    [activityIndicator startAnimating];
    UserHistoryModel* userHistoryModel = [UserHistoryModel new];
    
    
    [userHistoryModel getUserHistoryForListDisplayWithUser:_user WithComplitionHandler:^(NSMutableArray * responseArray, NSError * error) {
        [activityIndicator stopAnimating];
        [UIView animateWithDuration:.5f animations:^{
            [activityIndicator setAlpha:.0f];
        }];
        if (error) {
            return;
        }
        
        if (responseArray.count == 0) {
            [UIView animateWithDuration:.5f animations:^{
                [historyTableView setAlpha:.0f];
            }];
        }
        
        userHistory = responseArray;
        [historyTableView reloadData];
    }];
}

#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Profile TableView Methods Population
//TODO: Populate table with data!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return userHistory.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfileTableViewCell* cell = [historyTableView dequeueReusableCellWithIdentifier:ProfileCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UserHistoryModel* userHistoryModel = [userHistory objectAtIndex:indexPath.row];
    switch (userHistoryModel.actionType) {
        case UserRoomHistoryTypeMinus:
            [cell setUpCellInfoWithSuiteName:userHistoryModel.room_category
                                  withAction:[NSString stringWithFormat:@"%@ pts", userHistoryModel.used_points]
                                    withDate:userHistoryModel.visit_timestamp];
            break;
        case UserRoomHistoryTypePlus:
            [cell setUpCellInfoWithSuiteName:@""
                                  withAction:[NSString stringWithFormat:@"%@ pts", userHistoryModel.earned_points]
                                    withDate:userHistoryModel.visit_timestamp];
            break;
    }

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(ProfileTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark End -


#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {
    
    //    [self dismissViewControllerAnimated:YES completion:^{}];
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)openMenu:(id)sender {
    if (!menuShown) {
//        menuShown = YES;
        [menuLeftConstraint setConstant:0];
        [profileRightConstraint setConstant:-104];
        
        
        
        [profileContainer setUserInteractionEnabled:NO];
        
        
    } else {
//        menuShown = NO;
        [menuLeftConstraint setConstant:-88];
        [profileRightConstraint setConstant:-16];
        [profileContainer setUserInteractionEnabled:YES];
    }
    
    [UIView animateWithDuration:.3f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!menuShown) {
            menuShown = YES;
            
            overlayProfile = [[UIView alloc] initWithFrame:profileContainer.frame];
            [overlayProfile setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:overlayProfile];
        } else {
            menuShown = NO;
            [overlayProfile removeFromSuperview];
        }

    }];
}

- (IBAction)addNewPassword:(id)sender {
    
    [self openMenu:nil];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self performSegueWithIdentifier:@"ios8ProfilePopUp" sender:nil];
    } else {
    
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        AddNewPasswordPopUpViewController* vC = (AddNewPasswordPopUpViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"addPaswordViewController"];
        [vC.view setAlpha:0.f];
        [vC setUser:_user];
        [self presentViewController:vC
                           animated:YES
                         completion:^{
                             
                             //                         [UIView animateWithDuration:.5f
                             //                                          animations:^{
                             //                                              [vC.view setAlpha:1.f];
                             //
                             //                                          }
                             //                          ];
                         }
         ];
    }
}

#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -

#pragma mark - Navigation Methods -
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    [(RegisterEditProfileViewController*)[segue destinationViewController] setIsForEdit:YES];
//    [(RegisterEditProfileViewController*)[segue destinationViewController] setUser:_user];
    
//    [self performSelectorOnMainThread:@selector(openMenu:) withObject:nil waitUntilDone:YES];
    if (menuShown) {
        [self openMenu:nil];
    }
    
    if ([segue.identifier isEqualToString:@"ios8ProfilePopUp"]) {
        [(AddNewPasswordPopUpViewController*)segue.destinationViewController setUser:_user];
    }
    
    if ([segue.identifier isEqualToString:EditProfileSegue]) {
        [(EditProfileViewController*)segue.destinationViewController setUser:_user];
    }
    
    
    
}

#pragma mark End -

@end
