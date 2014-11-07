//
//  RoomsViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/27/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RoomsViewController.h"
#import "RoomsTableViewCell.h"
#import "RoomDetailViewController.h"

#import "RoomModel.h"
#import "AFNetworking.h"


//Custom Transition Controller Class & Animation Classes
#import "ADVAnimationController.h"
#import "DropAnimationController.h"
#import "ZoomAnimationController.h"


//Constants
#define RoomCell @"roomCell"
#define RoomDetailVC @"roomDetailViewController"
#define RoomNames @[ @"SUITE PLUS", @"SUIT PLUS CON JACUZZI", @"SUITE DÚPLEX", @"SUITE DELUXE", @"SUITE PRESIDENCIAL" ]
#define Room360URL @[ @"http://drg06alc81wak.cloudfront.net/360/plus.html", @"http://drg06alc81wak.cloudfront.net/360/plusj.html", @"http://drg06alc81wak.cloudfront.net/360/duplex.html", @"http://drg06alc81wak.cloudfront.net/360/deluxe.html", @"http://drg06alc81wak.cloudfront.net/360/pre.html" ]

@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>{
    
    
    //Main View
        //activityIndicator
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
    
    //Navigation Bar (nav)
        //Bar Itself
    __weak IBOutlet UINavigationBar *navBar;
    
        //Buttons
            //Back Btn
    __weak IBOutlet UIBarButtonItem *navBackBtn;
    
    

    NSMutableArray* roomList;
    
}
//Main View
    //TableView
@property (weak, nonatomic) IBOutlet UITableView *_tableView;


//Custom Transition Controller
@property (nonatomic, strong) id<ADVAnimationController> animationController;

@end

@implementation RoomsViewController
@synthesize _tableView = __tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Styling 
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];
    
    [__tableView setAlpha:.0f];
    [activityIndicator startAnimating];
    [self getRoomsFromServer];

    
    
}

-(void)getRoomsFromServer{
    RoomModel* room = [RoomModel new];    
    void (^block)(NSMutableArray*, NSError*) = ^(NSMutableArray* roomArrayList, NSError* error) {
        
        if (error) {
            [activityIndicator stopAnimating];
            [activityIndicator setAlpha:.0f];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Opps!" message:@"Error en la conexión! Asegurese de estar conectado a internet" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Ok"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action) {
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        roomList = roomArrayList;
        [activityIndicator stopAnimating];
        [__tableView reloadData];
        
        [UIView animateWithDuration:.5f animations:^{
            [activityIndicator setAlpha:.0f];
            [__tableView setAlpha:1.f];
        }];
    };
    
    [room getRoomsForListDisplayWithComplitionHandler:block];
    
}

#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return roomList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RoomsTableViewCell* cell = [__tableView dequeueReusableCellWithIdentifier:RoomCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.roomName setText:[(NSString*)[(RoomModel*)[roomList objectAtIndex:indexPath.row] room_category] uppercaseString]];
    [cell.roomBriefDescription setText:[NSString stringWithFormat:@"Puntos: %i",[(RoomModel*)[roomList objectAtIndex:indexPath.row] room_full_reward].intValue]];
    
#warning Mising images for rooms 5 - 14
    if (indexPath.row < 5) {
        [cell.bgImage setImage:[UIImage imageNamed:[NSString stringWithFormat: @"roomThumbImage_%.2i" , (int)( indexPath.row + 1 )]]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    //Custom Animation Calling
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RoomDetailViewController* controller = (RoomDetailViewController*)[storyboard instantiateViewControllerWithIdentifier:RoomDetailVC];
    
    /*
     * To pass info to view controller
     
     controller.property = something;
     
    */
    
    //Ex:
    controller.navTitle = [(NSString*)[(RoomModel*)[roomList objectAtIndex:indexPath.row] room_category] uppercaseString];
    controller.roomWebAddress = (NSString*)[(RoomModel*)[roomList objectAtIndex:indexPath.row] room_360];
    
//    self.animationController = [[ZoomAnimationController alloc] init];
    self.animationController = [[DropAnimationController alloc] init];
    controller.transitioningDelegate  = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(RoomsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell tablleViewWillDisplayCellAnimationWithAnimationNumber:(indexPath.row % 2)];
    
}

#pragma mark End -

#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {

//    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark End -


#pragma mark - Custom Animation Methods
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}

#pragma mark End -

#pragma mark - RoomModel Delegate Methods -
#pragma mark - Donde request

#pragma mark End -

#pragma mark - Status Bar Style -
#pragma mark - Change Color
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}
#pragma mark End -

@end
