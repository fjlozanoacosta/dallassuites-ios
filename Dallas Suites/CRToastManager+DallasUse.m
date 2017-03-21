//
//  CRToastManager+DallasUse.m
//  Dallas Suites
//
//  Created by Mike Pesate on 1/30/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//

#import "CRToastManager+DallasUse.h"
#import <UIKit/UIKit.h>

@implementation CRToastManager (DallasUse)

+(void)showToastWithTitle:(NSString *)title withSubTitle:(NSString *)subtitle forError:(BOOL)error{

    [self showToastWithTitle:title
                withSubTitle:subtitle
                    forError:error
         withCompletionBlock:nil];
    
//    UIColor* color = [UIColor colorWithRed:245.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
//    
//    if (!error) {
//        color = [UIColor colorWithRed:0.f/255.f green:216.f/255.f blue:119.f/255.f alpha:1.f];
//    }
//    
//    
//    NSMutableDictionary *options = @{
//                              kCRToastTextKey : title,
//                              kCRToastFontKey : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:15.f],
//                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                              kCRToastBackgroundColorKey : color,
//                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
//                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
//                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
//                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
//                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
//                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
//                              kCRToastTimeIntervalKey : @(3)
//                              }.mutableCopy;
//    if (subtitle) {
//        [options setObject:subtitle forKey:kCRToastSubtitleTextKey];
//        [options setObject:[UIFont fontWithName:@"BrandonGrotesque-Regular" size:15.f] forKey:kCRToastFontKey];
//    }
//    
//    [self showNotificationWithOptions:options
//                                completionBlock:^{
//                                    NSLog(@"Completed");
//                                }];
    
    
    
}


+(void)showToastWithTitle:(NSString *)title withSubTitle:(NSString *)subtitle forError:(BOOL)error withCompletionBlock:(CRToasBlock)completionBlock{
    
    UIColor* color = [UIColor colorWithRed:245.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    
    if (!error) {
        color = [UIColor colorWithRed:0.f/255.f green:216.f/255.f blue:119.f/255.f alpha:1.f];
    }
    
    CGFloat fontSize = 15.f;
    
    if (title.length > 40 || subtitle.length > 40) {
        fontSize = 14.f;
    }
    
    NSMutableDictionary *options = @{
                                     kCRToastTextKey : title,
                                     kCRToastFontKey : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:fontSize],
                                     kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                     kCRToastBackgroundColorKey : color,
                                     kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                     kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                     kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                     kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                     kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                     kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                                     kCRToastTimeIntervalKey : @(3)
                                     }.mutableCopy;
    if (subtitle) {
        [options setObject:subtitle forKey:kCRToastSubtitleTextKey];
        [options setObject:[UIFont fontWithName:@"BrandonGrotesque-Regular" size:15.f] forKey:kCRToastFontKey];
    }
    
    [self showNotificationWithOptions:options
                      completionBlock:completionBlock];
    
}




+(void)showToastWithMsg:(NSString *)msg{
    
    NSDictionary *options = @{
                              kCRToastTextKey : msg,
                              kCRToastFontKey : [UIFont fontWithName:@"BrandonGrotesque-Regular" size:15.f],
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor colorWithRed:245.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTimeIntervalKey : @(3)
                              };
    [self showNotificationWithOptions:options
                      completionBlock:^{
                          NSLog(@"Completed");
                      }];
    
}


@end
