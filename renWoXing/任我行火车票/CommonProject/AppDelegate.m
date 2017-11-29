//
//  AppDelegate.m
//  CommonProject
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "IQKeyboardManager.h"
#import "WXTabbarViewController.h"
#import "NewfeatureController.h"
#define STOREAPPID @"1278250760"
#import <UMSocialCore/UMSocialCore.h>

#define USHARE_DEMO_APPKEY @"5a1d0439a40fa34bec0002c2"

@interface AppDelegate ()
{
    UITabBarController *vc;
}
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    
    
    [self processKeyBoard];
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    self.window.backgroundColor = [UIColor whiteColor];
    [WXApi registerApp:@"wx1874aab2a58388ca" withDescription:@"任行app"];
    
    /*
     * 判断是否新版本
     * 如果当前版本和存储沙盒数据不是一个版本则进入引导页
     */
    NSString * key = @"CFBundleShortVersionString";
    //取出沙盒中上次使用存储的版本号
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * lastVersion = [defaults stringForKey:key];
    //获取当前软件的版本号
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        //显示状态栏
        application.statusBarHidden = NO;
        self.tabBarController = [[WXTabbarViewController alloc]init];
        self.window.rootViewController = self.tabBarController;
        [self editStatusBar];
    }
    else{
        //新版本
        self.window.rootViewController = [[NewfeatureController alloc] init];
        //存储新的版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        [self editStatusBar];
    }
    
    [self performSelector:@selector(login) withObject:nil afterDelay:0.35f];
    
    
    
    
    //    //判断是否是最新版本
    //    //如果当前版本和存储沙盒数据不是一个版本则进入引导页
    //    NSString * key = @"CFBundleShortVersionString";
    //    //取出沙盒中存储的上次使用软件的版本号
    //    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //    NSString * lastVersion = [defaults stringForKey:key];
    //    //获取当前软件的版本号
    //    NSString * currentVersion  = [NSBundle mainBundle].infoDictionary[key];
    //    if ([currentVersion isEqualToString:lastVersion]) {
    //
    //    }
    //    else{
    //        //存储新的版本号
    //        [defaults setObject:currentVersion forKey:key];
    //        [defaults synchronize];//同步
    //    }
    
    //版本更新
//     [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/getBanner/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj)
//    https://api.renxing12306.com/index/getVersion
    
    
    [self hsUpdateApp];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)login{
    AFNetworkReachabilityManager * mangerAF = [AFNetworkReachabilityManager sharedManager];
    [mangerAF startMonitoring];
    [mangerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [MBProgressHUD showHudWithString:@"请您检查网络" model:MBProgressHUDModeCustomView];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //网络关闭的时候
                [MBProgressHUD showHudWithString:@"请您检查网络" model:MBProgressHUDModeCustomView];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                [MBProgressHUD showHudWithString:@"ableViaWWAN有网络" model:MBProgressHUDModeCustomView];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [MBProgressHUD showHudWithString:@"ableViaWiFi有网络" model:MBProgressHUDModeCustomView];
                break;
                
            default:
                break;
        }
    }];
}



#pragma mark - 设置状态栏字体颜色
- (void)editStatusBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark 版本更新检测
//0不需要更新  1需要更新
-(void)hsUpdateApp
{
    [[Httprequest shareRequest]postObjectByParameters:nil andUrl:@"index/getVersion" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        NSLog(@"obj:%@",obj);
        if ([obj[@"code"] integerValue] == 1) {
            if ([obj[@"data"][@"needupdata"] isEqualToString:@"0"]) {
                
            }
            
            if ([obj[@"data"][@"needupdata"] isEqualToString:@"1"]) {
                //2先获取当前工程项目版本号
                NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
                
                //3从网络获取appStore版本号
                NSError *error;
                NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",STOREAPPID]]] returningResponse:nil error:nil];
                if (response == nil) {
                    NSLog(@"你没有连接网络哦");
                    return;
                }
                
                NSString * str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                
                NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                //    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                if (error) {
                    NSLog(@"hsUpdateAppError:%@",error);
                    return;
                }
                //    NSLog(@"%@",appInfoDic);
                NSArray *array = appInfoDic[@"results"];
                NSDictionary *dic = array[0];
                NSString *appStoreVersion = dic[@"version"];
                //打印版本号
                NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
                //4当前版本号小于商店版本号,就更新
                NSString * newVersion = appStoreVersion;
                NSString * version = currentVersion;
                newVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@"0"];
                version = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@"0"];
                
                if(version.integerValue < newVersion.integerValue)
                {
                    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alertVC addAction:actionCancle];
                    UIAlertAction * actionOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //6此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]];
                        [[UIApplication sharedApplication] openURL:url];
                    }];
                    [alertVC addAction:actionOk];
                    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
                }else{
                    NSLog(@"版本号好像比商店大噢!检测到不需要更新");
                }
            }
        }
    } andError:^(id error) {
        
    }];
    
    return;

    }

- (void)processKeyBoard{
    
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    
    manager.enable = YES;
    
    manager.shouldResignOnTouchOutside = YES;
    
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    manager.enableAutoToolbar = YES;
    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self.wxpayDelegate];
}
///ios 9.0以前的
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //支付宝
    {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //            NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResultNotify" object:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
            return [WXApi handleOpenURL:url delegate:self.wxpayDelegate];
        }
        else{
            //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
            BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
            if (!result) {
                // 其他如支付等SDK的回调
            }
            return result;
        }
    
    }
    
    
    
    
}


///ios 9.0以后可用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    //支付宝
    {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //            NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResultNotify" object:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
    }
    //微信
    return [WXApi handleOpenURL:url delegate:self.wxpayDelegate];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
//    /* 钉钉的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
//
//    /* 支付宝的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    
    
//    /* 设置易信的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//
//    /* 设置点点虫（原来往）的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    
//    /* 设置领英的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
//
//    /* 设置Twitter的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    
//    /* 设置Facebook的appKey和UrlString */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:nil];
//
//    /* 设置Pinterest的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
//
//    /* dropbox的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    
//    /* vk的appkey */
//    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}

@end
