//
//  ProfileTableViewCell.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/1/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUpCellInfoWithSuiteName:(NSString*)suitName withAction:(NSString*)action withDate:(NSString*)date{
    
    if ([suitName isEqualToString:@""]) {
        [_suiteNameLabel setHidden:YES];
        [self imageViewIsPlusSign];
    } else {
        [_suiteNameLabel setHidden:NO];
        [_suiteNameLabel setText:suitName];
        [self imageViewIsMinusSign];
    }
    
    [_actionLabel setText:action];
    [_dateLabel setText:date];
}


-(void)imageViewIsPlusSign{
    [_plusOrMinusImageView setImage:[UIImage imageNamed:@"profileHistoryPlusSign"]];
}

-(void)imageViewIsMinusSign{
    [_plusOrMinusImageView setImage:[UIImage imageNamed:@"profileHistoryMinusSign"]];
}

@end
