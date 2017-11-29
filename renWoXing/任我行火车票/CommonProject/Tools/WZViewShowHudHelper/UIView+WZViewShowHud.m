//
//  UIView+WZViewShowHud.m
//  Winzlee
//
//  Created by liwenzhi on 16/5/6.
//  Copyright © 2016年 lwz. All rights reserved.
//
//  展示指示器

#import "UIView+WZViewShowHud.h"
#import "MBProgressHUD.h"



NSInteger const kHUDDefaultTag = 0x98751235;
NSInteger const kHUDOnlyTextTag = 0x98751236;

@implementation UIView (WZViewShowHud)



#pragma mark - 指示器(Added by Winzlee)

#pragma mark public

/**
 *  展示仅有文字的提示
 *
 *  @param title 提示文字
 */
- (void)showHUDTextAtCenter:(NSString *)title
{
    MBProgressHUD *hud = [self getHUDIndicatorViewAtCenterWithTag:kHUDOnlyTextTag];
    
    if (hud == nil){
        
        hud = [self createHUDIndicatorViewAtCenter:title yOffset:0 withTag:kHUDOnlyTextTag mode:MBProgressHUDModeText];
        [hud show:YES];
        
    }else{
        hud.labelText = title;
    }
    //1.5s后自动消失
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.0f];
}
/**
 *  展示指示器
 *
 *  @param indiTitle 提示字
 */
- (void)showHUDIndicatorViewAtCenter:(NSString *)indiTitle
{
    MBProgressHUD *hud = [self getHUDIndicatorViewAtCenterWithTag:kHUDDefaultTag];
    
    if (hud == nil){
        
        hud = [self createHUDIndicatorViewAtCenter:indiTitle yOffset:0 withTag:kHUDDefaultTag mode:MBProgressHUDModeIndeterminate];
        [hud show:YES];
        
    }else{
        hud.labelText = indiTitle;
    }
}
/**
 *  隐藏指示器
 */
- (void)hideHUDIndicatorViewAtCenter
{
    MBProgressHUD *hud = [self getHUDIndicatorViewAtCenterWithTag:kHUDDefaultTag];
    
    [hud hide:YES];
}

#pragma mark private

- (void)hideHud
{
    MBProgressHUD *hud = [self getHUDIndicatorViewAtCenterWithTag:kHUDOnlyTextTag];
    [hud hide:YES];
}

- (MBProgressHUD *)createHUDIndicatorViewAtCenter:(NSString *)indiTitle yOffset:(CGFloat)y withTag:(NSInteger)tag mode:(MBProgressHUDMode)mode
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = indiTitle;
//    hud.detailsLabelText = indiTitle;
    hud.layer.zPosition = 10;
    hud.yOffset = y;
    hud.mode = mode;
    hud.tag = tag;
    [self addSubview:hud];
    return hud;
}
- (MBProgressHUD *)getHUDIndicatorViewAtCenterWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTagNotDeepCounting:tag];
    
    if (view != nil && [view isKindOfClass:[MBProgressHUD class]]){
        
        return (MBProgressHUD *)view;
        
    }else{
        return nil;
    }
}

- (UIView *)viewWithTagNotDeepCounting:(NSInteger)tag
{
    for (UIView *view in self.subviews){
        if (view.tag == tag) {
            return view;
            break;
        }
    }
    return nil;
}




@end
