//
//  ViewController.h
//  Dallas Suites
//
//  Created by Mike Pesate on 1/30/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//

#import "TFBarcodeScannerViewController.h"
#import "TFBarcodeScanner.h"
#import "UserModel.h"

@interface ViewController : TFBarcodeScannerViewController

@property (nonatomic) UserModel* user;
-(void)SumbitQRCode:(NSNumber*)QRCode;

@end
