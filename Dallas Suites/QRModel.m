//
//  QRModel.m
//  Dallas Suites
//
//  Created by Mike Pesate on 1/24/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//

#import "QRModel.h"
#import "AFNetworking.h"
#import "ConnectionManager.h"


@implementation QRModel

+(NSString*)generateUsersQRObjectFromUser:(UserModel*)user{
    
    return [NSString stringWithFormat:@"[{\"id\":\"%@\",\"pwd\":\"%@\"}]", user.idUser, user.password];
    
}


+(void)addPointsToUserWithID:(NSInteger)userID withPassword:(NSString*)password withTicketID:(NSInteger)ticket_id withCopletitionHandler:(void (^)(BOOL, NSString*, NSError*))block{
    
    NSDictionary* parameters = @{
                                 //@"o" : @"addUser",
                                 @"user_id" : @(userID),
                                 @"user_password" : password,
                                 @"ticket_id" : @(ticket_id)
                                 };
    
    id success = ^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
        //        NSString* msg = [responseObject objectForKey:@"msg"];
        NSString* error = [responseObject objectForKey:@"error"];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if (error) {
            block(false, error, nil);
            return;
        }
        
        block(true, msg, nil);
        
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        block(false, nil, error);
        
    };

    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[BaseURL stringByAppendingString:@"?o=addPoints"] parameters:parameters success:success failure:failure];

}

@end
