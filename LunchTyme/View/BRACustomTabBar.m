//
//  CustomTabBar.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRACustomTabBar.h"

@implementation BRACustomTabBar

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 50;
    
    return sizeThatFits;
}

@end