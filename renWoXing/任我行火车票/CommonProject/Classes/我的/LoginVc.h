//
//  LoginVc.h
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginVc : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *tiplable;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *rigesterBtn;
- (IBAction)loginAct:(UIButton *)sender;
- (IBAction)registerAct:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *jizhumima;
@property (weak, nonatomic) IBOutlet UIButton *zidongdenglu;
- (IBAction)jizhu:(UIButton *)sender;
@property (nonatomic,assign)BOOL is12306;
@property (weak, nonatomic) IBOutlet UIButton *wangjimima;

@end
