
//  Header.h
//  PandaNaughty
//
//  Created by damai on 2018/10/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "BaseCollectionView.h"
//#import "BaseCollectionViewFlowLayout.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"
/**
 手机屏幕
 */

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
//手机型号
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenMaxLength (MAX(kScreenWidth, kScreenHeight))
#define kScreenMinLength (MIN(kScreenWidth, kScreenHeight))
#define kISiPhone5 (kISiPhone && kScreenMaxLength == 568.0)
#define kISiPhone6 (kISiPhone && kScreenMaxLength == 667.0)
#define kISiPhone6P (kISiPhone && kScreenMaxLength == 736.0)
#define kISiPhoneX (kISiPhone && kScreenMaxLength == 812.0)
#define kISiPhoneXr (kISiPhone && kScreenMaxLength == 896.0)
#define kISiPhoneXX (kISiPhone && kScreenMaxLength > 811.0)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)

//状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//标签栏高度
#define kTabBarHeight (kStatusBarHeight > 20 ? 83 : 49)
//导航栏高度
#define kNavBarHeight (kStatusBarHeight + 44)
//安全区高度
#define kSafeAreaBottom (kISiPhoneXX ? 34 : 0)

//6为标准适配的,如果需要其他标准可以修改
#define kScale(w) ((kScreenWidth)/375) * (w)


/**
 手机色彩
 */
//标准RGBA格式
#define kRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#endif /* Header_h */
