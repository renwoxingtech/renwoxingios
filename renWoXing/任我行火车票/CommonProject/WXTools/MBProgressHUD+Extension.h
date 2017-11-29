//
//  MBProgressHUD+Extension.h
//  CommonProject
//
//  Created by 任我行 on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)
+ (void)showHudWithString:(NSString *)string model:(MBProgressHUDMode)mode;
+ (void)hideHud;
+ (void)showHudWithString:(NSString *)string;
@end
