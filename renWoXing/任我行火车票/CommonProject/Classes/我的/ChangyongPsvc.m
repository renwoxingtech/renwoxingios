//
//  ChangyongPsvc.m
//  CommonProject
//
//  Created by mac on 2017/1/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChangyongPsvc.h"
#import "TWSelectCityView.h"

@interface ChangyongPsvc ()
{
    NSArray *cityIDArr;
    NSDictionary *infoDic;
    UserInfo *userinfo;
}
@end

@implementation ChangyongPsvc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配送信息";
//    self.dh.placeholder = @"请输入联系人电话";
    self.lxr.textColor = qiColor;
    self.dh.textColor = qiColor;
    [self.dz setTintColor:qiColor];
    self.xxdz.textColor = qiColor;
    
    //确定按钮
    UIButton * sureButton = [[UIButton alloc]initWithFrame:CGRectMake(15,280,SWIDTH - 30,47)];
    sureButton.backgroundColor = BlueColor;
    [sureButton setTintColor:[UIColor whiteColor]];
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    if (self.isfromChoose) {
        
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        
    }else{
        
        [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    }

}
-(void)loadNetData{
    if (!UToken) {
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            infoDic = obj[@"data"];
            userinfo = [UserInfo mj_objectWithKeyValues:infoDic];
            cityIDArr = @[userinfo.take_province?userinfo.take_province:@"0",userinfo.take_city?userinfo.take_city:@"0",userinfo.take_county?userinfo.take_county:@"0"];
            [self updateWithInfo:obj];
        }
    } andError:nil];
}
-(void)updateWithInfo:(NSDictionary *)dic{
    UserInfo *info = [UserInfo mj_objectWithKeyValues:dic[@"data"]];
    if (!info) {
        return;
    }
    self.lxr.text = info.take_uname;
    if (info.take_phone.length==1&&[info.take_phone isEqualToString:@"0"]) {
        self.dh.text = @"";
    }else{
        self.dh.text = info.take_phone;
    }
    [self.dz setTitle:info.take_pcc forState:UIControlStateNormal];
    self.xxdz.text = info.take_address;
    
}

#pragma mark 点击确定按钮
-(void)sureChange{
    if (!UToken) {
        return;
    }
    if (cityIDArr.count<1) {
        [MBProgressHUD showHudWithString:@"请选择城市" model:MBProgressHUDModeCustomView];
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken,@"take_uname":_lxr.text,@"take_phone":_dh.text,@"take_address":_xxdz.text,@"take_province":cityIDArr[0],@"take_city":cityIDArr[1],@"take_county":cityIDArr[2],@"take_address":_xxdz.text}] andUrl:@"Action/upTake/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dic = obj;
        
        if ([dic[@"code"] integerValue] == 1) {
            if (self.isfromChoose) {
                if (self.touchEvent) {
     
                    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
                        if ([obj[@"code"] integerValue] == 1) {
                            infoDic = obj[@"data"];
                            userinfo = [UserInfo mj_objectWithKeyValues:infoDic];
                            self.touchEvent(userinfo);
                            POP;

                        }
                    } andError:nil];     
                }
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    POP;
                });
            }
        }
    } andError:^(id error) {
        
    }];

}
-(NSArray *)cityidWithP:(NSString *)pro city:(NSString *)cit cont:(NSString *)cont{
    
    NSString *str = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"addressinfo.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:str];
    NSString *id1 = @"0";
    NSString *id2 = @"0";
    NSString *id3 = @"0";

    for (NSString *key1 in dic) {
        NSDictionary *dic1 = dic[key1];
        
        NSDictionary *cities = dic1[@"city"];
        if ([dic1[@"name"] isEqualToString:pro]) {
            id1 = dic1[@"id"];
            for (NSString *key2 in cities.allKeys) {
                NSDictionary *dic2 = cities[key2];
                
                NSDictionary *conties = dic2[@"county"];
                if ([dic2[@"name"] isEqualToString:cit]) {
                    id2 = dic2[@"id"];
                    if ([conties isKindOfClass:[NSDictionary class]]) {
                        for (NSString *key3 in conties.allKeys){
                            NSDictionary *dic3 = conties[key3];
                            if ([dic3[@"name"] isEqualToString:cont]) {
                                id3 = dic3[@"id"];
                            }
                        }
                    }

                }
            }
        }
        
    }
    return @[id1,id2,id3];
}

#pragma mark 点击选择地址
- (IBAction)dizhiact:(UIButton *)sender {
    [self.view endEditing:YES];
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:CGRectMake(0, NavHeight, SWIDTH, SHEIGHT - (NavHeight)) TWselectCityTitle:@"选择地区"];
    
    [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        cityIDArr = [self cityidWithP:proviceStr city:cityStr cont:distr];
        

         [sender setTitle:[NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,distr] forState:UIControlStateNormal];
    }];
}
@end
