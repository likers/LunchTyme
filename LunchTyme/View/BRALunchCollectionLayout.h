//
//  BRALunchCollectionLayout.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/11/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const BRALunchCollectionLayoutCellId = @"customCell";

@interface BRALunchCollectionLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end
