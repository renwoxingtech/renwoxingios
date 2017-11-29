//
//  UIView+WZViewShowHud.h
//  Winzlee
//
//  Created by liwenzhi on 16/5/6.
//  Copyright © 2016年 lwz. All rights reserved.
//
//  展示指示器

#import <UIKit/UIKit.h>

@interface UIView (WZViewShowHud)


#pragma mark - 指示器(Added by Winzlee)
/**
 *  展示仅有文字的提示
 *
 *  @param title 提示文字
 */
- (void)showHUDTextAtCenter:(NSString *)title;
/**
 *  展示指示器
 *
 *  @param indiTitle 提示字
 */
- (void)showHUDIndicatorViewAtCenter:(NSString *)indiTitle;
/**
 *  隐藏指示器
 */
- (void)hideHUDIndicatorViewAtCenter;


@end
