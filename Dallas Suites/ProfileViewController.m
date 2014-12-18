//
//  ProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/31/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "RegisterEditProfileViewController.h"
#import "UserHistoryModel.h"

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
    
    
    [userNameLabel setText:user];
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
    [(RegisterEditProfileViewController*)[segue destinationViewController] setIsForEdit:YES];
    [(RegisterEditProfileViewController*)[segue destinationViewController] setUser:_user];
}

#pragma mark End -

@end
