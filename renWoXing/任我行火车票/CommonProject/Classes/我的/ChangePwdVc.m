//
//  ChangePwdVc.m
//  CommonProject
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChangePwdVc.h"

@interface ChangePwdVc ()
{
    UIBackgroundTaskIdentifier taskID;
}
@end

@implementation ChangePwdVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    _phoneField.hidden = NO;
    _yzmField.hidden = NO;
    _xmmField.hidden = NO;
    _qrmmField.hidden = NO;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _yzmField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.placeholder = @"请输入您的手机号码";
    _yzmField.placeholder = @"请输入验证";
    _xmmField.placeholder = @"请输入您的密码";
    _qrmmField.placeholder = @"请再次输入您的密码";
    _wcbtn.backgroundColor = BlueColor;
    self.yzmBtn.layer.cornerRadius = 5;
    self.yzmBtn.layer.masksToBounds = YES;
    self.wcbtn.layer.cornerRadius = 5;
    self.wcbtn.layer.masksToBounds = YES;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (IBAction)hqyzm:(id)sender {
    if (_phoneField.text.length<4) {
        [MBProgressHUD showHudWithString:@"请输入手机号" model:MBProgressHUDModeCustomView];
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"phone":_phoneField.text,@"isreg":@0}] andUrl:@"Action/sendMsg/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dic = obj;
        NSString * msg = dic[@"result"];
        if ([dic[@"code"] integerValue] == 1) {
            [self startTime:sender];
        }
        else{
             [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
        }
    } andError:^(id error) {
        
    }];
}
- (IBAction)sjh:(id)sender {
    [_phoneField becomeFirstResponder];
}
- (IBAction)yzm:(id)sender {
        [_yzmField becomeFirstResponder];
}
- (IBAction)xmm:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _xmmField.hidden = NO;
    
    if (btn.height>30) {
        [_xmmField becomeFirstResponder];
    }
}
- (IBAction)qrmm:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _qrmmField.hidden = NO;
    
    if (btn.height>30) {
        [_qrmmField becomeFirstResponder];
    }
}
- (IBAction)sure:(id)sender {
    if (_phoneField.text.length<4) {
        [MBProgressHUD showHudWithString:@"请填写手机号" model:MBProgressHUDModeCustomView];
        return;
    }
    if (_yzmField.text.length<4) {
         [MBProgressHUD showHudWithString:@"请填写验证码" model:MBProgressHUDModeCustomView];
        return;
    }
    if (_xmmField.text.length<4) {
        [MBProgressHUD showHudWithString:@"请填写密码" model:MBProgressHUDModeCustomView];
        return;
    }
    if (_yzmField.text.length<4) {
        [MBProgressHUD showHudWithString:@"请再次填写密码" model:MBProgressHUDModeCustomView];
        return;
    }
    if (![_xmmField.text isEqualToString:_qrmmField.text]) {
         [MBProgressHUD showHudWithString:@"两次密码输入不一致" model:MBProgressHUDModeCustomView];
        return;
    }
        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"phone":_phoneField.text,@"verifycode":_yzmField.text,@"pwd":_qrmmField.text}] andUrl:@"Action/upPassword/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            NSDictionary *dic = obj;
            
            if ([dic[@"code"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    POP;
                });
            }
        } andError:^(id error) {
            
        }];
        
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_phoneField.text.length<1) {
        
        
        if (_phoneBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _phoneBtn.height = 44;
                _phoneBtn.titleLabel.font = Font(15);
            }];
        }
    }
    if (_yzmField.text.length<1) {
        
        
        if (_yzmBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _yzmBtn.height = 44;
                _yzmBtn.titleLabel.font = Font(15);
            }];
        }
    }
    if (_xmmField.text.length<1) {
        
        
        if (_xmmBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _xmmBtn.height = 44;
                _xmmBtn.titleLabel.font = Font(15);
            }];
        }
    }
    if (_qrmmField.text.length<1) {
        
        
        if (_qrmmBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _qrmmBtn.height = 44;
                _qrmmBtn.titleLabel.font = Font(15);
            }];
        }
    }
}


-(void)startTime:(UIButton *)l_timeButton{
    
    //    UIButton *l_timeButton = self.getyzmBtn;
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self endBack];

                [l_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = YES;
                l_timeButton.enabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout;
            taskID=  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [self endBack];
            }];
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                ////NSLog(@"____%@",strTime);
                //                l_timeButton.titleLabel.font = Font(14);
                [l_timeButton setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

-(void)endBack
{
    [[UIApplication sharedApplication] endBackgroundTask:taskID];
    taskID = UIBackgroundTaskInvalid;
}
@end
