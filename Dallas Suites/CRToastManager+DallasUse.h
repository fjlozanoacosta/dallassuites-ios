//
//  CRToastManager+DallasUse.h
//  Dallas Suites
//
//  Created by Mike Pesate on 1/30/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//

#import "CRToast.h"

typedef void(^CRToasBlock)();

@interface CRToastManager (DallasUse)

+(void)showToastWithTitle:(NSString*)title withSubTitle:(NSString*)subtitle forError:(BOOL)error;
+(void)showToastWithMsg:(NSString *)msg;
+(void)showToastWithTitle:(NSString *)title withSubTitle:(NSString *)subtitle forError:(BOOL)error withCompletionBlock:(CRToasBlock)completionBlock;

@end
