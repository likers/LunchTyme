//
//  BRALunchViewController.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRARestaurant.h"

@interface BRALunchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, assign) UIDeviceOrientation previousOrientation;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

@end