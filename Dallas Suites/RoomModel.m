//
//  RoomModel.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/7/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RoomModel.h"
#import "ConnectionManager.h"



@implementation RoomModel




-(void)getRoomsForListDisplayWithComplitionHandler:(void (^)(NSMutableArray*, NSError*))block{
    
    NSDictionary* parameters = @{@"o" : @"getRoomsAndPoints"};
    
    id success = ^(AFHTTPRequestOperation *operation, NSArray* responseObject) {

        responseArray = [NSMutableArray new];
        
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
            RoomModel* room = [RoomModel new];
            [room setRoom_id:(NSNumber *)[obj objectForKey:@"room_id"]];
            [room setRoom_360:(NSString*)[obj objectForKey:@"room_360"]];
            [room setRoom_cover:(NSString*)[obj objectForKey:@"room_cover"]];
            [room setRoom_category:(NSString*)[obj objectForKey:@"room_category"]];
            [room setRoom_full_redeem:(NSNumber *)[obj objectForKey:@"room_full_redeem"]];
            [room setRoom_full_reward:(NSNumber *)[obj objectForKey:@"room_full_reward"]];
            [room setRoom_promo_redeem:(NSNumber *)[obj objectForKey:@"room_promo_redeem"]];
            [room setRoom_promo_reward:(NSNumber *)[obj objectForKey:@"room_promo_reward"]];
            [room setRoom_description:(NSString *)[obj objectForKey:@"room_description"]];
            [responseArray addObject:room];
        }];
        
        block(responseArray, nil);
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil, error);
        
    };
    [[AFHTTPRequestOperationManager manager] GET:BaseURL parameters:parameters success:success failure:failure];
    
}



@end
