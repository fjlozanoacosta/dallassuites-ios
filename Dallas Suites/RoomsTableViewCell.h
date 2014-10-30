//
//  RoomsTableViewCell.h
//  Dallas Suites
//
//  Created by Mike Pesate on 10/27/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *roomBriefDescription;

-(void)tablleViewWillDisplayCellAnimationWithAnimationNumber:(NSInteger)animationNumber;

@end
