//
//  RestaurantTableViewCell.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RestaurantTableViewCell.h"

@implementation RestaurantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)hideSeparatorLine {
    [_separatorLineView setAlpha:.0f];
}

-(void)showSeparatorLine {
    [_separatorLineView setAlpha:.55f];
}


-(void)tablleViewWillDisplayCellAnimationWithAnimationNumber:(NSInteger)animationNumber{
    //[cell.bgImage setAlpha:.0f];
    [self.iconImage.layer setTransform:CATransform3DMakeRotation( 180.f / 180.f * M_PI, .0f, .0f, 1.0f)];
    
    int animationControl = 1;
    if (animationNumber % 2 == 0) {
        animationControl = -1;
    }
    
    
    CATransform3D transform = CATransform3DMakeRotation(M_PI, .0f, .0f, .0f);
    
    [UIView animateWithDuration:.5f animations:^{
        self.iconImage.layer.transform = transform;
    }];
}

@end
