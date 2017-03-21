//
//  RoomModel.h
//  Dallas Suites
//
//  Created by Mike Pesate on 11/7/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define baseThumbnailURL @"http://drg06alc81wak.cloudfront.net/rooms/"

@interface RoomModel : NSObject {
    NSMutableData *_responseData;
    NSMutableArray* responseArray;
}

@property (strong, nonatomic) NSString* room_category,
                                      * room_360,
                                      * room_description,
                                      * room_cover;

@property (strong, nonatomic) NSNumber* room_id,
                                      * room_promo_reward,
                                      * room_full_reward,
                                      * room_promo_redeem,
                                      * room_full_redeem;

@property (strong, nonatomic) UIImage* room_cover_img;

-(void)getRoomsForListDisplayWithComplitionHandler:(void (^)(NSMutableArray*, NSError*))block;

@end
