//
//  BeveragesTableViewCell.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/16/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "BeveragesTableViewCell.h"

@implementation BeveragesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [_dot.layer setCornerRadius:_dot.frame.size.width/2];
    [_dot setClipsToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
