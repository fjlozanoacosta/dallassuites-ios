//
//  MenuTableViewCell.h
//  Dallas Suites
//
//  Created by Mike Pesate on 10/28/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuLabel.h"

@interface MenuTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet MenuLabel *menuItemLabel;
@property (weak, nonatomic) IBOutlet MenuLabel *menuItemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

-(void)hideSeparatorLine;
-(void)showSeparatorLine;

@end
