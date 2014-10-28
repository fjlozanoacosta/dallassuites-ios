//
//  MenuTableViewCell.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_menuItemDescriptionLabel setNumberOfLines:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)hideSeparatorLine {
    [_separatorLineView setAlpha:.0f];
}

-(void)showSeparatorLine {
    [_separatorLineView setAlpha:1.0f];
}

@end
