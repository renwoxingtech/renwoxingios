//
//  ZuoXiDZHome.m
//  CommonProject
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ZuoXiDZHome.h"
#import "DZXZVc.h"

@interface ZuoXiDZHome ()

@end

@implementation ZuoXiDZHome

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DZXZVc *base = (DZXZVc *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"gaotie"]) {
        base.preObjvalue = @"高铁动车选座";
        base.from = 1;
    }
    if ([segue.identifier isEqualToString:@"putong"]) {
        base.preObjvalue = @"普通列车选座";
        base.from = 2;

    }
    
    if ([segue.identifier isEqualToString:@"wopu"]) {
        base.preObjvalue = @"卧铺指定上下铺";
        base.from = 3;
    }
    
}

@end
