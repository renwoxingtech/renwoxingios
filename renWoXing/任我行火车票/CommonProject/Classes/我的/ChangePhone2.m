//
//  ChangePhone2.m
//  CommonProject
//
//  Created by mac on 2017/1/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChangePhone2.h"

@interface ChangePhone2 ()
{
    UIBackgroundTaskIdentifier taskID;
}
@end

@implementation ChangePhone2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)hqyzm:(id)sender {
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"phone":_phoneField.text,@"isreg":@1}] andUrl:@"Action/sendMsg/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dic = obj;
        
        NSString * result = dic[@"result"];
        if ([dic[@"code"] integerValue] == 1) {
            [self startTime:sender];
            
        }
        else{
            [BHUD showLoading:result];
        }
    } andError:^(id error) {
        
    }];
    
}
- (IBAction)sjh:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _phoneField.hidden = NO;
    
    if (btn.height>30) {
        [_phoneField becomeFirstResponder];
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.height = 15;
            btn.titleLabel.font = Font(13);
        }];
    }
}
- (IBAction)yzm:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _yzmField.hidden = NO;
    
    if (btn.height>30) {
        [_yzmField becomeFirstResponder];
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.height = 15;
            btn.titleLabel.font = Font(13);
        }];
    }
}


- (IBAction)sure:(id)sender {
    if ( _phoneField.text.length>4 &&  _yzmField.text.length>4 ) {
        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken,@"phone":_phoneField.text,@"verifycode":_yzmField.text,@"pwd":self.preObjvalue}] andUrl:@"Action/upPhone/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            NSDictionary *dic = obj;
            
            if ([dic[@"code"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    POP;
                });
            }
        } andError:^(id error) {
            
        }];
        
        
        
    }
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
    if (_phoneField.text.length>4 && _yzmField.text.length>4 ) {
        
        _wcbtn.backgroundColor = BlueColor;
    }else{
        _wcbtn.backgroundColor = [UIColor lightGrayColor];
        
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
