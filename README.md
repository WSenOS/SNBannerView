# SNBannerView
## 一个实用高效的bannerView，集成简单，无限滚动

![image](https://github.com/WSenOS/SNBannerView/blob/master/image/image1.png) ![image](https://github.com/WSenOS/SNBannerView/blob/master/image/image2.png)

### 使用方法
#### CocoaPods
```
pod "SNBannerView"  # Podfile
```
#### 示例/用法
##### delegate(optional)
```
- (void)bannerView:(SNBannerView *)bannerView didSelectImageIndex:(NSInteger)index;
```
##### block(optional)
```
@property (nonatomic, copy) SNBannerViewSelectImageBlock sn_BannerViewSelectImageBlock;
```

##### 使用
```
// 基于本地图片
/*
 * imageNames 本地图片名称
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                   imageNames:(NSArray *)imageNames
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor;

+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                     imageNames:(NSArray *)imageNames
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor;

```

```
//基于url
/*
 * URLs 字符串url
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                    imageURLs:(NSArray *)URLs
         placeholderImageName:(NSString *)placeholderImageName
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor;

+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                      imageURLs:(NSArray *)URLs
           placeholderImageName:(NSString *)placeholderImageName
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor;

```

```
//基于 模型
/*
 * models 模型对象 URLAttributeName对应URL属性名称
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<SNBannerViewDelegate>)delegate
                        model:(NSArray *)models
             URLAttributeName:(NSString *)URLAttributeName
         placeholderImageName:(NSString *)placeholderImageName
         currentPageTintColor:(UIColor *)currentPageTintColor
                pageTintColor:(UIColor *)pageTintColor;

+ (instancetype)bannerWithFrame:(CGRect)frame
                       delegate:(id<SNBannerViewDelegate>)delegate
                          model:(NSArray *)models
               URLAttributeName:(NSString *)URLAttributeName
           placeholderImageName:(NSString *)placeholderImageName
           currentPageTintColor:(UIColor *)currentPageTintColor
                  pageTintColor:(UIColor *)pageTintColor;

```

```
//其它用法
/*
  也可自行初始化 相关参数设置详见 .h 文件
**/
```

## 欢迎访问Blog
Blog: https://wsenos.github.io/
## License
[MIT License](https://opensource.org/licenses/MIT)

