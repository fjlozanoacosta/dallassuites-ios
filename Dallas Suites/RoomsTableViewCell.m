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

@end
