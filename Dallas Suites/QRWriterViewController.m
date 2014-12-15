//
//  QRWriterViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/15/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "QRWriterViewController.h"
#import <ZXingObjC/ZXingObjC.h>

@interface QRWriterViewController () {

    __weak IBOutlet UIImageView* QRCode;
    
    
}

@end

@implementation QRWriterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateQRCode];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)generateQRCode{
    
    
    NSString *data = @"Un texto";
    if (data == 0) return;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:data
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
