//
//  UIView+Loading.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;
+ (void)loadingView:(UIView *)view;
@end
