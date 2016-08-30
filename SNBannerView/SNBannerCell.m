//
//  SNBannerCell.m
//  SNBannerViewDemo
//
//  Created by wangsen on 16/8/29.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "SNBannerCell.h"

@implementation SNBannerCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bannerImageView.clipsToBounds = YES;
        self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.bannerImageView];
    }
    return self;
}
@end
