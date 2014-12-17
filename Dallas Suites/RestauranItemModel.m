//
//  RestauranItemModel.m
//  Dallas Suites
//
//  Created by Mike Pesate on 12/17/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "RestauranItemModel.h"
#import "ConnectionManager.h"

#define categoryDictinoary @{ @"desayuno" : @"desayuno", @"bebida" : @"bebida" , @"a la plancha" : @"plancha", @"parrilla" : @"parrilla", @"ensaladas" : @"ensalada", @"de picar" : @"picar", @"sandwiches" : @"sandwich", @"pizzas" : @"pizza", @"postres" : @"postre", @"snacks 24 horas" : @"snack"}
#define drinkDictionary @{ @"champagne" : @"champagne", @"espumantes" : @"espumante", @"vinos" : @"vino", @"whiskies" : @"whisky", @"rones" : @"ron", @"vodka" : @"vodka", @"gyn" : @"gyn", @"aperitivos y tragos preparados" : @"aperitivo", @"cocktails" : @"coctel", @"batidos" : @"batido", @"café y té" : @"cafe", @"otras" : @"otras" }

@implementation RestauranItemModel

-(void)getMenuItemInformationOfCategory:(NSString*)category
                              withDrink:(NSString*)drink
                  WithComplitionHandler:(void (^)(NSMutableArray*, NSError*))block{
    
    category = [category lowercaseString];
    
    NSMutableDictionary* parameters = @{@"o"   : @"getRestaurantMenu",
                                        @"cat" : [categoryDictinoary objectForKey:category]}.mutableCopy;
    
    if (drink) {
        drink = [drink lowercaseString];
        [parameters setValue:[drinkDictionary objectForKey:drink] forKey:@"drink"];
    }
    
    id success = ^(AFHTTPRequestOperation *operation, NSArray* responseObject) {
        
        responseArray = [NSMutableArray new];
        
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
            RestauranItemModel* restaurant = [[RestauranItemModel alloc] init];
            restaurant.food_product = [obj objectForKey:@"food_product"];
            restaurant.food_description = [obj objectForKey:@"food_description"];
            restaurant.food_category = [obj objectForKey:@"food_category"];
            restaurant.food_drink = [obj objectForKey:@"food_drink"];
            [responseArray addObject:restaurant];
        }];
        
        block(responseArray, nil);
        
    };
    
    id failure =^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil, error);
        
    };
    [[AFHTTPRequestOperationManager manager] GET:BaseURL parameters:parameters success:success failure:failure];
    
}

@end
