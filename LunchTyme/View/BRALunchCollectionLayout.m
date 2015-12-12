//
//  BRALunchCollectionLayout.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/11/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRALunchCollectionLayout.h"

@implementation BRALunchCollectionLayout

@synthesize itemInsets, itemSize, interItemSpacingY, numberOfColumns;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
}

//- (void)prepareLayout
//{
//    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
//    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
//    
//    NSInteger sectionCount = [self.collectionView numberOfSections];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    
//    for (NSInteger section = 0; section < sectionCount; section++) {
//        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
//        
//        for (NSInteger item = 0; item < itemCount; item++) {
//            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//            
//            UICollectionViewLayoutAttributes *itemAttributes =
//            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
//            
//            cellLayoutInfo[indexPath] = itemAttributes;
//        }
//    }
//    
//    newLayoutInfo[BRALunchCollectionLayoutCellId] = cellLayoutInfo;
//    
//    self.layoutInfo = newLayoutInfo;
//}
//
//- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = indexPath.section / self.numberOfColumns;
//    NSInteger column = indexPath.section % self.numberOfColumns;
//    
//    CGFloat spacingX = self.collectionView.bounds.size.width -
//    self.itemInsets.left -
//    self.itemInsets.right -
//    (self.numberOfColumns * self.itemSize.width);
//    
//    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);
//    
//    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
//    
//    CGFloat originY = floor(self.itemInsets.top +
//                            (self.itemSize.height + self.interItemSpacingY) * row);
//    
//    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
//}

@end