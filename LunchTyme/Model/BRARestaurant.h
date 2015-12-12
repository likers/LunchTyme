//
//  BRARestaurant.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/11/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface BRARestaurant : NSObject

//Restaurant image Url
@property (nonatomic, copy) NSString *imageUrlString;

//Restaurant name
@property (nonatomic, copy) NSString *name;

//Restaurant category type
@property (nonatomic, copy) NSString *type;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end