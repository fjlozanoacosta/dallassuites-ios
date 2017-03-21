//
//  QRModel.h
//  Dallas Suites
//
//  Created by Mike Pesate on 1/24/15.
//  Copyright (c) 2015 ICO Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface QRModel : NSObject

+(NSString*)generateUsersQRObjectFromUser:(UserModel*)user;

+(void)addPointsToUserWithID:(NSInteger)userID withPassword:(NSString*)password withTicketID:(NSInteger)ticket_id withCopletitionHandler:(void (^)(BOOL, NSString*, NSError*))block;

@end
