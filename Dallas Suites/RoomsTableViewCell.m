//
//  RoomsTableViewCell.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/27/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RoomsTableViewCell.h"

@implementation RoomsTableViewCell

- (void)awakeFromNib {
    // Initialization code    
    [_roomBriefDescription setNumberOfLines:2];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tablleViewWillDisplayCellAnimationWithAnimationNumber:(NSInteger)animationNumber{
    //[cell.bgImage setAlpha:.0f];
    [self.roomBriefDescription setAlpha:.0f];
    [self.roomName setAlpha:.0f];
    
    int animationControl = 1;
    if (animationNumber % 2 == 0) {
        animationControl = -1;
    }
    
    [self.roomName.layer setTransform:CATransform3DMakeTranslation( -320.f * animationControl, .0f, .0f)];
    [self.roomBriefDescription.layer setTransform:CATransform3DMakeTranslation( 320.f * animationControl, .0f, .0f)];
    
    CATransform3D transform = CATransform3DMakeTranslation(.0f, .0f, .0f);
    
    [UIView animateWithDuration:.5f animations:^{
        [self.bgImage setAlpha:1.f];
        [self.roomBriefDescription setAlpha:1.f];
        [self.roomName setAlpha:1.f];
        self.roomName.layer.transform = self.roomBriefDescription.layer.transform = transform;
    }];
}

@end
