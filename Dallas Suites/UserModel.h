//
//  UserModel.h
//  Dallas Suites
//
//  Created by Mike Pesate on 11/6/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong, nonatomic) NSString* name,
                                      * lastname,
                                      * username,
                                      * email,
                                      * birthDay,
                                      * password;
@property (strong, nonatomic) NSNumber* cedula;
@property (strong, nonatomic) NSNumber* idUser;
@property (strong, nonatomic) NSNumber* points;


-(void)registerUserWithUser:(UserModel *)user copletitionHandler:(void (^)(BOOL, NSString*, NSError*))block;
-(void)addPasswordToUser:(UserModel *)user copletitionHandler:(void (^)(NSInteger, NSString*, NSError*))block;

-(void)performUserLogInWithEmail:(NSString*)email withPassword:(NSString*)password withComplitionHandler:(void (^)(UserModel*, NSError*))block;

@end
