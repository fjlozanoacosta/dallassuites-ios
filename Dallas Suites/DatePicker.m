//
//  MPTDatePicker.m
//  CustomDatePicker
//
//  Created by Mike Pesate on 8/20/14.
//  Copyright (c) 2014 Mike Pesate. All rights reserved.
//

#import "DatePicker.h"

#define YearComponent 2
#define MonthComponent 0
#define DayComponent 1



@interface DatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    int day, month, year;
    NSInteger _year;
    NSInteger numberOfYearsToShow;
    BOOL isFebruary;
    
    NSArray* monthArray;
    NSArray* monthDaysArray;
}

@end

@implementation DatePicker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    
    
    monthArray = @[@"ENE", @"FEB", @"MAR", @"ABR", @"MAY", @"JUN", @"JUL", @"AGO", @"SEP", @"OCT", @"NOV", @"DIC"];
    monthDaysArray = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    
    //Get Today' date
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:today];
    NSInteger _day = [dayComponents day];
    NSInteger _month = [dayComponents month];
    _year = [dayComponents year];
    numberOfYearsToShow = _year - (1901 + 17);
    
    NSInteger selectedDay = (self.tag == 0)? 1 : _day;
    NSInteger selectedMonth = (self.tag == 0)? 0 : _month-1;
    NSInteger selectedYear = (self.tag == 0)? 40 : _year;
    
    year = (int)(selectedYear + ((self.tag == 0) ? 1901 : 0));
    month = (int)(selectedMonth + 1);
    day = (int)selectedDay + 1 ;
    
    [self.picker selectRow:selectedDay inComponent:1 animated:NO];
    [self.picker selectRow:selectedYear inComponent:2 animated:NO];
    [self.picker selectRow:selectedMonth inComponent:0 animated:NO];
    [self addSubview:self.picker];
    
    [self.picker reloadAllComponents];
    
    [self setDates];
    
    //Set the dashes on the picker view (Hacked Method - Is Apple's Fault)
    for (id obj in self.picker.subviews) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UIView"]) {
            if (((UIView*)obj).subviews.count == 0) {
                UIView* view = (UIView*)obj;
                [view setBackgroundColor:[UIColor clearColor]];
                [view setFrame:CGRectMake( view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + 2)];
                
                UIColor* DallasColor = [UIColor colorWithRed:233.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f];
                
                UIView* whiteDash = [[UIView alloc] initWithFrame:CGRectMake(42, 0, 55, 1)];
                [whiteDash setBackgroundColor:DallasColor];
                [view addSubview:whiteDash];
                
                whiteDash = [[UIView alloc] initWithFrame:CGRectMake(120, 0, 55, 1)];
                [whiteDash setBackgroundColor:DallasColor];
                [view addSubview:whiteDash];
                
                whiteDash = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 55, 1)];
                [whiteDash setBackgroundColor:DallasColor];
                [view addSubview:whiteDash];
                
            }
        }
        
    }

    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == MonthComponent)
    {
        return 12;
    }
    else if (component == DayComponent)
    {
        return (isFebruary)?[self februaryDays] : ((NSString*)[monthDaysArray objectAtIndex:month-1]).integerValue;
    }
    else // YearComponent
    {
        return numberOfYearsToShow;
    }
}

-(NSInteger)februaryDays{
    
    if ([self leapYear]) {
        return ((NSString*)[monthDaysArray objectAtIndex:1]).integerValue + 1;
    }
    
    return ((NSString*)[monthDaysArray objectAtIndex:1]).integerValue;
}

-(BOOL)leapYear{
    if (year == 0) {
        return NO;
    }
    if ( year % 4 == 0 ) {
        if (year % 100 == 0) {
            if (year % 400 == 0) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return YES;
        }
    }
    
    return NO;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case MonthComponent:
            return 85;
            break;
        case DayComponent:
            return 60;
            break;
        case YearComponent:
            return 90;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIColor* DallasColor = [UIColor colorWithRed:233.f/255.f green:188.f/255.f blue:149.f/255.f alpha:1.f];
    
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont: [UIFont fontWithName:@"BrandonGrotesque-Light" size:24  ]];
    [lblDate setTextColor:DallasColor];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    lblDate.textAlignment = NSTextAlignmentCenter;
    
    if (component == MonthComponent) // MONTH
    {
        [lblDate setText:monthArray[row]];
    }
    else if (component == DayComponent) // DAY
    {
        [lblDate setText:[NSString stringWithFormat:@"%02i", (int)row + 1]];
        
    }
    else if (component == YearComponent) // YEAR
    {
        [lblDate setText:[NSString stringWithFormat:@"%i", (int)(row + ((self.tag == 0) ? 1901 : _year))]];
        
    }
    
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component == YearComponent) {
        year = (int)(((self.tag == 0) ? 1901 : _year) + row);
        [pickerView reloadAllComponents];
    }
    if (component == MonthComponent) {
        if (row == 1) {
            isFebruary = YES;
        } else isFebruary = NO;
        month = (int)row + 1;
        [pickerView reloadAllComponents];
    }
    if (component == DayComponent) {
        day = (int)row + 1;
    }
    
    [self setDates];
    
}

-(void)setDates{
    NSString* myDateAsAStringValue = [NSString stringWithFormat:@"%i-%02i-%02i",year, month, day];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    _date = [df dateFromString: myDateAsAStringValue];
}

-(NSString*)getDateAsString {
    
    NSString* dateAsString = [NSString stringWithFormat:@"%i - %@ - %i", day, [monthArray objectAtIndex:(month-1)], year];
    
    return dateAsString;
    
}

@end