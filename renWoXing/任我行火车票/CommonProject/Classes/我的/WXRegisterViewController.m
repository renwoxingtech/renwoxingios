//
//  WXRegisterViewController.m
//  CommonProject
//
//  Created by 任我行 on 2017/9/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WXRegisterViewController.h"
#import "IQKeyboardManager.h"
#import "NSString+Hash.h"


//#define Margin 15.f
//#define HeightView 47.f

@interface WXRegisterViewController ()<UITextFieldDelegate>
{
    UITextField * _phoneFieldText;//手机号码
    UITextField * _getCodeFieldText;//验证码
    UITextField * _pwdFieldText;//密码
    UITextField * _rePwdFieldText;//确定密码
    UIButton    * _getCodeBtn;//发送验证码按钮
}
/** 计时器 */
@property (nonatomic, strong) dispatch_source_t timer;
/** 倒计时 */
@property (nonatomic, copy  ) NSString          *second;
/** 收到的短信验证码 */
@property (nonatomic, copy  ) NSString          *mcode;
/** 手机号码 */
@property (nonatomic, copy  ) NSString          *cellPhone;
@end

@implementation WXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册任我行账号";
    self.view.backgroundColor = BgWhiteColor;
    
    //创建UI
    [self creatView];
}

- (void)creatView{
    
    NSInteger Margin = 15;
    NSInteger HeightView = 47;
    NSInteger navHeight = 0;
    if ([UIScreen mainScreen].bounds.size.width == 812) {
        navHeight = 84;
    }
    else{
        navHeight = 64;
    }
    
    NSArray * nameArray = @[@"手机号",@"验证码",@"密码",@"确认密码"];
    NSArray * placeholderArray = @[@"请输入您的手机号码",@"请输入验证码",@"请输入您的密码",@"请再次输入您的密码"];
    
    for (NSInteger i = 0; i < 4; i++) {
        
        UIView * registerView = [[UIView alloc]init];
        if (i == 1){
            registerView.frame = CGRectMake(Margin, (25 + HeightView * i + 10 * i + 0), 232 / SWIDTH * SWIDTH, HeightView);
            
            //获取验证码按钮
            _getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(registerView.right + 15, registerView.top,SWIDTH - (registerView.right + 15) - 15, HeightView)];
            _getCodeBtn.backgroundColor = BlueColor;
            _getCodeBtn.layer.cornerRadius = 5;
            _getCodeBtn.layer.masksToBounds = YES;
            _getCodeBtn.titleLabel.font = Font(14);
            [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_getCodeBtn addTarget:self action:@selector(httpSendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_getCodeBtn];
            
        }
        else{
            registerView.frame  = CGRectMake(Margin, (25 + 47 * i + 10 * i + 0), SWIDTH - 30, HeightView);
        }
//        NSLog(@"%ld    ~~~%lf",NavHeight,(25 + 47 * i + 10 * i + ));
        registerView.layer.cornerRadius = 5;
        registerView.layer.masksToBounds = YES;
        registerView.backgroundColor = [UIColor whiteColor];
        
        UITextField * textField = [[UITextField alloc]init];
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, HeightView)];
        textField.frame = CGRectMake(messageLabel.right, 0, registerView.width - (messageLabel.right + Margin * 2) , HeightView);
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = zhangColor;
        textField.placeholder = placeholderArray[i];
        textField.delegate = self;
        textField.tag = 100 + i;
        if (i == 0 || i == 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        if (i == 1) {
            
        }
        else{
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        
        switch (textField.tag) {
            case 100:
                _phoneFieldText = textField;
                break;
            case 101:
                _getCodeFieldText = textField;
                break;
            case 102:
                _pwdFieldText = textField;
                break;
            case 103:
                _rePwdFieldText = textField;
                break;
                
            default:
                break;
        }
        messageLabel.font = [UIFont systemFontOfSize:14];
        messageLabel.textColor = qiColor;
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.text = nameArray[i];
        [registerView addSubview:messageLabel];
        [registerView addSubview:textField];
        [self.view addSubview:registerView];
        
    }
    
    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 25 + HeightView * 4 + 10 * 4 + 0 + 10, SWIDTH - Margin * 2, HeightView)];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    submitBtn.backgroundColor = BlueColor;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds  = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    

}

#pragma mark 点击发送验证码的按钮
- (void)httpSendCodeAction:(UIButton *)sender{
    if (IsStrEmpty(_phoneFieldText.text)) {
        [MBProgressHUD showHudWithString:@"请输入手机号码" model:MBProgressHUDModeCustomView];
        return;
    }
    if (_phoneFieldText.text.length != 11) {
        [MBProgressHUD showHudWithString:@"请输入正确的手机号码" model:MBProgressHUDModeCustomView];
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"phone":_phoneFieldText.text,@"isreg":@1}] andUrl:@"Action/sendMsg/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dic = obj;
        NSString *msg = EncodeFormDic(dic, @"msg");
        if ([dic[@"code"] integerValue] == 1) {
            _getCodeBtn.userInteractionEnabled = NO;
            _getCodeBtn.backgroundColor = zhangColor;
            [self startTime:sender];
        }
        else{
            NSLog(@"%@",msg);
            [self.view showHUDTextAtCenter:msg];
        }
    } andError:^(id error) {
        
    }];
    return;
}

#pragma mark 定时器
- (void)startTime:(UIButton *)sender{
    __block int count = 60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //1.先创建一个定时器对象
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //2.设置定时器的各种属性
    //(1)什么时候开始定时器
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    //(2)隔多长时间执行一次
    uint64_t interval = (int64_t)(1 * NSEC_PER_SEC);
    //(3)设置定时器
    dispatch_source_set_timer(self.timer, startTime, interval, 0);
    
    //3.设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        count--;
        
        if (count == 0) {
            //取消定时器
            dispatch_cancel(self.timer);
            self.timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                _getCodeBtn.userInteractionEnabled = YES;
                _getCodeBtn.backgroundColor = BlueColor;
                [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ds后重新发送",count] forState:UIControlStateNormal];
            });
        }
        
    });
    
    //4.启动定时器
    dispatch_resume(self.timer);
}


#pragma mark 点击提交按钮
- (void)submitBtnAction:(UIButton *)sender{
    if (IsStrEmpty(_pwdFieldText.text)) {
        [MBProgressHUD showHudWithString:@"请输入密码" model:MBProgressHUDModeCustomView];
        return;
    }
    if (IsStrEmpty(_rePwdFieldText.text)) {
       [MBProgressHUD showHudWithString:@"请再次输入密码" model:MBProgressHUDModeCustomView];
        return;
    }
    if (![_pwdFieldText.text isEqualToString:_rePwdFieldText.text]) {
        [MBProgressHUD showHudWithString:@"两次输入的密码不一致,请重新输入!" model:MBProgressHUDModeCustomView];
        return;
    }
    else{
        NSMutableDictionary * par = [NSMutableDictionary dictionary];
        par[@"phone"] = _phoneFieldText.text;//手机号码
        par[@"verifycode"] = _getCodeFieldText.text;//验证码
        par[@"pwd"] = _pwdFieldText.text;//密码
        
        NSString * lastStr = @"";
        NSArray * allKey = par.allKeys;
        NSArray * resultArray = [allKey sortedArrayUsingSelector:@selector(compare:)];
        for (NSString * key in resultArray)
        {
            lastStr = [lastStr stringByAppendingFormat:@"%@=%@&",key,par[key]];
        }
        if (lastStr.length > 2)
        {
            lastStr = [lastStr substringToIndex:lastStr.length - 1];
        }
        
        NSString * apiKey = @"802a657325e71d88";
        NSString * SN = [NSString stringWithFormat:@"%@&key=%@",lastStr,apiKey];
        NSString * SNMD5 = SN.md5Hash;
        par[@"SN"] = [AppManager md5To16:SNMD5];
        NSDictionary * postPar = @{@"data":[par mj_JSONString]};
        [[Httprequest shareRequest]postObjectByParameters:postPar andUrl:@"Action/new_reg/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            NSDictionary * dic = obj;
            if ([dic[@"code"] integerValue] == 1) {
                if (dic[@"data"]) {
                    NSString * tk = dic[@"data"][@"UToken"];
                    [[NSUserDefaults standardUserDefaults]setObject:tk forKey:@"UToken"];
                    [self LoginPost];
            }
                else{
                    
                }
            }
        } andError:^(id error) {
            
        }];
        
    }
    return;
}

#pragma mark 登录
- (void)LoginPost{
    
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"pwd":_pwdFieldText.text,@"account":_phoneFieldText.text}] andUrl:@"Action/login/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj)
     {
        NSDictionary *dic = obj;
        if ([dic[@"code"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"isrxlogin"];
            [self savePwd];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][@"UToken"] forKey:@"UToken"];
            
            if (self.touchEvent) {
                self.touchEvent(@"");
            }
            [self.navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *tabb = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabb setSelectedIndex:3];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            
        }else{
            [MBProgressHUD showHudWithString:dic[@"msg"] model:MBProgressHUDModeCustomView];
            
        }
        
    } andError:^(id error) {
        
    }];
}

#pragma mark 保存密码
-(void)savePwd{
    NSString *info = [NSString stringWithFormat:@"%@|%@",_phoneFieldText.text,_pwdFieldText.text];
    NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"info.archive"];
    [NSKeyedArchiver archiveRootObject:info toFile:path];
}


- (NSComparisonResult)compare: (NSDictionary *)otherDictionary{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
