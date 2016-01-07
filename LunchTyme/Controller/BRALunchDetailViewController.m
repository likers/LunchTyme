//
//  BRALunchDetailViewController.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/12/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRALunchDetailViewController.h"

@implementation BRALunchDetailViewController

@synthesize mMapView, titleView, contentView;

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
}

- (void)initNavigationBar
{
    //set bar tint color
    [self.navigationController.navigationBar setBarTintColor:[UIColor BRANavGreen]];
    
    //set title
    self.navigationItem.title = @"Lunch Tyme";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
}

- (void)setMRestaurant:(BRARestaurant *)mRestaurant
{
    _mRestaurant = mRestaurant;
    [self initMapView];
    [self setRestaurantCoordinate];
    [self initTitleView];
    [self initContentView];
}

- (void)initMapView
{
    mMapView = [[MKMapView alloc] init];
    mMapView.delegate = self;
    [self.view addSubview:mMapView];
    
    mMapView.translatesAutoresizingMaskIntoConstraints = NO;
    [mMapView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:64].active = true;
    [mMapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [mMapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [mMapView.heightAnchor constraintEqualToConstant:DEVICE_WIDTH*9/16].active = true;
}

- (void)setRestaurantCoordinate
{
    CLLocationCoordinate2D track;
    track.latitude = [_mRestaurant.locationDic[@"lat"] doubleValue];
    track.longitude = [_mRestaurant.locationDic[@"lng"] doubleValue];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.004;
    span.longitudeDelta = 0.004;
    region.span = span;
    region.center = track;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setTitle:_mRestaurant.name];
    [annotation setCoordinate:track];
    [self.mMapView addAnnotation:annotation];
    [self.mMapView setRegion:region animated:TRUE];
    [self.mMapView regionThatFits:region];
}

- (void)initTitleView
{
    //background view
    titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor BRANavGreenDark];
    [self.view addSubview:titleView];
    
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView.topAnchor constraintEqualToAnchor:self.mMapView.bottomAnchor].active = true;
    [titleView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [titleView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [titleView.heightAnchor constraintEqualToConstant:DEVICE_WIDTH*3/16].active = true;
    
    //restaurant name label
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _mRestaurant.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
    [titleView addSubview:nameLabel];
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [nameLabel.leftAnchor constraintEqualToAnchor:titleView.leftAnchor constant:12].active = true;
    [nameLabel.bottomAnchor constraintEqualToAnchor:titleView.centerYAnchor constant:-3].active = true;
    [nameLabel.rightAnchor constraintEqualToAnchor:titleView.rightAnchor constant:-12].active = true;
//    [nameLabel.heightAnchor constraintEqualToConstant:16].active = true;
    
    //restaurant category label
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = _mRestaurant.type;
    categoryLabel.textColor = [UIColor whiteColor];
    categoryLabel.textAlignment = NSTextAlignmentLeft;
    categoryLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    [titleView addSubview:categoryLabel];
    
    categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [categoryLabel.topAnchor constraintEqualToAnchor:titleView.centerYAnchor constant:3].active = true;
    [categoryLabel.leftAnchor constraintEqualToAnchor:titleView.leftAnchor constant:12].active = true;
    [categoryLabel.rightAnchor constraintEqualToAnchor:titleView.rightAnchor constant:-12].active = true;
//    [categoryLabel.heightAnchor constraintEqualToConstant:12].active = true;
}

- (void)initContentView
{
    //background view
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView.topAnchor constraintEqualToAnchor:self.titleView.bottomAnchor].active = true;
    [contentView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [contentView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    
    //restaurant detail address label
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = _mRestaurant.locationDic[@"formattedAddress"][0];
    addressLabel.textColor = [UIColor BRATabDark];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addressLabel.numberOfLines = 0;
    [contentView addSubview:addressLabel];
    
    addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [addressLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:16].active = true;
    [addressLabel.leftAnchor constraintEqualToAnchor:contentView.leftAnchor constant:12].active = true;
    [addressLabel.rightAnchor constraintEqualToAnchor:contentView.rightAnchor constant:-12].active = true;
    
    //restaurant address area label (city, state, zip code)
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.text = _mRestaurant.locationDic[@"formattedAddress"][1];
    areaLabel.textColor = [UIColor BRATabDark];
    areaLabel.textAlignment = NSTextAlignmentLeft;
    areaLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    areaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    areaLabel.numberOfLines = 0;
    [contentView addSubview:areaLabel];
    
    areaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [areaLabel.topAnchor constraintEqualToAnchor:addressLabel.bottomAnchor].active = true;
    [areaLabel.leftAnchor constraintEqualToAnchor:contentView.leftAnchor constant:12].active = true;
    [areaLabel.rightAnchor constraintEqualToAnchor:contentView.rightAnchor constant:-12].active = true;
    
    if (!_mRestaurant.noContact)
    {
        [self initContactUnder:areaLabel];
    }
}

- (void)initContactUnder:(UILabel *) areaLabel
{
    //Restaurant phone number label
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = _mRestaurant.phone;
    phoneLabel.textColor = [UIColor BRATabDark];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    [contentView addSubview:phoneLabel];
    
    phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [phoneLabel.topAnchor constraintEqualToAnchor:areaLabel.bottomAnchor constant:26].active = true;
    [phoneLabel.leftAnchor constraintEqualToAnchor:contentView.leftAnchor constant:12].active = true;
    [phoneLabel.rightAnchor constraintEqualToAnchor:contentView.rightAnchor constant:-12].active = true;
    
    //Restaurant twitter id label
    UILabel *twitterLabel = [[UILabel alloc] init];
    if (_mRestaurant.hasTwitter)
    {
        twitterLabel.text = [NSString stringWithFormat:@"Twitter: @%@", _mRestaurant.twitter];
        twitterLabel.textColor = [UIColor BRATabDark];
        twitterLabel.textAlignment = NSTextAlignmentLeft;
        twitterLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
        [contentView addSubview:twitterLabel];
        
        twitterLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [twitterLabel.topAnchor constraintEqualToAnchor:phoneLabel.bottomAnchor constant:26].active = true;
        [twitterLabel.leftAnchor constraintEqualToAnchor:contentView.leftAnchor constant:12].active = true;
        [twitterLabel.rightAnchor constraintEqualToAnchor:contentView.rightAnchor constant:-12].active = true;
    }
    
    if (_mRestaurant.hasFacebook)
    {
        //Restaurant facebook name label
        UILabel *facebookLabel = [[UILabel alloc] init];
        facebookLabel.text = [NSString stringWithFormat:@"Facebook: %@", _mRestaurant.facebook];
        facebookLabel.textColor = [UIColor BRATabDark];
        facebookLabel.textAlignment = NSTextAlignmentLeft;
        facebookLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
        [contentView addSubview:facebookLabel];
        
        facebookLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if (_mRestaurant.hasTwitter)
        {
            [facebookLabel.topAnchor constraintEqualToAnchor:twitterLabel.bottomAnchor constant:6].active = true;
        } else
        {
            [facebookLabel.topAnchor constraintEqualToAnchor:phoneLabel.bottomAnchor constant:26].active = true;
        }
        [facebookLabel.leftAnchor constraintEqualToAnchor:contentView.leftAnchor constant:12].active = true;
        [facebookLabel.rightAnchor constraintEqualToAnchor:contentView.rightAnchor constant:-12].active = true;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end