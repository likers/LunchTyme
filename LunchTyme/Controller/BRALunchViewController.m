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
#import "BRALunchDetailViewController.h"

@implementation BRALunchViewController

@synthesize resultArray, mCollectionView;

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
    [self.tabBarController.tabBar setBarTintColor:[UIColor BRATabDark]];
    [self initNavigationBar];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Restaurants"])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Restaurants"];
        self.resultArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else
    {
        [self getJsonData];
    }
}

- (void)initNavigationBar
{
    //set bar tint color
    [self.navigationController.navigationBar setBarTintColor:[UIColor BRANavGreen]];
    
    //set title
    self.navigationItem.title = @"Lunch Tyme";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
    
    //init collectionview
    self.mCollectionView.backgroundColor = [UIColor whiteColor];
    [self.mCollectionView registerClass:[BRALunchCollectionViewCell class]
            forCellWithReuseIdentifier:@"customCell"];
    
    //hide navigation text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
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
                    
                    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:self.resultArray];
                    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"Restaurants"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [mCollectionView reloadData];
                    
                    if (jsonError)
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
    return CGSizeMake(DEVICE_WIDTH, DEVICE_WIDTH*9/16);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRALunchDetailViewController *detailVC = [[BRALunchDetailViewController alloc] init];
    detailVC.mRestaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section]];
    UINavigationController *nvc = self.navigationController;
    [nvc pushViewController:detailVC animated:YES];
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