//
//  UserHistoryModel.h
//  Dallas Suites
//
//  Created by Mike Pesate on 11/10/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef enum : NSUInteger {
    UserRoomHistoryTypePlus,
    UserRoomHistoryTypeMinus,
} kUserRoomHistoryType;

@interface UserHistoryModel : NSObject

@property (nonatomic, strong) NSString* earned_points;
@property (nonatomic, strong) NSString* used_points;
@property (nonatomic, strong) NSString* visit_timestamp;
@property (nonatomic, strong) NSString* room_category;
@property NSInteger actionType;

-(void)getUserHistoryForListDisplayWithUser:(UserModel*)user WithComplitionHandler:(void (^)(NSMutableArray*, NSError*))block;

@end
