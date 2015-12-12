//
//  BRALunchDetailViewController.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/12/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import "BRARestaurant.h"

@interface BRALunchDetailViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mMapView;
@property (nonatomic, strong) BRARestaurant *mRestaurant;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *contentView;

@end