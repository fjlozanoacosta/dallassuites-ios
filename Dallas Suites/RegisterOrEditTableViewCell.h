//
//  RegisterOrEditTableViewCell.h
//  Dallas Suites
//
//  Created by Mike Pesate on 11/1/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterOrEditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UITextField *textEditField;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end
