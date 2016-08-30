//
//  ViewController.m
//  SNBannerViewDemo
//
//  Created by wangsen on 16/8/29.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "ViewController.h"
#import "SNBannerView.h"
#import "SNImageModel.h"
@interface ViewController () <SNBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //本地图片
    SNBannerView * bannerView = [[SNBannerView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 100) delegate:self imageNames:@[@"1",@"2",@"3",@"4"] currentPageTintColor:[UIColor cyanColor] pageTintColor:nil];
    [self.bgView addSubview:bannerView];
    
    //URL
    NSArray *URLs = @[@"http://scimg.jb51.net/allimg/160716/105-160G61F250436.jpg",
                      @"http://www.apoints.com/graphics/UploadFiles/200803/20080301202754140.jpg",
                      @"http://image.tianjimedia.com/uploadImages/2015/129/56/J63MI042Z4P8.jpg"];
    SNBannerView * netBannerView = [[SNBannerView alloc] initWithFrame:CGRectMake(0, 184, [UIScreen mainScreen].bounds.size.width, 100) delegate:nil imageURLs:nil placeholderImageName:nil currentPageTintColor:nil pageTintColor:nil];
    [self.bgView addSubview:netBannerView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        netBannerView.networkImageURLs = URLs;
    });
    netBannerView.sn_BannerViewSelectImageBlock = ^(SNBannerView * bannerView, NSInteger index){
        NSLog(@"%zd",index);
    };
    
    //Model
    NSMutableArray * tempArray = [NSMutableArray array];
    NSInteger p_id = 0;
    for (NSString * urlStr in URLs) {
        SNImageModel * im = [[SNImageModel alloc] init];
        im.picture = urlStr;
        im.p_id = @(p_id).stringValue;
        p_id++;
        [tempArray addObject:im];
    }
    
    SNBannerView * modelBannerView = [[SNBannerView alloc] initWithFrame:CGRectMake(0, 304, [UIScreen mainScreen].bounds.size.width, 100) delegate:nil model:@[tempArray.firstObject] URLAttributeName:@"picture" placeholderImageName:nil currentPageTintColor:nil pageTintColor:nil];
    [self.bgView addSubview:modelBannerView];
}

- (void)bannerView:(SNBannerView *)bannerView didSelectImageIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
