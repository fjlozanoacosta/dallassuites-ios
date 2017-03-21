//
//  SmallMenuTableViewCell.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/29/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "SmallMenuTableViewCell.h"

@implementation SmallMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)hideSeparatorLine {
//    [_separatorLineView setAlpha:.0f];
}

-(void)showSeparatorLine {
    [_separatorLineView setAlpha:.55f];
}

@end
