//
//  YaoqingVc.m
//  CommonProject
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "YaoqingVc.h"

@interface YaoqingVc ()
{
    NSMutableArray *yaoqingData;
    NSMutableArray *tixianData;
    
}
@end

@implementation YaoqingCell



@end

@implementation YaoqingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    yaoqingData = [NSMutableArray array];
    tixianData = [NSMutableArray array];
    
    NSString *yqm = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    self.yaoqingma.text = [NSString stringWithFormat:@"我的邀请码:%@",yqm];
    self.yaoqingma.layer.cornerRadius = self.yaoqingma.height*0.5;
    self.yaoqingma.layer.masksToBounds = YES;
    [self.yaoqingma sizeToFit];
    self.yaoqingma.width+=10;
    self.yaoqingma.centerX = self.view.centerX;
    self.title = @"邀请返利";
}
-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
    
    NSString *ss = [[NSUserDefaults standardUserDefaults] objectForKey:@"ubalance"];
    if (!ss) {
        ss = @"0";
    }
    self.yue.text = [NSString stringWithFormat:@"¥%.1f",[ss floatValue]/100.0];
}
-(void)share{
    //初始化分享控件
//    UIImage *im = [self.view snapshotImage];
    
    
    UIActivityViewController *activeViewController = [[UIActivityViewController alloc]initWithActivityItems:@[BaseUrlIp] applicationActivities:nil];
    //不显示哪些分享平台(具体支持那些平台，可以查看Xcode的api)
    activeViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList];
    [self presentViewController:activeViewController animated:YES completion:nil];
}
-(void)loadNetData{
    if (!UToken) {
        return;
    }

    //邀请记录
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/inviteLog/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dic = obj;
        [yaoqingData removeAllObjects];
        if ([dic[@"code"] integerValue] == 1) {
            [yaoqingData addObjectsFromArray:dic[@"data"]];
            [self.mainTableView reloadData];
        }
    } andError:^(id error) {
        
    }];
    
    
    //提现记录
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/withdrawLog/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dic = obj;
        
        if ([dic[@"code"] integerValue] == 1) {
            [tixianData addObjectsFromArray:dic[@"data"]];
            [self.mainTableView reloadData];
        }
    } andError:^(id error) {
        
    }];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return yaoqingData.count;
        
    }else{
        return tixianData.count;
        
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resue = @"yqcell";
    YaoqingCell *cell = [tableView dequeueReusableCellWithIdentifier:resue];
 
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section==0) {
        NSDictionary *dic = yaoqingData[indexPath.row];
//        "i_account" = kalunren1;
        //                 rebate = 100;
        //                 rtime = 1487144731;
        cell.zhanghao.text = [NSString stringWithFormat:@"邀请账号:%@",dic[@"i_account"]?dic[@"i_account"]:@""];
        CGFloat jien = [dic[@"rebate"] integerValue];
        
        cell.fanlijine.text = [NSString stringWithFormat:@"返利:¥%.1f",jien/100.0];
        NSTimeInterval tm = [dic[@"rtime"] floatValue];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tm];
        NSString *dateStr = [AppManager stringFromDate:date format:@"yyyy-MM-dd"];
        
        cell.shijian.text = [NSString stringWithFormat:@"%@",dateStr];

    }else{
        NSDictionary *dic =tixianData[indexPath.row];
//        {
//            applytime = 1487149937;
//            "pay_account" = jkk;
//            "pay_price" = 2000;
//            "pay_type" = 1;
//        },

        NSInteger pay_type = [dic[@"pay_type"] integerValue];
        CGFloat jien = [dic[@"pay_price"] floatValue];

        cell.zhanghao.text = [NSString stringWithFormat:@"%@",pay_type==1?@"微信":@"支付宝"];
        cell.fanlijine.text = [NSString stringWithFormat:@"提现金额:¥%.1f",jien/100.0];
        NSTimeInterval tm = [dic[@"applytime"] floatValue];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tm];
        NSString *dateStr = [AppManager stringFromDate:date format:@"yyyy-MM-dd"];
        
        cell.shijian.text = [NSString stringWithFormat:@"%@",dateStr];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainTableView.width, 45)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 1;
    view.layer.masksToBounds = YES;
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 7.5, 80, 30)];
    lable.textColor = [UIColor darkGrayColor];
//    lable.textAlignment = NSTextAlignmentCenter;
    if (section==0) {
        lable.text = @"邀请记录";
    }else{
        lable.text = @"提现记录";
    }
    lable.font = [UIFont systemFontOfSize:15];
    [view addSubview:lable];
    return view;
}
@end
