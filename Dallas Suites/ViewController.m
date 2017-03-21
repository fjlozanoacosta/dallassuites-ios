//
//  ViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 1/30/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//
#import "ViewController.h"
#import "QRModel.h"
#import "CRToastManager+DallasUse.h"
#import "DallasToWebPopUp.h"

@interface ViewController () <UIAlertViewDelegate>{
    BOOL awaitingScannedResult;

    __weak IBOutlet UINavigationBar *navBar;
    
    
    __weak IBOutlet UILabel *instructionLabel;
    
    NSInteger numberOfIntents;
    BOOL errorPopUpDisplayed;
    
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//@property (weak, nonatomic) IBOutlet UIView *overlayView;
//@property (weak, nonatomic) IBOutlet UIView *resultsView;
//@property (weak, nonatomic) IBOutlet UILabel *barcodeTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *barcodeStringLabel;
//@property (weak, nonatomic) IBOutlet UILabel *noCameraLabel;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    numberOfIntents = 0;
    errorPopUpDisplayed = NO;
    
    awaitingScannedResult = NO;
    
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    [navBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:20.f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [instructionLabel setFont:[UIFont fontWithName:@"BrandonGrotesque-Medium" size:17.f]];
    
    self.barcodeTypes = TFBarcodeTypeEAN8 | TFBarcodeTypeEAN13 | TFBarcodeTypeUPCA | TFBarcodeTypeUPCE | TFBarcodeTypeQRCODE;
//    self.resultsView.alpha = 0.0f;
//    self.overlayView.alpha = 0.0f;
//    self.noCameraLabel.hidden = self.hasCamera;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    errorPopUpDisplayed = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TFBarcodeScannerViewController

- (void)barcodePreviewWillShowWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
//        self.overlayView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.activityIndicator stopAnimating];
    }];
}

- (void)barcodePreviewWillHideWithDuration:(CGFloat)duration
{
    
}

- (void)barcodeWasScanned:(NSSet *)barcodes
{
//    [self stop];
    if (awaitingScannedResult || errorPopUpDisplayed) return;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    awaitingScannedResult = YES;
    
    [self.view setUserInteractionEnabled:NO];

    
    TFBarcode* barcode = [barcodes anyObject];
//    self.resultsView.hidden = NO;
//    self.barcodeTypeLabel.text = [self stringFromBarcodeType:barcode.type];
//    self.barcodeStringLabel.text = barcode.string;
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.resultsView.alpha = 1.0f;
//    }];
    NSError *jsonError;
    NSData *objectData = [barcode.string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&jsonError];
    
    if (jsonError) {
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Hubo un problema con el ticket. Vuelva a intentarlo." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //        [alert show];
        
        [CRToastManager showToastWithTitle:@"Hubo un problema con el ticket." withSubTitle:@"Vuelva a intentarlo." forError:YES withCompletionBlock:^{
            awaitingScannedResult = NO;
            [self.view setUserInteractionEnabled:YES];
        }];
        [self addError];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        awaitingScannedResult = YES;
        return;

    }
    
    [UIView animateWithDuration:.3f animations:^{
        [_activityIndicator setAlpha:1.f];
        [_activityIndicator startAnimating];
        [self.view bringSubviewToFront:_activityIndicator];
    }];
    
    NSNumber* ticketID = [[json firstObject] objectForKey:@"tid"];
    [self SumbitQRCode:ticketID];

    
    
}

-(void)SumbitQRCode:(NSNumber*)QRCode{

    NSInteger userID = _user.idUser.integerValue;
    NSString* userPassword = _user.password;
    NSNumber* ticketID = QRCode;
    
    [QRModel addPointsToUserWithID:userID withPassword:userPassword withTicketID:ticketID.integerValue withCopletitionHandler:^(BOOL pointsAdded, NSString * msg, NSError * error) {
        [self.view setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:.3f animations:^{
            [_activityIndicator setAlpha:0.f];
            [_activityIndicator stopAnimating];
        }];
        
        if (error) {
            //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"No se pudo conectar con el servidor. Asegurese que tiene internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [alert show];
            [self displayToastWithTitle:@"No se pudo conectar con el servidor." withSubtitle:@"Asegurese que tiene internet." forError:YES];
            [self addError];
            return;
        }
        
        if (!pointsAdded) {
            //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [alert show];
            [self displayToastWithTitle:msg withSubtitle:nil forError:YES];
            [self addError];
            return;
        } else {
            //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Puntos Agregados!" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [alert show];
            [CRToastManager showToastWithTitle:msg withSubTitle:nil forError:NO];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }];



}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanAgainButtonWasTapped
{
    [self start];
    
    [UIView animateWithDuration:0.5 animations:^{
//        self.resultsView.alpha = 0.0f;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toWebPopUp"]) {
        
    }
}

- (void)addError{
     numberOfIntents++;
    if (numberOfIntents >= 3) {
        errorPopUpDisplayed = YES;
        
        DallasToWebPopUp* popUp = [self.storyboard instantiateViewControllerWithIdentifier:@"DallasToWebPopUp"];
        [popUp setQRReaderVC:self];
        [self.navigationController pushViewController:popUp animated:YES];
        
        numberOfIntents = 0;
    }
    
    
    
}


//For Debuging purposes!!!!
- (IBAction)addError:(id)sender{
    [self addError];
}

@end