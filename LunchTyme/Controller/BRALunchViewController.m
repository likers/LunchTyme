//
//  BRALunchViewController.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRALunchViewController.h"
#import "BRALunchCollectionViewCell.h"

@implementation BRALunchViewController

@synthesize resultArray, mCollectionView;

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
    
    self.mCollectionView.backgroundColor = [UIColor whiteColor];
    [self.mCollectionView registerClass:[BRALunchCollectionViewCell class]
            forCellWithReuseIdentifier:@"customCell"];
}

- (void)getJsonData
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://sandbox.bottlerocketapps.com/BR_iOS_CodingExam_2015_Server/restaurants.json"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                if (httpResp.statusCode == 200)
                {
                    NSError *jsonError;
                    NSDictionary *resultDic =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&jsonError];
                    
                    self.resultArray = [[NSArray alloc] initWithArray:resultDic[@"restaurants"]];
                    
                    if (!jsonError)
                    {
                        [self dataError:jsonError];
                    }
                } else
                {
                    [self dataError:error];
                }
                
            }] resume];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return resultArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRALunchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customCell"
                                              forIndexPath:indexPath];
    BRARestaurant *restaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section]];
    cell.restaurant = restaurant;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEVICE_WIDTH, 180.f);
}

- (void)dataError:(NSError *) error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end