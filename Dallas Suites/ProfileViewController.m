//
//  ProfileViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/31/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"

#define ProfileCell @"profileCell"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>{
    
    //Main View
        //Nav Bar
    __weak IBOutlet UINavigationBar *navBar;
        //User Name Label
    __weak IBOutlet UILabel *userNameLabel;
        //Points Label
    __weak IBOutlet UILabel *pointsLabel;
    
    
}
//History Tableview
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;


@end

@implementation ProfileViewController
@synthesize historyTableView = historyTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Styling!!!
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString* user = @"Mike Pesate"; //User's Full Name Goes Here
    CGFloat points = 9750.f; //User's Points Go Here
    
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
    
    //User's full name animation block
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        for (int i=0; i<user.length; i++)
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [userNameLabel setText:[NSString stringWithFormat:@"%@%C", userNameLabel.text, [user characterAtIndex:i]]];
                           });
            
            [NSThread sleepForTimeInterval:1.f/user.length];
        }
        
    });
    
}

#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Profile TableView Methods Population
//TODO: Populate table with data!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 15;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfileTableViewCell* cell = [historyTableView dequeueReusableCellWithIdentifier:ProfileCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row % 2 == 0) {
        [cell setUpCellInfoWithSuiteName:@"Suit Name" withAction:@"Points Added" withDate:@"14 - Nov - 2014"];
    } else {
        [cell setUpCellInfoWithSuiteName:@"" withAction:@"Points Withdrawed" withDate:@"16 - Dic - 2014"];
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -

@end
