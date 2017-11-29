//
//  MBProgressHUD+Extension.m
//  CommonProject
//
//  Created by 任我行 on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)
+ (void)showHudWithString:(NSString *)string model:(MBProgressHUDMode)mode{

    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    [hud setMode:mode];
    
    hud.labelText = string;
    [hud hide:YES afterDelay:2];
    [hud show:YES];
    
}

+ (void)hideHud{
    
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

+ (void)showHudWithString:(NSString *)string{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    [hud setMode:MBProgressHUDModeIndeterminate];
    
    hud.labelText = string;
    
    [hud show:YES];
    
}
@end
