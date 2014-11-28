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
//        NSString* msg = [responseObject objectForKey:@"msg"];
        
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

-(void)addPasswordToUser:(UserModel *)user withNewPassword:(NSString*)newPassword copletitionHandler:(void (^)(NSInteger, NSString*, NSError*))block{
    
    user.password = newPassword;
    
    [self addPasswordToUser:user copletitionHandler:block];

}

-(void)performUserLogInWithEmail:(NSString*)email withPassword:(NSString*)password withComplitionHandler:(void (^)(UserModel*, NSError*))block{
    
    NSDictionary* parameters = @{ @"user_login" : email,
                                  @"user_password" : password
                                  };
    
    
    id success = ^(AFHTTPRequestOperation *operation, NSArray* responseObject) {
        
        if (responseObject.count == 0) {
            block(nil, nil);
            return;
        }
        
        NSLog(@"%@", [responseObject objectAtIndex:0]);
        
        NSDictionary* userAsJSON = [responseObject objectAtIndex:0];
        UserModel* user = [UserModel new];
        user.idUser = [userAsJSON objectForKey:@"user_id"];
        user.name = [userAsJSON objectForKey:@"user_name"];
        user.lastname = [userAsJSON objectForKey:@"user_lastname"];
        user.username = [userAsJSON objectForKey:@"user_username"];
        user.email = [userAsJSON objectForKey:@"user_email"];
        user.birthDay = [userAsJSON objectForKey:@"user_dob"];
        NSInteger cedula = [(NSString*)[userAsJSON objectForKey:@"user_ci"] integerValue];
        user.cedula = (cedula == 0)?nil:@(cedula);
        user.password = password;
        
        [self getUserPoints:user withComplitionHandler:^(UserModel * user, NSError * error) {
            
            if (error) {
                block(nil, error);
                return;
            }
            
            block(user, nil);
            
        }];
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        block(nil, error);
    };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[BaseURL stringByAppendingString:@"?o=userLogin"] parameters:parameters success:success failure:failure];
    
}

-(void)getUserPoints:(UserModel*)user withComplitionHandler:(void (^)(UserModel*, NSError*))block{
    
    NSDictionary* parameters = @{ @"o" : @"getUserWithPoints",
                                  @"user_id" : user.idUser,
                                  @"user_password" : user.password
                                  };
    
    
    id success = ^(AFHTTPRequestOperation *operation, NSArray* responseObject) {
        
        if (responseObject.count == 0) {
            block(nil, nil);
            return;
        }
        
        NSLog(@"%@", [responseObject objectAtIndex:0]);
        
        NSDictionary* userAsJSON = [responseObject objectAtIndex:0];
        user.points = [userAsJSON objectForKey:@"points_available"];
    
        
        block(user, nil);
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        block(nil, error);
    };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:BaseURL parameters:parameters success:success failure:failure];
    

}

-(void)updateUserInfoWithUser:(UserModel *)user copletitionHandler:(void (^)(BOOL, NSString*, NSError*))block{
    NSDictionary* parameters = @{
                                 //@"o" : @"addUser",
                                 @"user_name" : user.name,
                                 @"user_lastname" : user.lastname,
                                 @"user_username" : user.username,
//                                 @"user_email" : user.email,
                                 @"user_dob" : user.birthDay,
                                 @"user_ci" : user.cedula
                                 };
    
    id success = ^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
        NSLog(@"%@", responseObject);
        
        NSString* error = [responseObject objectForKey:@"error"];
        
        if (error) {
            block(NO,nil,nil);
            return;
        }
        
        block (YES, [responseObject objectForKey:@"msg"], nil);
        
        
        
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        block(nil,nil,error);
    };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[BaseURL stringByAppendingString:@"?o=updateUserInfo"] parameters:parameters success:success failure:failure];

}

-(void)recoverUserPasswordWithUserEmail:(NSString*)userEmail withCompletitionHanlder:(void (^)(BOOL, NSString*, NSError*))block{
    NSDictionary* parameters = @{
                                 @"user_email" : userEmail
                                 };
    
    id success = ^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
        NSLog(@"%@", responseObject);
        
        NSString* error = [responseObject objectForKey:@"error"];
        
        if (error) {
            block(NO,error,nil);
            return;
        }
        
        block (YES, @"Contraseñas reestablecidas con éxito. Revise su correo.", nil);
        
        
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        block(nil,nil,error);
    };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[BaseURL stringByAppendingString:@"?o=resetUserPassword"] parameters:parameters success:success failure:failure];
    
}

@end
