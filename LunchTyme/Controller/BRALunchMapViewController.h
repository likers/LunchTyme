//
//  BRALunchMapViewController.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/13/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BRALunchMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mMapView;
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
