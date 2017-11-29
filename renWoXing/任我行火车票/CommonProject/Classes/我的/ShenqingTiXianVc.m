//
//  ShenqingTiXianVc.m
//  CommonProject
//
//  Created by mac on 2017/2/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ShenqingTiXianVc.h"

@interface ShenqingTiXianVc ()
{
    CGFloat totalMoney;
    
}
@property (weak, nonatomic) IBOutlet UIButton *money;
@property (weak, nonatomic) IBOutlet UIButton *wxbtn;
@property (weak, nonatomic) IBOutlet UIButton *zfbbtn;
- (IBAction)wxact:(UIButton *)sender;
- (IBAction)zfbact:(UIButton *)sender;
- (IBAction)zfb1:(UIButton *)sender;
- (IBAction)wx1:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *txact;
- (IBAction)txaction:(UIButton *)sender;

@end

@implementation ShenqingTiXianVc

- (void)viewDidLoad {
    [super viewDidLoad];
    totalMoney = 0.0;
    self.wxbtn.selected = YES;
    self.title = @"提现";
    
    NSString *ss = [[NSUserDefaults standardUserDefaults] objectForKey:@"ubalance"];
    if (!ss) {
        ss = @"0";
    }
    NSString *sstext = [NSString stringWithFormat:@"¥%.1f",[ss floatValue]/100.0];
    totalMoney = [ss floatValue]/100.0;
    
    [self.money setTitle:sstext forState:UIControlStateNormal];

    
}

- (IBAction)wxact:(UIButton *)sender {
    self.wxbtn.selected = YES;
    self.zfbbtn.selected = NO;
}

- (IBAction)zfbact:(UIButton *)sender {
    self.wxbtn.selected = NO;
    self.zfbbtn.selected = YES;

}

- (IBAction)zfb1:(UIButton *)sender {
    self.wxbtn.selected = NO;
    self.zfbbtn.selected = YES;

}

- (IBAction)wx1:(UIButton *)sender {
    self.wxbtn.selected = YES;
    self.zfbbtn.selected = NO;

}
- (IBAction)txaction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (totalMoney<20) {
        [MBProgressHUD showHudWithString:@"余额不足20元" model:MBProgressHUDModeCustomView];
        return;
    }

    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken,@"pay_type":_wxbtn.selected?@1:@2,@"pay_account":_field.text,@"pay_price":@(totalMoney)}] andUrl:@"Action/withdraw/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue]==1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } andError:^(id error) {
        
    }];
}
@end
