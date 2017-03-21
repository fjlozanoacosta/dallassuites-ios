//
//  QRReaderViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/15/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "QRReaderViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "QRModel.h"
#import "CRToastManager+DallasUse.h"

@interface QRReaderViewController () <UIAlertViewDelegate>{
    
    __weak IBOutlet UINavigationBar *navBar;
    
    
    __weak IBOutlet UILabel *instructionLabel;
    
    IBOutletCollection(UIView) NSArray *blackFrame;
    
    BOOL awaitingScannedResult;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;
@property (nonatomic, weak) IBOutlet UILabel *decodedLabel;

@end

@implementation QRReaderViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    awaitingScannedResult = NO;
    
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    [navBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:20.f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;

    
    
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];

    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    
    [blackFrame enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        [self.view bringSubviewToFront:obj];
    }];
    [self.view bringSubviewToFront:navBar];
    
    [instructionLabel setFont:[UIFont fontWithName:@"BrandonGrotesque-Medium" size:17.f]];
    [self.view bringSubviewToFront:instructionLabel];
    
//    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width,
                                                                        480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame,
                                                       captureSizeTransform);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:.5
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [self.view setBackgroundColor:[UIColor clearColor]];
                         
                     }
                     completion:^(BOOL finished) {
                         [self.capture start];
                     }
     ];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result || awaitingScannedResult) return;
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    awaitingScannedResult = YES;
    [self.view setUserInteractionEnabled:NO];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userIsLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@",result.text);
    
    NSError *jsonError;
    NSData *objectData = [result.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];

    if (jsonError) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Hubo un problema con el ticket. Vuelva a intentarlo." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
        
        [CRToastManager showToastWithTitle:@"Hubo un problema con el ticket." withSubTitle:@"Vuelva a intentarlo." forError:YES];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        awaitingScannedResult = NO;
        return;
    }
    
    [UIView animateWithDuration:.3f animations:^{
        [activityIndicator setAlpha:1.f];
        [activityIndicator startAnimating];
        [self.view bringSubviewToFront:activityIndicator];
    }];
    
    NSInteger userID = _user.idUser.integerValue;
    NSString* userPassword = _user.password;
    NSNumber* ticketID = [[json firstObject] objectForKey:@"tid"];
    
    [QRModel addPointsToUserWithID:userID withPassword:userPassword withTicketID:ticketID.integerValue withCopletitionHandler:^(BOOL pointsAdded, NSString * msg, NSError * error) {
        [self.view setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:.3f animations:^{
            [activityIndicator setAlpha:0.f];
            [activityIndicator stopAnimating];
        }];
        
        if (error) {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"No se pudo conectar con el servidor. Asegurese que tiene internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            [self displayToastWithTitle:@"No se pudo conectar con el servidor." withSubtitle:@"Asegurese que tiene internet." forError:YES];
            return;
        }
        
        if (!pointsAdded) {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            [self displayToastWithTitle:msg withSubtitle:nil forError:YES];
            return;
        } else {
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Puntos Agregados!" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            [CRToastManager showToastWithTitle:msg withSubTitle:nil forError:NO];
            return;
        }
        
    }];
    

}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    awaitingScannedResult = NO;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)displayToastWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle forError:(BOOL)forError{
    
    [CRToastManager showToastWithTitle:title withSubTitle:subtitle forError:forError];
    awaitingScannedResult = NO;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
