//
//  UIView+Loading.m
//  CommonProject
//
//  Created by 任我行 on 2017/10/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"

@implementation UIView (Loading)

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    view = (UIView *)[UIApplication sharedApplication].delegate.window;
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.frame = CGRectMake(0, 0, 82, 110);
    showImageView.center = view.center;
    
    showImageView.animationImages = imgArry;
    
    [showImageView setAnimationRepeatCount:0];
    
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    
    [showImageView startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // 设置图片
    
    hud.labelText = msg;
    hud.labelFont = [UIFont systemFontOfSize:20];
    hud.labelColor = [UIColor redColor];
    
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.customView = showImageView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0];
    
}

+ (void)loadingView:(UIView *)view{
    view = (UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD * HUD = [[MBProgressHUD alloc]initWithView:view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText  = @"登录中";
    [view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:3.0];
}

+ (void)loadingView:(NSString *)title view:(UIView *)view{
    view = (UIView *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD * HUD = [[MBProgressHUD alloc]initWithView:view];
    HUD.mode = MBProgressHUDModeText;
//    HUD.label.text =
    
}

@end
