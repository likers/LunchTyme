//
//  BRALunchCollectionViewCell.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/11/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRARestaurant.h"

@interface BRALunchCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BRARestaurant *restaurant;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end