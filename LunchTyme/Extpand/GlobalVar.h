//
//  GlobalVar.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/12/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalVar : NSObject

@property (nonatomic, strong) NSCache *imageCache;

+ (GlobalVar *)getInstance;

// set
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
// get
- (UIImage*)getCachedImageForKey:(NSString*)key;

@end
