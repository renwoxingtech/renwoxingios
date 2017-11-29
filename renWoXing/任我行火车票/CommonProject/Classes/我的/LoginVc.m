//
//  LoginVc.m
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LoginVc.h"
#import "NSString+Hash.h"
#import "CocoaSecurity.h"
#import "NSString+Encryption.h"
#import "RSA.h"
#import "WXRegisterViewController.h"
#import "UIView+Loading.h"
#import "HomeViewController.h"
#import "AccountManagerVc.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
#pragma clang diagnostic pop

@interface LoginVc ()<UITextFieldDelegate>
{
    UIColor *clor;
    BOOL _isVc;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *pawBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneCuo;

@end

@implementation LoginVc
- (IBAction)changeData:(id)sender {
    
    _pwdField.secureTextEntry = !_pwdField.secureTextEntry;
    
}
- (IBAction)phoneCuo:(id)sender {
    
    [_phoneField setText:@""];
}


- (IBAction)clearData:(id)sender {
    [_pwdField setText:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录任我行账号";
    
    clor  = BlueColor;
    self.pawBtn.hidden = YES;
    self.phoneCuo.hidden = YES;

    if (self.is12306) {
        
        self.title = @"登录12306账号";
        self.rigesterBtn.hidden = YES;
        self.jizhumima.hidden = NO;
        self.zidongdenglu.hidden = NO;
        
        
        NSString *zh = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
        NSString *mm = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];

        _phoneField.text = zh?zh:@"";
        _pwdField.text = mm?mm:@"";
        self.wangjimima.hidden = YES;

        
    }else{
        NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"info.archive"];
        NSString *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _phoneField.text = [info componentsSeparatedByString:@"|"].firstObject;
        _pwdField.text = [info componentsSeparatedByString:@"|"].lastObject;
        self.wangjimima.hidden = NO;
    }
    
    [self shophone];
    [self canLog];
    [self.view endEditing:YES];
}

-(void)backAction{
    if ([self.preObjvalue isKindOfClass:[NSString class]]) {
        if ([self.preObjvalue isEqualToString:@"AccountManagerVc"]) {
            [self.tabBarController setSelectedIndex:0 ];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
        
}
-(void)shophone{
    _phoneField.hidden = NO;
    if (_phoneBtn.height>30) {
        
        
        [UIView animateWithDuration:0.2 animations:^{
            _phoneBtn.height = 15;
            _phoneBtn.titleLabel.font = Font(13);
        }];
    }
    UIButton *btn = (UIButton *)_pwdBtn;
    _pwdField.hidden = NO;
    
    if (btn.height>30) {
        
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.height = 15;
            btn.titleLabel.font = Font(13);
        }];
    }
}
-(void)savePwd{
    if (self.is12306) {
        NSString *info = [NSString stringWithFormat:@"%@|%@",_phoneField.text,_pwdField.text];
        NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"info222.archive"];
        [NSKeyedArchiver archiveRootObject:info toFile:path];
    }else{
        
        NSString *info = [NSString stringWithFormat:@"%@|%@",_phoneField.text,_pwdField.text];
        NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"info.archive"];
        [NSKeyedArchiver archiveRootObject:info toFile:path];
    }
    
}
- (IBAction)tapGes:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_phoneField]) {
        
    }
    return YES;
}
-(void)canLog{
    if (_phoneField.text.length<1) {
        
        
        if (_phoneBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _phoneBtn.height = 44;
                _phoneBtn.titleLabel.font = Font(15);
            }];
        }
    }
    
    if (_pwdField.text.length<1) {
        
        if (_pwdBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _pwdBtn.height = 44;
                _pwdBtn.titleLabel.font = Font(15);
            }];
        }
    }
    if (_pwdField.text.length>0) {
        self.loginBtn.backgroundColor = BlueColor;
    }else{
        self.loginBtn.backgroundColor = clor;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self canLog];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_pwdField.text.length>0) {
        self.loginBtn.backgroundColor = BlueColor;
    }else{
        self.loginBtn.backgroundColor = clor;
    }
    
    return YES;
}

- (IBAction)phoeActt:(UIButton *)sender {
    _phoneField.hidden = NO;
    if (sender.height>30) {
        
        [_phoneField becomeFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
            sender.height = 15;
            sender.titleLabel.font = Font(13);
        }];
    }
}
- (IBAction)pwdAct:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _pwdField.hidden = NO;
    
    if (btn.height>30) {
        [_pwdField becomeFirstResponder];
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.height = 15;
            btn.titleLabel.font = Font(13);
        }];
    }
}

#pragma mark 点击登录
- (IBAction)loginAct:(UIButton *)sender {
    if (_phoneField.text.length<1) {
        return;
    }
    if (_pwdField.text.length<4) {
        [MBProgressHUD showHudWithString:@"密码长度不能小于4" model:MBProgressHUDModeCustomView];
        return;
    }

    //任行登录和12306登录
    if (!self.is12306) {
        
    NSMutableDictionary * dict_M = [NSMutableDictionary dictionary];
    dict_M[@"account"] = _phoneField.text;
    dict_M[@"pwd"] = _pwdField.text;
    [BHUD showLoading:@"登录中"];
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:dict_M] andUrl:@"Action/login/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
         [BHUD dismissHud];
        NSDictionary *dic = obj;
        if ([dic[@"code"] integerValue] == 1) {
            [BHUD dismissHud];
            [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"isrxlogin"];
            [self savePwd];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][@"UToken"] forKey:@"UToken"];
            
            if (self.touchEvent) {
                self.touchEvent(@"");
            }
            
            
            if ([self.preObjvalue isKindOfClass:NSString.class] &&  [self.preObjvalue isEqualToString:@"appdelegate"]) {
                UITabBarController *tabb = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                
                [tabb setSelectedIndex:3];
                
                POP;
                
            }else{
               
                if(self.navigationController.viewControllers.count>=2){
                    NSInteger counn = self.navigationController.viewControllers.count;
                    
                    BaseViewController *vc = self.navigationController.viewControllers[counn-2];
                    if (vc && [vc isKindOfClass:NSClassFromString(@"AccountManagerVc")]) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        return ;
                    }else
                        POP;
                }else
                POP;
            }
        }else{
            [MBProgressHUD showHudWithString:dic[@"msg"] model:MBProgressHUDModeCustomView];
        }
        
    } andError:^(id error) {
        [MBProgressHUD showHudWithString:@"加载失败,请稍后重试" model:MBProgressHUDModeCustomView];
    }];
    }else{
        //12306登录
        [self login12306Act];
    }
    
}
-(void)login12306Act{

    NSDictionary *account = @{@"trainAccount":_phoneField.text,@"pass":_pwdField.text,@"accountversion":@"2"};
NSDictionary *postPar = @{@"data":[account mj_JSONString]};
    [BHUD showLoading:@"登录中"];
    [[Httprequest shareRequest]postObjectByParameters:postPar andUrl:@"Open/validate" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BHUD dismissHud];
            NSString * msg = obj[@"errorMsg"];
            if (obj[@"data"]) {
                NSDictionary *dic = obj[@"data"];
                if (dic[@"isPass"] && [dic[@"isPass"]  integerValue]==0) {
                    [[NSUserDefaults standardUserDefaults] setObject:_phoneField.text forKey:@"zh12306"];
                    [[NSUserDefaults standardUserDefaults] setObject:_pwdField.text forKey:@"mm12306"];
                    
                    [self savePwd];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is12306login"];
                    
                    POP;
                    if (self.touchEvent) {
                        self.touchEvent(_phoneField.text);
                    }
                    
                   
                }else{
                    [BHUD dismissHud];
                    [BHUD showErrorMessage:msg];

                }
            }else{
                [BHUD dismissHud];
                [BHUD showErrorMessage:msg];

                
            }
            
        });
    } andError:^(id error) {
        [BHUD dismissHud];
    }];
    
    
    return;
 
}

#pragma mark 点击注册按钮
- (void)registerAct:(UIButton *)sender {
    
    WXRegisterViewController * registerVC = [[WXRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (IBAction)jizhu:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark 设置导航栏 透明
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController * navVC = self.navigationController;
    _isVc = NO;
    
    for (UIViewController * vcView in [navVC viewControllers]) {
        
        if ([vcView isKindOfClass:[AccountManagerVc class]]) {
            _isVc = YES;
            
        }
        
    }
    if (_isVc) {
        self.navigationItem.hidesBackButton = YES;
        
    }
    else{
        self.navigationItem.hidesBackButton = NO;
    }
    if (!_is12306) {
        //注册
        UIButton * registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont mysystemFontOfSize:13];
        [registerBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(registerAct:) forControlEvents:UIControlEventTouchUpInside];
        registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:registerBtn];
        self.navigationItem.rightBarButtonItem = item;
        
    }
}

#pragma mark 状态栏黑色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
@end
