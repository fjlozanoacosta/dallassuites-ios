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

//Custom Transition Controller Class & Animation Classes
#import "ADVAnimationController.h"
#import "DropAnimationController.h"
#import "ZoomAnimationController.h"


//Constants
#define RoomCell @"roomCell"
#define RoomDetailVC @"roomDetailViewController"

@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>{
    
    
    //Main View
    
    
    //Navigation Bar (nav)
        //Bar Itself
    __weak IBOutlet UINavigationBar *navBar;
    
        //Buttons
            //Back Btn
    __weak IBOutlet UIBarButtonItem *navBackBtn;
    

    
    
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
}

#pragma mark - TableView Methods -
#pragma mark - Delegates & DataSource
#warning TODO: Room TableView Methods Population
//TODO: Populate table with data!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RoomsTableViewCell* cell = [__tableView dequeueReusableCellWithIdentifier:RoomCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
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
    controller.navTitle = @"UN CUARTO";
    controller.roomWebAddress = @"http://drg06alc81wak.cloudfront.net/360/suite32.html";
    
//    self.animationController = [[ZoomAnimationController alloc] init];
    self.animationController = [[DropAnimationController alloc] init];
    controller.transitioningDelegate  = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark End -

#pragma mark - Nav Bar Methods -
#pragma mark - Button Actions

- (IBAction)navBackButtonAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

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

@end
