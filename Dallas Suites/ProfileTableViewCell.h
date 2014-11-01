//
//  ProfileTableViewCell.h
//  Dallas Suites
//
//  Created by Mike Pesate on 11/1/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *plusOrMinusImageView;
@property (weak, nonatomic) IBOutlet UILabel *suiteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void)setUpCellInfoWithSuiteName:(NSString*)suitName withAction:(NSString*)action withDate:(NSString*)date;

@end
