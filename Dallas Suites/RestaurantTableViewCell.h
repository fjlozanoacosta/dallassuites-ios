//
//  RestaurantTableViewCell.h
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantItemLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView;


-(void)hideSeparatorLine;
-(void)showSeparatorLine;

@end
