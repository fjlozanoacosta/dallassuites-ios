//
//  UserModel.m
//  Dallas Suites
//
//  Created by Mike Pesate on 11/6/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "UserModel.h"
#import "AFNetworking.h"
#import "ConnectionManager.h"

typedef enum{
    kNewPasswordAdded,
    kErrorAddingNewPassword
} kAddNewPassword;

@implementation UserModel


-(void)registerUserWithUser:(UserModel *)user copletitionHandler:(void (^)(BOOL, NSString*, NSError*))block{
    
    NSDictionary* parameters = @{
                                 //@"o" : @"addUser",
                                 @"user_name" : user.name,
                                 @"user_lastname" : user.lastname,
                                 @"user_username" : user.username,
                                 @"user_email" : user.email,
                                 @"user_dob" : user.birthDay,
                                 @"user_ci" : user.cedula
                                 };
    __block NSString* userUsername = user.username;
    __block NSString* userEmail = user.email;
    
    id success = ^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
        NSString* error = [responseObject objectForKey:@"error"];
        NSString* msg = [responseObject objectForKey:@"msg"];
        
        if (error) {
            if ([error isEqualToString:[NSString stringWithFormat:@"El nombre de usuario '%@' ya est\u00e1 registrado", userUsername]]) {
                NSLog(@"Username Taken");
            } else if ([error isEqualToString:[NSString stringWithFormat:@"El email %@ ya est\u00e1 registrado",userEmail]]) {
                NSLog(@"Email Taken");
            }
            
            block(NO, error, nil);
            
        } else {
            NSArray* userid = [[responseObject objectForKey:@"msg"] componentsSeparatedByString:@"id: "];
            NSInteger  idUser = [[(NSString*)[userid objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"}" withString:@""] integerValue];
            NSLog(@"ID: %i", (int)idUser);
            
            user.idUser = @(idUser);
            
            id addPassBlock = ^(NSInteger flag, NSString* msg, NSError* error){
                if (error) {
                    block(NO, nil, error);
                    return;
                }
                
                if (flag == kErrorAddingNewPassword) {
                    block(NO, msg, nil);
                    return;
                }
                
                block(YES, @"Usuario creado con exito!", nil);
                
            };
            
            [self addPasswordToUser:user copletitionHandler:addPassBlock];
        }
        
        
        
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);

        block(nil,nil,error);
    };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[BaseURL stringByAppendingString:@"?o=addUser"] parameters:parameters success:success failure:failure];

    

}

-(void)addPasswordToUser:(UserModel *)user copletitionHandler:(void (^)(NSInteger, NSString*, NSError*))block{

    NSDictionary* parameters = @{ @"user_id" : user.idUser,
                                  @"user_password" : user.password
                                 };
    
    
    id success = ^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
//        NSString* msg = [responseObject objectForKey:@"msg"];
        NSString* error = [responseObject objectForKey:@"error"];
        
        if (error) {
            block(kErrorAddingNewPassword, @"Password duplicado", nil);
            return;
        }
        
        block(kNewPasswordAdded, @"Password agregado", nil);
        
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        block(kErrorAddingNewPassword, nil, error);
        
    };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[BaseURL stringByAppendingString:@"?o=addPassword"] parameters:parameters success:success failure:failure];
    
}

@end
