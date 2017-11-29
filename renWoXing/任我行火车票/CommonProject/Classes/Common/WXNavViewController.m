//
//  WXNavViewController.m
//  CommonProject
//
//  Created by 任我行 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WXNavViewController.h"

@interface WXNavViewController ()

@end

@implementation WXNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableDictionary *tabbar_dict = [NSMutableDictionary dictionary];
//    tabbar_dict[NSForegroundColorAttributeName] = WJColor(234, 102, 94);
//    tabbar_dict[NSFontAttributeName] = [UIFont systemFontOfSize:11];
//    [self.tabBarItem setTitleTextAttributes:tabbar_dict forState:UIControlStateNormal];
    //  设置navigation中间title的文字颜色及大小
    //    UINavigationBar *nav =[UINavigationBar appearance];
    NSMutableDictionary *navDicM = [NSMutableDictionary dictionary];
    navDicM[NSForegroundColorAttributeName] = WJColor(255, 255, 255);
    navDicM[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [self.navigationBar setTitleTextAttributes:navDicM];
    //  设置返回页面的图标的颜色
    [self.navigationBar setTintColor: WJColor(255, 255, 255)];
    //  设置导航背景的颜色
//    #define BlueColor [UIColor colorWithRed:40/255.0 green:162/255.0 blue:255/255.0 alpha:1.0]
    [self.navigationBar setBarTintColor:BlueColor];
    //设置返回按钮的图片
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"fanhui_white_icon"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"fanhui_white_icon"];
    //修改默认返回按钮的title文字 把文字设置成透明色
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateHighlighted];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
//        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:nil action:nil];
//        barItem.width = -20;
//        if ([viewController isMemberOfClass:[ShoppCarFinshController class]]) {
//            viewController.navigationItem.rightBarButtonItems = @[barItem,[self getBarButtonItemsWithVC:viewController andTitle:@"完成支付" andAction:@selector(shoppCarFinshVCLeftBarButtonClick)]];
//        }else if ([viewController isKindOfClass:[RecoveryOrdersFinish class]]){
//            viewController.navigationItem.rightBarButtonItems = @[barItem,[self getBarButtonItemsWithVC:viewController andTitle:@"回收完成" andAction:@selector(shoppCarFinshVCLeftBarButtonClick)]];
//        }else{
//            // 左侧的按钮
//            UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItemClick) Image:@"back_arrow" hightImage:@"back_arrow"];
//            viewController.navigationItem.leftBarButtonItems = @[barItem,leftBarButtonItem];
//        }
//    }
//        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui_white_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClick)];
//        viewController.navigationItem.leftBarButtonItems = @[barItem,leftBarButtonItem];
    }
    [super pushViewController:viewController animated:YES];

}
-(void)leftBarButtonItemClick
{
    [self popViewControllerAnimated:YES];
}
@end
