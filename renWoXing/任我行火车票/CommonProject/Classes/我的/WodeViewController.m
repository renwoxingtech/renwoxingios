//
//  WodeViewController.m
//  CommonProject
//
//  Created by gaoguangxiao on 2017/1/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WodeViewController.h"
#import "CBAlertView.h"
#import "LoginVc.h"
#import "NormalOrderVc.h"
#import "ChoosePerson.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>


@interface WodeViewController ()<UMSocialShareMenuViewDelegate>

@end

@implementation WodeViewController

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
//}

- (IBAction)denglu12306:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is12306login"]){
        [self login123];
        
        return;
        
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"未登录" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zh12306"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mm12306"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is12306login"];

    }];
    [alert addAction:act1];
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"切换账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self login123];
    }];
    [alert addAction:act2];
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:act3];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)login123{
    LoginVc *vcv = (LoginVc *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
    vcv.preObjvalue=@1;
    vcv.is12306 = YES;
    
    vcv.touchEvent = ^(id value){
        if ([value isKindOfClass:NSString.class]) {
            
            [self.name12306 setTitle:value forState:UIControlStateNormal] ;
        }  
    };
    PUSH(vcv);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self shareyoumeng];
    
    //分享按钮
    UIButton * share_btn = [[UIButton alloc]initWithFrame:CGRectMake(SWIDTH - 65, 30, 50, 50)];
    share_btn.backgroundColor = [UIColor redColor];
    [share_btn addTarget:self action:@selector(showBottomNormalView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share_btn];

    //使scrollview可以上下滑动
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]] && ![obj isKindOfClass:[UITableView class]]) {
            UIScrollView *sc = obj;
            UIView *v = sc.subviews.lastObject;
            CGFloat h = v.bottom+10+69;
            if (h<sc.height) {
                h = sc.height+1;
            }
            sc.contentSize = CGSizeMake(sc.width, h);
        }
    }];
   
    _name.text = @"未登录";
    _phone.text = @"";
}

#pragma mark 点击分享按钮

- (void)shareyoumeng
{
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine),  @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone), @(UMSocialPlatformType_Sina), ]];
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

- (void)showBottomNormalView
{
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_WechatSession)
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }
        else if (platformType == UMSocialPlatformType_WechatTimeLine)
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
        else if (platformType == UMSocialPlatformType_QQ)
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
        else if (platformType == UMSocialPlatformType_Qzone)
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
        else if (platformType == UMSocialPlatformType_Sina)
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
        }
        else{
        }
    }];
}



//- (void)clickShareBtn{
//    NSLog(@"点击分享按钮");
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
//    }];
//}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self loadNetData2];
    
    NSString *zh = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
    
     NSString *mm = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
    
    if (zh != nil && mm != nil) {
         [self.name12306 setTitle:zh forState:UIControlStateNormal] ;
    }
    else{
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)loadNetData2{
    if (!UToken) {
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
           [ [NSUserDefaults standardUserDefaults]setObject:obj[@"data"][@"balance"] forKey:@"ubalance"];
            [ [NSUserDefaults standardUserDefaults]setObject:obj[@"data"][@"id"] forKey:@"userid"];

            [self updateWithInfo:obj];
        }
    } andError:^(id error) {
        
    }];
}
-(void)updateWithInfo:(NSDictionary *)dic{
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"] forKey:@"userInfo"];
    UserInfo *info = [UserInfo mj_objectWithKeyValues:dic[@"data"]];
    if (!info) {
        
        
        return;
    }
//    _name.text = info.account;
    _name.text = info.phone;
    
}

-(IBAction)call:(id)sender{
    NSString *tel = @"4008925515";
    NSString *uul = [NSString stringWithFormat:@"tel://%@",tel];
    
    CBAlertView *vv = [[CBAlertView alloc]initWithTitle:@"拨打客服电话" actionsTitles:@[tel] imgnames:nil showCancel:YES showSure:NO event:^(id value) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:uul]];
        
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"lianxiren"]) {
        ChoosePerson *vc = (ChoosePerson *)segue.destinationViewController;
        vc.isWoTo12306L = YES;
    }
}

- (IBAction)qpdd:(UIButton *)sender {
    NormalOrderVc *vc = (NormalOrderVc *)[self getVCInBoard:@"Main" ID:@"NormalOrderVc"];
    vc.isQpdd = YES;
    
    PUSH(vc);
}
@end
