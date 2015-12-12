//
//  BRARestaurant.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/11/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRARestaurant.h"

@implementation BRARestaurant

@synthesize imageUrlString, name, type;

- (instancetype)init
{
    if (self = [super init])
    {
        self.imageUrlString = @"";
        self.name = @"";
        self.type = @"";
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.name = dic[@"name"];
        self.type = dic[@"category"];
        self.imageUrlString = dic[@"backgroundImageURL"];
    }
    return self;
}

@end