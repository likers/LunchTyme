//
//  BRALunchViewController.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRALunchViewController : UIViewController

@property (nonatomic, strong) NSArray *resultArray;
@property (weak, nonatomic) IBOutlet UICollectionView *mRestaurantCollectionView;

@end