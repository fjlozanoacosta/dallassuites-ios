//
//  QRReaderViewController.h
//  Dallas Suites
//
//  Created by Mike Pesate on 12/15/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>
#import "UserModel.h"


@interface QRReaderViewController : UIViewController <ZXCaptureDelegate>

@property (nonatomic) UserModel* user;

@end
