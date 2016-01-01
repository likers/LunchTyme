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
#import "BRALunchMapViewController.h"


@implementation BRALunchViewController

@synthesize resultArray, annotationArray, previousOrientation, mCollectionView;

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
    
    // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
    }
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Restaurants"])
//    {
//        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Restaurants"];
//        self.resultArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [self getAnnotationArray];
//    } else
//    {
        [self buildPlaceholderArray];
        [self getJsonData];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (previousOrientation && previousOrientation != [[UIDevice currentDevice] orientation])
    {
        [self.mCollectionView.collectionViewLayout invalidateLayout];
    }
    previousOrientation = [[UIDevice currentDevice] orientation];
}

- (void)initNavigationBar
{
    //set bar tint color
    [self.navigationController.navigationBar setBarTintColor:[UIColor BRANavGreen]];
    
    //set title
    self.navigationItem.title = @"Lunch Tyme";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
    
    //right item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MapIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showMap)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //init collectionview
    self.mCollectionView.backgroundColor = [UIColor whiteColor];
    [self.mCollectionView registerClass:[BRALunchCollectionViewCell class]
            forCellWithReuseIdentifier:@"customCell"];
    
    //hide navigation text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void)getJsonData
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
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
                    [self getAnnotationArray];
                    
//                    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:self.resultArray];
//                    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"Restaurants"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
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
    [session finishTasksAndInvalidate];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return resultArray.count%2 == 0 ? resultArray.count/2 : resultArray.count/2+1;
    } else
    {
        return resultArray.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return (section+1)*2 <= resultArray.count ? 2 : 1;
    } else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRALunchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customCell"
                                              forIndexPath:indexPath];
    
    cell.backgroundImageView.image = nil;
    cell.backgroundImageView.alpha = 0;
    cell.backgroundImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    BRARestaurant *restaurant;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        restaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section*2+indexPath.row]];
    } else
    {
        restaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section]];
    }
    
    UIImage *img = [[GlobalVar getInstance] getCachedImageForKey:restaurant.imageUrlString];
    if (img)
    {
        cell.backgroundImageView.image = img;
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut |
         UIViewAnimationOptionAllowUserInteraction animations:^{
             cell.backgroundImageView.alpha = 1;
             cell.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
         } completion:nil];
    } else
    {
        
        dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(backgroundQueue, ^(void) {
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:[NSURL URLWithString:restaurant.imageUrlString]
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        if (data)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                cell.backgroundImageView.image = [UIImage imageWithData:data]  ;
                                [[GlobalVar getInstance] cacheImage:cell.backgroundImageView.image forKey:restaurant.imageUrlString];
                                
                                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut |
                                 UIViewAnimationOptionAllowUserInteraction animations:^{
                                     cell.backgroundImageView.alpha = 1;
                                     cell.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
                                 } completion:nil];
                            });
                            
                        } else
                        {
                            cell.backgroundImageView.image = [UIImage imageNamed:@"Placeholder"];
                            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut |
                             UIViewAnimationOptionAllowUserInteraction animations:^{
                                 cell.backgroundImageView.alpha = 1;
                                 cell.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:nil];
                        }
                    }] resume];
            [session finishTasksAndInvalidate];
        });
    }
    
    cell.restaurant = restaurant;
    
    return cell;
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"[GPPhotoRequest] Session Invalidation: %@", [error description]);
    }
    session = nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake((DEVICE_WIDTH-10)/2, (DEVICE_WIDTH-10)*9/32);
    } else
    {
        return CGSizeMake(DEVICE_WIDTH, DEVICE_WIDTH*9/16);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRALunchDetailViewController *detailVC = [[BRALunchDetailViewController alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        detailVC.mRestaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section*2+indexPath.row]];
    } else
    {
        detailVC.mRestaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section]];
    }
    UINavigationController *nvc = self.navigationController;
    [nvc pushViewController:detailVC animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration
{
    [self.mCollectionView.collectionViewLayout invalidateLayout];
}

- (void)dataError:(NSError *) error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)buildPlaceholderArray
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Restaurant Name",@"name",
                         @"Category Type", @"category"
                         ,nil];
    NSMutableArray *placeholder = [[NSMutableArray alloc] init];
    for (int i = 0; i < 15; i++) {
        [placeholder addObject:dic];
    }
    self.resultArray = placeholder;
}

#pragma mark - 3D touch related
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [mCollectionView indexPathForItemAtPoint:location];
    BRALunchCollectionViewCell *cell = [mCollectionView dequeueReusableCellWithReuseIdentifier:@"customCell" forIndexPath:indexPath];
    
    BRARestaurant *restaurant;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        restaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section*2+indexPath.row]];
    } else
    {
        restaurant = [[BRARestaurant alloc] initWithDic:self.resultArray[indexPath.section]];
    }
    
    BRALunchDetailViewController *detailVC = [[BRALunchDetailViewController alloc] init];
    detailVC.mRestaurant = restaurant;
    detailVC.preferredContentSize = CGSizeMake(0.0, 300);
    [previewingContext setSourceRect:cell.frame];
    return detailVC;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - map

- (void)getAnnotationArray
{
    self.annotationArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.resultArray) {
        CLLocationCoordinate2D track;
        track.latitude = [dic[@"location"][@"lat"] doubleValue];
        track.longitude = [dic[@"location"][@"lng"] doubleValue];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setTitle:dic[@"name"]];
        [annotation setCoordinate:track];
        [self.annotationArray addObject:annotation];
    }
}

- (void)showMap
{
    BRALunchMapViewController *mapVC = [[BRALunchMapViewController alloc] init];
    mapVC.annotationArray = self.annotationArray;
    UINavigationController *nvc = self.navigationController;
    [nvc pushViewController:mapVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end