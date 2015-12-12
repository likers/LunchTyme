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

@synthesize imageUrlString, name, type, phone, twitter, locationDic;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.imageUrlString = @"";
        self.name = @"";
        self.type = @"";
        self.phone = @"";
        self.twitter = @"";
        self.facebook = @"";
        self.locationDic = nil;
        
        self.noContact = NO;
        self.hasTwitter = NO;
        self.hasFacebook = NO;
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    self.imageUrlString = @"";
    self.name = @"";
    self.type = @"";
    self.phone = @"";
    self.twitter = @"";
    self.facebook = @"";
    self.locationDic = nil;
    
    self.noContact = NO;
    self.hasTwitter = NO;
    self.hasFacebook = NO;
    
    if (self)
    {
        self.name = dic[@"name"];
        self.type = dic[@"category"];
        self.imageUrlString = dic[@"backgroundImageURL"];
        if (![dic[@"contact"] isKindOfClass:[NSNull class]])
        {
            self.noContact = NO;
            self.phone = dic[@"contact"][@"formattedPhone"];
            
            if (dic[@"contact"][@"twitter"] != nil)
            {
                self.hasTwitter = YES;
                self.twitter = dic[@"contact"][@"twitter"];
            } else
            {
                self.hasTwitter = NO;
            }
            
            if (dic[@"contact"][@"facebookName"] != nil)
            {
                self.hasFacebook = YES;
                self.facebook = dic[@"contact"][@"facebookName"];
            } else if (dic[@"contact"][@"facebookUsername"] != nil)
            {
                self.hasFacebook = YES;
                self.facebook = dic[@"contact"][@"facebookUsername"];
            } else
            {
                self.hasFacebook = NO;
            }
        } else
        {
            self.noContact = YES;
        }
        self.locationDic = dic[@"location"];
    }
    return self;
}

@end