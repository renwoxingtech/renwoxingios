//
//  AboutVc.m
//  CommonProject
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AboutVc.h"

@interface AboutVc ()

@end

@implementation AboutVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.logo.layer.cornerRadius = 8;
    self.logo.layer.masksToBounds = YES;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.version.text = app_Version;
    self.detail.text = @"说明：任行抢票APP是由任我行信息技术有限公司于2016年推出，目的是为了方便广大用户更快速便捷的在线购票，更能享受到快递到家，送票到站的贴心服务。\n\n客服热线:4008925515";
}

@end
