//
//  BARLunchMapViewController.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/13/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRALunchMapViewController.h"


@implementation BRALunchMapViewController

@synthesize mMapView, locationManager;

//YES: already zoomed in to current location
BOOL zoomedIn;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    zoomedIn = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self setCoordinates];
}

- (void)initNavigationBar
{
    //set bar tint color
    [self.navigationController.navigationBar setBarTintColor:[UIColor BRANavGreen]];
    
    //set title
    self.navigationItem.title = @"Restaurants Map";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
}

- (void)setAnnotationArray:(NSMutableArray *)annotationArray
{
    _annotationArray = annotationArray;
    [self initMapView];
}

- (void)initMapView
{
    mMapView = [[MKMapView alloc] init];
    mMapView.delegate = self;
    mMapView.showsUserLocation = YES;
    mMapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mMapView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(mMapView);
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[mMapView]|"
                               options:0
                               metrics:nil
                               views:views]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[mMapView]|"
                               options:0
                               metrics:nil
                               views:views]];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!zoomedIn) {
        [self setCoordinates];
        zoomedIn = YES;
    }
}

- (void)setCoordinates
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    region.span = span;
    region.center = self.mMapView.userLocation.location.coordinate;
    
    [self.mMapView addAnnotations:self.annotationArray];
    [self.mMapView setRegion:region animated:TRUE];
    [self.mMapView regionThatFits:region];
}

@end