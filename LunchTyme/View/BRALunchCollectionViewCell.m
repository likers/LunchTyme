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
@property (nonatomic, strong) UIImageView *cellGradientBackgroundView;

@end

@implementation BRALunchCollectionViewCell

@synthesize nameLabel, categoryLabel, backgroundImageView, cellGradientBackgroundView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initBackgroundImageView];
        [self initCellGradientBackgroundView];
        [self initCategoryLabelView];
        [self initNameLabelView];
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
    self.categoryLabel.text = restaurant.type;
    self.nameLabel.text = restaurant.name;
}

- (void)initBackgroundImageView
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundImageView.image = nil;
    [self addSubview:self.backgroundImageView];
    
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [self.backgroundImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [self.backgroundImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
}

- (void)initCellGradientBackgroundView
{
    self.cellGradientBackgroundView = [[UIImageView alloc] init];
    self.cellGradientBackgroundView.image = [UIImage imageNamed:@"CellGradientBackground"];
    self.cellGradientBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.cellGradientBackgroundView];
    
    [self.cellGradientBackgroundView.leftAnchor constraintEqualToAnchor:self.backgroundImageView.leftAnchor].active = true;
    [self.cellGradientBackgroundView.bottomAnchor constraintEqualToAnchor:self.backgroundImageView.bottomAnchor].active = true;
    [self.cellGradientBackgroundView.rightAnchor constraintEqualToAnchor:self.backgroundImageView.rightAnchor].active = true;
}

- (void)initCategoryLabelView
{
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.textColor = [UIColor whiteColor];
    self.categoryLabel.textAlignment = NSTextAlignmentLeft;
    self.categoryLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.categoryLabel];
    
    [self.categoryLabel.leftAnchor constraintEqualToAnchor:self.backgroundImageView.leftAnchor constant:12].active = true;
    [self.categoryLabel.bottomAnchor constraintEqualToAnchor:self.backgroundImageView.bottomAnchor constant:-6].active = true;
    [self.categoryLabel.rightAnchor constraintEqualToAnchor:self.backgroundImageView.rightAnchor].active = true;
}

- (void)initNameLabelView
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.nameLabel];
    
    [self.nameLabel.leftAnchor constraintEqualToAnchor:self.backgroundImageView.leftAnchor constant:12].active = true;
    [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.categoryLabel.topAnchor constant:-6].active = true;
    [self.nameLabel.rightAnchor constraintEqualToAnchor:self.backgroundImageView.rightAnchor].active = true;
}

@end