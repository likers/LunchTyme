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

//Restaurant phone number
@property (nonatomic, copy) NSString *phone;

//Restaurant twitter id
@property (nonatomic, copy) NSString *twitter;

//Restaurant facebook id
@property (nonatomic, copy) NSString *facebook;

//Restaurant location dic
@property (nonatomic, strong) NSDictionary *locationDic;

@property (nonatomic, assign) BOOL noContact;
@property (nonatomic, assign) BOOL hasTwitter;
@property (nonatomic, assign) BOOL hasFacebook;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end