//
//  BRALunchViewController.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRALunchViewController.h"
#import "AFNetworking.h"

@implementation BRALunchViewController

@synthesize resultArray,mLunchCollectionView;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self getJsonData];
}

- (void)initNavigationBar
{
    self.navigationItem.title = @"Lunch";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
}

- (void)getJsonData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://sandbox.bottlerocketapps.com/BR_iOS_CodingExam_2015_Server/restaurants.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        resultArray = [[NSArray alloc] initWithArray: responseObject[@"restaurants"]];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end