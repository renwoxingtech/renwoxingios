//
//  AccountManagerVc.m
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AccountManagerVc.h"

@interface AccountManagerVc ()

@end

@implementation AccountManagerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号管理";
    self.tuichu.layer.cornerRadius = 5;
    self.tuichu.layer.masksToBounds = YES;
    self.jiebang.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!UToken) {
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            [self updateWithInfo:obj];
        }
    } andError:nil];
}

-(void)loadNetData{
    if (!UToken) {
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            [self updateWithInfo:obj];
        }
    } andError:nil];
}
-(void)updateWithInfo:(NSDictionary *)dic{
    UserInfo *info = [UserInfo mj_objectWithKeyValues:dic[@"data"]];
    if (!info) {
        
        
        return;
    }
    [self.name setTitle:info.account forState:UIControlStateNormal];
        [self.name setTitle:info.account forState:UIControlStateNormal];
    [self.phone setTitle:info.phone forState:UIControlStateNormal];
    NSString *ziliao = [NSString stringWithFormat:@"%@",info.take_uname];
    [self.gerenzil  setTitle:ziliao forState:UIControlStateNormal];
    [self.peisongxinxi setTitle:info.take_pcc forState:UIControlStateNormal];
    
}
- (IBAction)jiebangAct:(UIButton *)sender {

    BaseViewController *base = (BaseViewController *)[self getVCInBoard:nil ID:@"ChangePhone"];
    
    PUSH(base);
}
- (IBAction)grzlact:(UIButton *)sender {
}
- (IBAction)peisact:(UIButton *)sender {
}
- (IBAction)changpwdAct:(UIButton *)sender {
}
- (IBAction)tuichuAct:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isrxlogin"];
    BaseViewController *vcv = (BaseViewController *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
    
    vcv.preObjvalue = @"AccountManagerVc";
    PUSH(vcv);

}
@end
