//
//  UserModel.h
//  Dallas Suites
//
//  Created by Mike Pesate on 11/6/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kNewPasswordAdded,
    kErrorAddingNewPassword
} kAddNewPassword;

@interface UserModel : NSObject

@property (strong, nonatomic) NSString* name,
                                      * lastname,
                                      * username,
                                      * email,
                                      * birthDay,
                                      * password,
                                      * keyWord;
@property (strong, nonatomic) NSNumber* cedula;
@property (strong, nonatomic) NSNumber* idUser;
@property (strong, nonatomic) NSNumber* points;


-(void)registerUserWithUser:(UserModel *)user copletitionHandler:(void (^)(BOOL, NSString*, NSError*))block;

-(void)addPasswordToUser:(UserModel *)user copletitionHandler:(void (^)(NSInteger, NSString*, NSError*))block;

-(void)addPasswordToUser:(UserModel *)user withNewPassword:(NSString*)newPassword withKeyWord:(NSString*)keyword copletitionHandler:(void (^)(NSInteger, NSString*, NSError*))block;

-(void)performUserLogInWithEmail:(NSString*)email withPassword:(NSString*)password withComplitionHandler:(void (^)(UserModel*, NSError*))block;

-(void)getUserPointsReturned:(UserModel*)user withComplitionHandler:(void (^)(NSNumber*, NSError*))block;

-(void)updateUserInfoWithUser:(UserModel *)user copletitionHandler:(void (^)(BOOL, NSString*, NSError*))block;

-(void)recoverUserPasswordWithUserEmail:(NSString*)userEmail withCompletitionHanlder:(void (^)(BOOL, NSString*, NSError*))block;

-(void)updatePasswordForUser:(UserModel *)user withNewPassword:(NSString*)newPassword copletitionHandler:(void (^)(NSInteger, NSString*, NSError*))block;
@end
