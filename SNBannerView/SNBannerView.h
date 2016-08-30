//
//  SNBannerView.h
//  SNBannerViewDemo
//
//  Created by wangsen on 16/8/29.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNBannerView;
@protocol SNBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(SNBannerView *)bannerView didSelectImageIndex:(NSInteger)index;

@end

typedef void(^SNBannerViewSelectImageBlock)(SNBannerView * bannerView, NSInteger index);

@interface SNBannerView : UIView
//
@property (nonatomic, weak) id<SNBannerViewDelegate>delegate;
//block回调
@property (nonatomic, copy) SNBannerViewSelectImageBlock sn_BannerViewSelectImageBlock;

/*
 * 本地图片
 */
@property (nonatomic, strong) NSArray * localImageNames;
/*
 * 网络图片 URL
 */
@property (nonatomic, strong) NSArray * networkImageURLs;

/*
 * 网络图片 模型
 * 网络图片 模型对应 URL属性名称
 */
@property (nonatomic, strong) NSArray * networkModels;
@property (nonatomic,   copy) NSString * URLAttributeName;
/*
 * 占位图
 */
@property (nonatomic,   copy) NSString * placeholderImageName;
/*
 * pageControl 当前颜色
 */
@property (nonatomic, strong) UIColor * currentPageTintColor;
/*
 * pageControl 默认颜色
 */
@property (nonatomic, strong) UIColor * pageTintColor;
/*
 * 滚动时间 默认2秒
 */
@property (nonatomic, assign) NSTimeInterval duration;
/*
 * pageControl 距底部高度 默认 20.f
 */
@property (nonatomic, assign) CGFloat pageControlBottom;
//开始计时
- (void)beginTiming;
//停止计时
- (void)stopTiming;

@end

@interface SNBannerView (sn_localImageBannerView)
/*
 * 本地图片
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                   imageNames:(NSArray *)imageNames
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor;

/*
 * 本地图片
 */
+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                     imageNames:(NSArray *)imageNames
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor;

@end

@interface SNBannerView (sn_networkImageBannerView)
/*
 * 网络URL
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                    imageURLs:(NSArray *)URLs
         placeholderImageName:(NSString *)placeholderImageName
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor;
/*
 * 网络URL
 */
+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                      imageURLs:(NSArray *)URLs
           placeholderImageName:(NSString *)placeholderImageName
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor;

/*
 * 模型存储URL
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                        model:(NSArray *)models
             URLAttributeName:(NSString *)URLAttributeName
         placeholderImageName:(NSString *)placeholderImageName
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor;
/*
 * 模型存储URL
 */
+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                          model:(NSArray *)models
               URLAttributeName:(NSString *)URLAttributeName
           placeholderImageName:(NSString *)placeholderImageName
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor;

@end
