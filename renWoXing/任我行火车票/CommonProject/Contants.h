//
//  Contants.h
//  CommonProject
//
//  Created by 任我行 on 2017/9/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#ifndef OverSeaOnline_Contants_h
#define OverSeaOnline_Contants_h
/**
 *   字符串是否为空
 */
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

#define EncodeFormDic(dic,key) [dic[key] isKindOfClass:[NSString class]] ? dic[key] :([dic[key] isKindOfClass:[NSNumber class]] ? [dic[key] stringValue]:@"")

/**
 *   屏幕的宽高
 */
#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height


#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

/**
 *   颜色说明
 */
#define BlueColor [UIColor colorWithRed:40/255.0 green:162/255.0 blue:255/255.0 alpha:1.0]
#define OrangeColor [UIColor colorWithRed:252/255.0 green:110/255.0 blue:81/255.0 alpha:1]
#define zhangColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define TitleColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define biaoTiColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]

#define huangTiColor [UIColor colorWithRed:255/255.0 green:159/255.0 blue:1/255.0 alpha:1.0]

#define qiColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]

#define jieGuoColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]

#define BgWhiteColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]

#define CCColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]
#define E5Color [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]

/**
 *   RGB颜色WJ
 */
#define WJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/**
 *   随机色
 */
#define WJRandomColor WJColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/**
 *   按照十六进制设置颜色值
 */
#define WJHEXColor(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

/**
 *   ios系统版本
 */
#define ios8x [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f
#define ios7x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define ios6x [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define iosNot6x [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

/**
 *   屏幕
 */
#define iphone4x_3_5 ([UIScreen mainScreen].bounds.size.height==480.0f)

#define iphone5x_4_0 ([UIScreen mainScreen].bounds.size.height==568.0f)

#define iphone6_4_7 ([UIScreen mainScreen].bounds.size.height==667.0f)

#define iphone6Plus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)


/**
 *   屏幕的适配
 */
#define isIPhone5       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6p      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


#define PUSH(vc) [self.navigationController pushViewController:vc animated:YES];
#define POP [self.navigationController popViewControllerAnimated:YES];
#define NavHeight  (SHEIGHT == 812.0) ? 84 : 64
#define  UToken   [[NSUserDefaults standardUserDefaults] objectForKey:@"UToken"]
#define APIKEY  @"802a657325e71d88"
#define HTKEY @"AwCT4ccslMB3TFQ6M8H6qadrOT8ZCXVg"
#define HTDESKEY @"v66r9ogtcvtxv3v4xq3gog8fqdbhwmt0"

#endif /* Contants_h */
