//
//  RestauranItemModel.h
//  Dallas Suites
//
//  Created by Mike Pesate on 12/17/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestauranItemModel : NSObject {
    NSMutableArray* responseArray;
}

@property (strong, nonatomic) NSString* food_product;
@property (strong, nonatomic) NSString* food_description;
@property (strong, nonatomic) NSString* food_category;
@property (strong, nonatomic) NSString* food_drink;


-(void)getMenuItemInformationOfCategory:(NSString*)category withDrink:(NSString*)drink WithComplitionHandler:(void (^)(NSMutableArray*, NSError*))block;

@end
