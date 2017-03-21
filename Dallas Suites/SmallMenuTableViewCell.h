//
//  SmallMenuTableViewCell.h
//  Dallas Suites
//
//  Created by Mike Pesate on 12/29/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuItemLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

-(void)hideSeparatorLine;
-(void)showSeparatorLine;

@end
