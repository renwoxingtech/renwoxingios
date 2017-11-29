//
//  AppDelegate.h
//  CommonProject
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailAndPay.h"
#import "WXTabbarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)OrderDetailAndPay *wxpayDelegate;

@property(nonatomic,strong)WXTabbarViewController * tabBarController;
@end

