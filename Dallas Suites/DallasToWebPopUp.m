//
//  DallasToWebPopUp.m
//  Dallas Suites
//
//  Created by Mike Pesate on 5/20/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//

#import "DallasToWebPopUp.h"
@import AVFoundation;

@interface DallasToWebPopUp() <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField* QRCode;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (weak, nonatomic) IBOutlet UIView *videoPreview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerYConstraint;

@end

@implementation DallasToWebPopUp

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if ([self.QRCode isFirstResponder]) {
        [self.QRCode resignFirstResponder];
    }

}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.QRCode setDelegate:self];
    
    //KeyboardNotificatons
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSError *error;

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    
    if (!input) {
        [_videoPreview setBackgroundColor:[UIColor blackColor]];
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_videoPreview.layer.bounds];
    [_videoPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
}



- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)backWithQRCode:(id)sender{

    if(self.QRCode.text.length <= 0 || [self.QRCode.text isEqualToString:@""]){
        [self goBack:nil];
        return;
    }
    
    NSNumber* QRCodeNumber = @([self.QRCode.text integerValue]);
    
    [_QRReaderVC SumbitQRCode:QRCodeNumber];

    [self goBack:nil];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Keyboard Methods -
#pragma mark - Keyboard presenting methods

- (void)keyboardWillShow:(NSNotification *)notification
{
    if ([UIScreen mainScreen].bounds.size.height >= 570){
        return;
    }
    
    //    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    self.containerYConstraint.constant += 90.f;
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([UIScreen mainScreen].bounds.size.height >= 570) {
        return;
    }
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    self.containerYConstraint.constant -= 90.f;
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}





@end
