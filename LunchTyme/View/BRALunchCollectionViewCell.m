//
//  BRALunchCollectionViewCell.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/11/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRALunchCollectionViewCell.h"

@interface BRALunchCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *cellGradientBackgroundView;

@end

@implementation BRALunchCollectionViewCell


@synthesize nameLabel, categoryLabel, backgroundImageView, cellGradientBackgroundView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

- (void)setRestaurant:(BRARestaurant *)restaurant
{
    _restaurant = restaurant;
    [self initBackgroundImageView];
    [self initCellGradientBackgroundView];
}

- (void)initBackgroundImageView
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = [UIImage imageNamed:@"Placeholder"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backgroundImageView];
    
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [self.backgroundImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [self.backgroundImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
    [self downloadImageFromUrlString:_restaurant.imageUrlString];
}

- (void)initCellGradientBackgroundView
{
    self.cellGradientBackgroundView = [[UIImageView alloc] init];
    self.cellGradientBackgroundView.image = [UIImage imageNamed:@"CellGradientBackground"];
    self.cellGradientBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.cellGradientBackgroundView];
    
//    [self.cellGradientBackgroundView.heightAnchor constraintEqualToConstant:116].active = true;
//    [self.cellGradientBackgroundView.topAnchor constraintEqualToAnchor:self.backgroundImageView.topAnchor].active = true;
    [self.cellGradientBackgroundView.leftAnchor constraintEqualToAnchor:self.backgroundImageView.leftAnchor].active = true;
    [self.cellGradientBackgroundView.bottomAnchor constraintEqualToAnchor:self.backgroundImageView.bottomAnchor].active = true;
    [self.cellGradientBackgroundView.rightAnchor constraintEqualToAnchor:self.backgroundImageView.rightAnchor].active = true;
}

- (void)downloadImageFromUrlString:(NSString *)urlstring
{
    UIImage *img = [[GlobalVar getInstance] getCachedImageForKey:urlstring];
    if (img)
    {
        self.backgroundImageView.image = img;
    } else
    {
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlstring]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (data)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.backgroundImageView.image = [UIImage imageWithData:data]  ;
                            [[GlobalVar getInstance] cacheImage:self.backgroundImageView.image forKey:urlstring];
                            [self layoutIfNeeded];
                        });
                    
                    } else
                    {
                        self.backgroundImageView.image = [UIImage imageNamed:@"Placeholder"];
                        [self layoutIfNeeded];
                    }
                }] resume];
    }
}

@end