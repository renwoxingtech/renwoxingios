//
//  WXTabbarViewController.m
//  CommonProject
//
//  Created by 任我行 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WXTabbarViewController.h"
#import "WXNavViewController.h"
#import "HomeViewController.h"
#import "QiangpiaoFSHomeVc.h"
#import "WodeViewController.h"
#import "ZuoXiDZHome.h"
@interface WXTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation WXTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;

    BaseViewController *homeVC =  (BaseViewController *)[AppManager getVCInBoard:nil ID:@"HomeViewController"];
    [self addChildViewController:homeVC image:@"huochepiao-zhihui" selectedImage:@"huochepiao" title:@"车票预订"];
     BaseViewController *qiangpiaoVC =  (BaseViewController *)[AppManager getVCInBoard:nil ID:@"ZuoXiDZHome"];
    [self addChildViewController:qiangpiaoVC image:@"zuoxi-zhihui" selectedImage:@"zuoxi" title:@"坐席定制"];
    BaseViewController *zuoXiVC =  (BaseViewController *)[AppManager getVCInBoard:nil ID:@"QiangpiaoFSHomeVc"];
 
    [self addChildViewController:zuoXiVC image:@"qiangpiao-zhihui" selectedImage:@"qiangpiao" title:@"抢票"];
     BaseViewController *
    woDeVC=  (BaseViewController *)[AppManager getVCInBoard:nil ID:@"WodeViewController"];
    [self addChildViewController:woDeVC image:@"gerenzhongxin" selectedImage:@"gerenzhongxin-lan" title:@"个人中心"];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isrxlogin"];
    if ([viewController isKindOfClass:[WXNavViewController class]]) {
        WXNavViewController *nav =(WXNavViewController *)viewController;
        if (!isLogin && [nav.topViewController isKindOfClass:NSClassFromString(@"WodeViewController")]) {
            BaseViewController *vcv = (BaseViewController *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
            UINavigationController *nav = self.selectedViewController;
            vcv.preObjvalue = @"appdelegate";
            [nav pushViewController:vcv animated:YES];
            return  NO;
        }
    }
    return YES;
}
-(void)addChildViewController:(UIViewController*)controller image:(NSString *)imagename  selectedImage:(NSString *)selectedImage title:(NSString *)title
{
//    controller.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.image = [UIImage imageNamed:imagename];
    controller.tabBarItem.title = title;
    // 设置字体的颜色
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = qiColor;
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    NSMutableDictionary *selectdictM = [NSMutableDictionary dictionary];
    selectdictM[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    selectdictM[NSForegroundColorAttributeName] = BlueColor;
    [controller.tabBarItem setTitleTextAttributes:dictM forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:selectdictM forState:UIControlStateSelected];
    WXNavViewController *nav = [[WXNavViewController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}

@end
