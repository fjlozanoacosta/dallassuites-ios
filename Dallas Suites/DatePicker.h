//
//  MPTDatePicker.h
//  CustomDatePicker
//
//  Created by Mike Pesate on 8/20/14.
//  Copyright (c) 2014 Mike Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIControl

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIPickerView *picker;

-(NSString*)getDateAsString;

@end