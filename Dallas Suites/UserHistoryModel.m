//
//  UserHistoryModel.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/10/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "UserHistoryModel.h"
#import "ConnectionManager.h"

@implementation UserHistoryModel {
    
    NSMutableArray* responseArray;
    
}

-(void)getUserHistoryForListDisplayWithUser:(UserModel*)user WithComplitionHandler:(void (^)(NSMutableArray*, NSError*))block{
    
    NSDictionary* parameters = @{@"o" : @"getUserHistory",
                                 @"user_id" : user.idUser,
                                 @"user_password" : user.password};
    
    id success = ^(AFHTTPRequestOperation *operation, NSArray* responseObject) {
        
        responseArray = [NSMutableArray new];
        
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
            UserHistoryModel* userHistoryModel = [UserHistoryModel new];
            userHistoryModel.earned_points = [obj objectForKey:@"earned_points"];
            userHistoryModel.used_points = [obj objectForKey:@"used_points"];
            userHistoryModel.visit_timestamp = [[(NSString*)[obj objectForKey:@"visit_timestamp"] componentsSeparatedByString:@" "] objectAtIndex:0];
            userHistoryModel.room_category = [obj objectForKey:@"room_category"];
            userHistoryModel.actionType = ([userHistoryModel.earned_points isEqualToString:@""])? UserRoomHistoryTypeMinus : UserRoomHistoryTypePlus;
            [responseArray addObject:userHistoryModel];
        }];
        
        block(responseArray, nil);
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil, error);
        
    };
    [[AFHTTPRequestOperationManager manager] GET:BaseURL parameters:parameters success:success failure:failure];
    
}

@end
