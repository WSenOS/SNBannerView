//
//  SNBannerView.m
//  SNBannerViewDemo
//
//  Created by wangsen on 16/8/29.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "SNBannerView.h"
#import "SNBannerCell.h"
#import "UIImageView+WebCache.h"

#define kMinImagesCount 1
#define kDefaultDuration 2.f
#define kPageControlBottom 20.f

typedef NS_ENUM(NSInteger, bannerImageType) {
    bannerImageTypeLocal,//本地
    bannerImageTypeNetworkURL,//网络URL
    bannerImageTypeNetworkModel//网络model
};

static NSString * const bannerIdentifier = @"bannerCell";

@interface SNBannerView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger _maxSections;
    NSInteger _totalPages;
    BOOL _bannerEmpty;
}
@property (nonatomic, assign) bannerImageType bannerImageType;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer * timer;

@end
@implementation SNBannerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = kDefaultDuration;
        self.pageControlBottom = kPageControlBottom;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.duration = kDefaultDuration;
        self.pageControlBottom = kPageControlBottom;
    }
    return self;
}

- (void)setLocalImageNames:(NSArray *)localImageNames {
    self.bannerImageType = bannerImageTypeLocal;
    _localImageNames = localImageNames;
    [self refreshDataAndTiming];
}

- (void)setNetworkImageURLs:(NSArray *)networkImageURLs {
    self.bannerImageType = bannerImageTypeNetworkURL;
    _networkImageURLs = networkImageURLs;
    [self refreshDataAndTiming];
}

- (void)setNetworkModels:(NSArray *)networkModels {
    self.bannerImageType = bannerImageTypeNetworkModel;
    _networkModels = networkModels;
    [self refreshDataAndTiming];
}

- (void)setURLAttributeName:(NSString *)URLAttributeName {
    self.bannerImageType = bannerImageTypeNetworkModel;
    _URLAttributeName = URLAttributeName;
    [self refreshDataAndTiming];
}

- (void)setCurrentPageTintColor:(UIColor *)currentPageTintColor {
    _currentPageTintColor = currentPageTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageTintColor;
}

- (void)setPageTintColor:(UIColor *)pageTintColor {
    _pageTintColor = pageTintColor;
    self.pageControl.pageIndicatorTintColor = pageTintColor;
}

- (void)setPlaceholderImageName:(NSString *)placeholderImageName {
    _placeholderImageName = placeholderImageName;
    [self refreshDataAndTiming];
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
}

- (void)setPageControlBottom:(CGFloat)pageControlBottom {
    _pageControlBottom = pageControlBottom;
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.origin.y = self.bounds.size.height - pageControlBottom;
    self.pageControl.frame = pageControlFrame;
}

- (void)beginTiming {
    [self addTimer];
}

- (void)stopTiming {
    [self removeTimer];
}

- (void)refreshDataAndTiming {
    [self removeTimer];
    [self addTimer];
    [self.collectionView reloadData];
    if (!_bannerEmpty) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_maxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    self.pageControl.numberOfPages = _totalPages;
}

- (void)addTimer {
    NSInteger pages = 0;
    if (self.bannerImageType == bannerImageTypeLocal) {
        _bannerEmpty = !self.localImageNames.count;
        if (self.localImageNames.count <= kMinImagesCount) {
            _maxSections = 1;
            return;
        }
        pages = self.localImageNames.count;
    }
    if (self.bannerImageType == bannerImageTypeNetworkURL) {
        _bannerEmpty = !self.networkImageURLs.count;
        if (self.networkImageURLs.count <= kMinImagesCount) {
            _maxSections = 1;
            return;
        }
        pages = self.networkImageURLs.count;
    }
    if (self.bannerImageType == bannerImageTypeNetworkModel) {
        _bannerEmpty = !self.networkModels.count;
        if (self.networkModels.count <= kMinImagesCount) {
            _maxSections = 1;
            return;
        }
        pages = self.networkModels.count;
    }
    _maxSections = 100;
    _totalPages = pages;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setUpMainView {
    [self refreshDataAndTiming];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _maxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.bannerImageType == bannerImageTypeLocal) {
        return self.localImageNames.count;
    }
    if (self.bannerImageType == bannerImageTypeNetworkURL) {
        return self.networkImageURLs.count;
    }
    return self.networkModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SNBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerIdentifier forIndexPath:indexPath];
    if (self.bannerImageType == bannerImageTypeLocal) {
        cell.bannerImageView.image = [UIImage imageNamed:self.localImageNames[indexPath.item]];
    }
    if (self.bannerImageType == bannerImageTypeNetworkURL) {
        [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:self.networkImageURLs[indexPath.item]] placeholderImage:self.placeholderImageName.length?[UIImage imageNamed:self.placeholderImageName]:nil];
    }
    if (self.bannerImageType == bannerImageTypeNetworkModel) {
        [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[self fetchModelUrl:indexPath.item]] placeholderImage:self.placeholderImageName.length?[UIImage imageNamed:self.placeholderImageName]:nil];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectImageIndex:)]) {
        [self.delegate bannerView:self didSelectImageIndex:indexPath.item];
    }
    if (self.sn_BannerViewSelectImageBlock) {
        self.sn_BannerViewSelectImageBlock(self,indexPath.item);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = 0;
    if (self.bannerImageType == bannerImageTypeLocal) {
        page = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width)%(self.localImageNames.count);
    }
    if (self.bannerImageType == bannerImageTypeNetworkURL) {
        page = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width)%(self.networkImageURLs.count);
    }
    if (self.bannerImageType == bannerImageTypeNetworkModel) {
        page = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width)%(self.networkModels.count);
    }
    self.pageControl.currentPage = page;
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}
//停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)nextImage {
    NSIndexPath * currentIndexPath = [_collectionView indexPathsForVisibleItems].lastObject;
    NSIndexPath * resetIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:_maxSections/2];
    [self.collectionView scrollToItemAtIndexPath:resetIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = resetIndexPath.item+1;
    NSInteger nextSection = resetIndexPath.section;
    
    if (self.bannerImageType == bannerImageTypeLocal) {
        if (nextItem == self.localImageNames.count) {
            nextItem = 0;
            nextSection++;
        }
    }
    if (self.bannerImageType == bannerImageTypeNetworkURL) {
        if (nextItem == self.networkImageURLs.count) {
            nextItem = 0;
            nextSection++;
        }
    }
    if (self.bannerImageType == bannerImageTypeNetworkModel) {
        if (nextItem == self.networkModels.count) {
            nextItem = 0;
            nextSection++;
        }
    }
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (NSString *)fetchModelUrl:(NSInteger)count {
    id obj = self.networkModels[count];
    return [obj valueForKey:self.URLAttributeName];
}

#pragma mark - lazy loading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SNBannerCell class] forCellWithReuseIdentifier:bannerIdentifier];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - self.pageControlBottom, self.bounds.size.width, 10.f)];
        _pageControl.currentPageIndicatorTintColor = self.currentPageTintColor?self.currentPageTintColor:[UIColor redColor];
        _pageControl.pageIndicatorTintColor = self.pageTintColor?self.pageTintColor:[UIColor groupTableViewBackgroundColor];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

@end

@implementation SNBannerView (sn_localImageBannerView)
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                   imageNames:(NSArray *)imageNames
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        _duration = kDefaultDuration;
        _pageControlBottom = kPageControlBottom;
        _bannerImageType = bannerImageTypeLocal;
        _delegate = delegate;
        _localImageNames = imageNames;
        _currentPageTintColor = currentPageTintColor;
        _pageTintColor = pageTintColor;
        
        [self setUpMainView];
    }
    return self;
}

+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                     imageNames:(NSArray *)imageNames
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor {
    
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                            imageNames:imageNames
                  currentPageTintColor:currentPageTintColor
                         pageTintColor:pageTintColor];
}

@end

@implementation SNBannerView (sn_networkImageBannerView)

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                    imageURLs:(NSArray *)URLs
         placeholderImageName:(NSString *)placeholderImageName
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        _duration = kDefaultDuration;
        _pageControlBottom = kPageControlBottom;
        _bannerImageType = bannerImageTypeNetworkURL;
        _delegate = delegate;
        _networkImageURLs = URLs;
        _placeholderImageName = placeholderImageName;
        _currentPageTintColor = currentPageTintColor;
        _pageTintColor = pageTintColor;
        
        [self setUpMainView];
    }
    return self;
}

+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                      imageURLs:(NSArray *)URLs
           placeholderImageName:(NSString *)placeholderImageName
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor {
    
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             imageURLs:URLs
                  placeholderImageName:placeholderImageName
                  currentPageTintColor:currentPageTintColor
                         pageTintColor:pageTintColor];
}

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                        model:(NSArray *)models
             URLAttributeName:(NSString *)URLAttributeName
         placeholderImageName:(NSString *)placeholderImageName
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        _duration = kDefaultDuration;
        _pageControlBottom = kPageControlBottom;
        _bannerImageType = bannerImageTypeNetworkModel;
        _delegate = delegate;
        _networkModels = models;
        _URLAttributeName = URLAttributeName;
        _placeholderImageName = placeholderImageName;
        _currentPageTintColor = currentPageTintColor;
        _pageTintColor = pageTintColor;

        [self setUpMainView];
    }
    return self;
}

+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                          model:(NSArray *)models
               URLAttributeName:(NSString *)URLAttributeName
           placeholderImageName:(NSString *)placeholderImageName
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor {
    
     return [[self alloc] initWithFrame:frame
                               delegate:delegate
                                  model:models
                       URLAttributeName:URLAttributeName
                   placeholderImageName:placeholderImageName
                   currentPageTintColor:currentPageTintColor
                          pageTintColor:pageTintColor];
}

@end