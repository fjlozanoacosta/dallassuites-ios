//
//  QRWriterViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/15/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "QRWriterViewController.h"
#import <ZXingObjC/ZXingObjC.h>
#import "QRModel.h"

@interface QRWriterViewController () {

    __weak IBOutlet UIImageView* QRCode;
    
    __weak IBOutlet UINavigationBar *navBar;
    
}

@end

@implementation QRWriterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBarBg"] forBarMetrics:UIBarMetricsDefault];
    
    [self generateQRCode];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)generateQRCode{
    

    NSString *qRInfo = [QRModel generateUsersQRObjectFromUser:_user];
    
//    @"[{\"id\" : \" " + userID + "\",\"pwd\":\"" + userPwd + "\"}]"
    if (qRInfo == 0) return;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:qRInfo
                                  format:kBarcodeFormatQRCode
                                   width:QRCode.frame.size.width
                                  height:QRCode.frame.size.width
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        QRCode.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        QRCode.image = nil;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
