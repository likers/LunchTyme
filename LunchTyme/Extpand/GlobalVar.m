//
//  GlobalVar.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/12/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVar.h"

@implementation GlobalVar

@synthesize imageCache;

static GlobalVar *instance = nil;

+(GlobalVar *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key
{
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSString*)key
{
    return [self.imageCache objectForKey:key];
}

@end