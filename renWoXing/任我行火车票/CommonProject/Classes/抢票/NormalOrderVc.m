//  NormalOrderVc.m
//  CommonProject
//
//  Created by mac on 2017/2/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NormalOrderVc.h"
#import "OrderDetailAndPay.h"
#import "WXNavViewController.h"
#import "HomeViewController.h"

@interface NormalOrderVc ()<UITableViewDelegate>
{
    NSInteger cur_tag;
    NSInteger cur_index;
    UILabel *wzhLable;
    UIView * _line;
    BOOL _isSelected;
    
    
}

@end

@implementation OrderCell


@end
@implementation QPOrderCell



@end

@implementation NormalOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _isSelected = NO;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 15, 15)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"0";
    lable.backgroundColor = [UIColor redColor];
    lable.textColor  =[UIColor whiteColor ];
    lable.layer.cornerRadius = lable.width*0.5;
    lable.layer.masksToBounds = YES;
    lable.font = [UIFont systemFontOfSize:12];
    [self.wzfdd addSubview:lable];
    
    
    //订单下面的线
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SWIDTH / 2, 1)];
    [self.view addSubview:_line];
    _line.backgroundColor  = BlueColor;
    
    wzhLable = lable;
    wzhLable.left = self.wzfdd.width-5;

    if (self.isQpdd) {
        self.wzfdd.hidden = YES;
        
        self.title = @"抢票订单";
        self.taggbgView.hidden = YES;
        self.tipView.hidden = NO;
        self.tipView.top = 64+45;
        
        [self.renxingddbtn setTitle:@"12306抢票" forState:UIControlStateNormal];
        [self.ddbtn12306 setTitle:@"人工线下抢票" forState:UIControlStateNormal];
        [self.renxingddbtn setTitle:@"12306抢票" forState:UIControlStateHighlighted];
        [self.ddbtn12306 setTitle:@"人工线下抢票" forState:UIControlStateHighlighted];

        UIView * show_View = [[UIView alloc]initWithFrame:CGRectMake(0, self.topbgv.bottom + 5, SWIDTH, 40)];
        show_View.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:show_View];
        
        UIImageView * soundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 14,14, 11)];
        soundImageView.image = [UIImage imageNamed:@"tishi-laba"];
        [show_View addSubview:soundImageView];
        
        UILabel * show_Label = [[UILabel alloc]initWithFrame:CGRectMake(soundImageView.right + 10, 0, SWIDTH - 15 - (soundImageView.left + 10) , show_View.height)];
        show_Label.text = @"请凭购票时使用的有效身份证件及时取票乘车";
        show_Label.font = [UIFont mysystemFontOfSize:13];
        show_Label.textAlignment = NSTextAlignmentLeft;
        show_Label.textColor = BlueColor;
        [show_View addSubview:show_Label];
        
        NSMutableArray *dd12306 = [NSMutableArray array];
        NSMutableArray *ddrx = [NSMutableArray array];

        [self.mainDataSource addObject:dd12306];
        [self.mainDataSource addObject:ddrx];

    }else{
        self.tipView.hidden = YES;
        self.title = @"普通订单";
        for (int i=0; i<2; i++) {
            NSMutableArray *a = [NSMutableArray array];
            for (int j=0; j<3; j++) {
                NSMutableArray *b = [NSMutableArray array];
                [a addObject:b];
            }
            [self.mainDataSource addObject:a];
        }

    }
    
}
-(void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableView reloadData];
    [self.mainTableView.mj_header beginRefreshing];
    
}
#pragma mark - 获取数据
-(void)loadNetData{
    if (_isQpdd) {
        if (cur_tag==0) {
            
            [self getQiangPiaoOrderWithIndex:0];
        }else
        [self getQiangPiaoOrderWithIndex:1];

    }else{
        if (cur_tag==0) {
            
            [self getNormalOrderWithUrl:0];
        }else
        
        [self getNormalOrderWithUrl:1];
    }
}
-(void)getQiangPiaoOrderWithIndex:(NSInteger)index{
    NSString *urll = @"Action/grabListOnline/";
    if(index==1){
        urll= @"Action/grabListOffline/";
    }
    NSDictionary *par = @{@"UToken":UToken};
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:urll showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        NSLog(@"%@",obj);
        
        if ([obj[@"code"] integerValue] == 1) {
            
            NSMutableArray <OrderData *>*arr = [OrderData mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            NSMutableArray *all = self.mainDataSource[index];
            [all removeAllObjects];
            [all addObjectsFromArray:arr];
            
            [self.mainTableView reloadData];
            
            if (_isQpdd) {
                if (cur_tag<self.mainDataSource.count) {
                    NSArray *a  = self.mainDataSource[cur_tag];
                    wzhLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)a.count];
                }
            }else{
                if (cur_tag<self.mainDataSource.count) {
                    
                    NSArray *a  = self.mainDataSource[cur_tag];
                    NSArray *b  = a[2];
                    wzhLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)b.count];
                }
            }
        }
        
    } andError:^(id error) {
        
    }];   
}

#pragma mark 正常买票
-(void)getNormalOrderWithUrl:(NSInteger)index{
    NSString *urll = @"Action/buyListOffline/";
    if(index==1){
        urll= @"Action/buyListOnline/";
    }
    NSDictionary *par = @{@"UToken":UToken};
    [MBProgressHUD showHudWithString:@"加载中"];
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:urll showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        [MBProgressHUD hideHud];
        NSString * msg = obj[@"msg"];
        if ([obj[@"code"] integerValue] == 1) {
            NSMutableArray <OrderData *>*arr = [OrderData mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            NSMutableArray *all = self.mainDataSource[index][0];
            [all removeAllObjects];
            [all addObjectsFromArray:arr];
            
            NSMutableArray *yizhifu = self.mainDataSource[index][1];
            [yizhifu removeAllObjects];
            NSMutableArray *weizhifu = self.mainDataSource[index][2];
            [weizhifu removeAllObjects];

            NSMutableArray *sortyizhfu = [NSMutableArray array];
            NSMutableArray *sortweizhfu = [NSMutableArray array];
            
            [arr enumerateObjectsUsingBlock:^(OrderData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //                obj.status = [NSString stringWithFormat:@"%d",arc4random()%8+1];
                if (cur_tag==0) {
                    if ([obj.status integerValue]==3) {
                        [sortyizhfu addObject:obj];
                    } 
                    if ([obj.status integerValue]==1) {
                        [sortweizhfu addObject:obj];
                    }
                }else
                if (cur_tag==1) {
                    if ([obj.status integerValue]==5) {
                        [sortyizhfu addObject:obj];
                    } 
                    if ([obj.status integerValue]==2) {
                        [sortweizhfu addObject:obj];
                    }
                }
                
            }];
            [yizhifu removeAllObjects];
            [yizhifu addObjectsFromArray:sortyizhfu];
            [weizhifu removeAllObjects];
            [weizhifu addObjectsFromArray:sortweizhfu];
            [self.mainTableView reloadData];
            
            
            if (_isQpdd) {
                if (cur_tag<self.mainDataSource.count) {
                    NSArray *a  = self.mainDataSource[cur_tag];
                    wzhLable.hidden = a.count<1;

                    wzhLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)a.count];            
                }
            }else{
                if (cur_tag<self.mainDataSource.count) {
                    
                    NSArray *a  = self.mainDataSource[cur_tag];
                    NSArray *b  = a[2];
                    wzhLable.hidden = b.count<1;

                    wzhLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)b.count];            
                }
            }
        }
        else{
            [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
        }
        
    } andError:^(id error) {
        [MBProgressHUD hideHud];
        [MBProgressHUD showHudWithString:@"加载失败,请稍后重试!" model:MBProgressHUDModeCustomView];
    }];   
}

#pragma mark 点击 任我行账号订单/12306账号订单
- (IBAction)tagclick:(UIButton *)sender {
    
   
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tagbggo.centerX = sender.centerX;
        
    }];
    
    
    if ([sender isEqual:self.renxingddbtn]) {
        cur_tag = 0;
        _isSelected = YES;
    }else{
        cur_tag = 1;
        _isSelected = NO;
    }
    [self loadNetData];
    if(_isQpdd){
        
        if (cur_tag==0) {
            self.tiplable.text = @"请凭购票时使用的有效身份证件及时取票乘车";
        }else{
            self.tiplable.text = @"将为您配送火车票，请及时关注配送信息";
            
        }
    }
    if (_isQpdd) {
        if (cur_tag<self.mainDataSource.count) {
            NSArray *a  = self.mainDataSource[cur_tag];
            wzhLable.hidden = a.count<1;
            wzhLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)a.count];
        }
    }else{
        if (cur_tag<self.mainDataSource.count) {
            NSArray *a  = self.mainDataSource[cur_tag];
            NSArray *b  = a[2];
            wzhLable.hidden = b.count<1;

            wzhLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)b.count];
        }
        
    }
    
    if (_isSelected) {
        [self.renxingddbtn setTitleColor:BlueColor forState:UIControlStateNormal];
        [self.ddbtn12306 setTitleColor:biaoTiColor forState:UIControlStateNormal];
        _line.frame = CGRectMake(0, 44, SWIDTH / 2, 1);
        
    }
    else{
        [self.renxingddbtn setTitleColor:biaoTiColor forState:UIControlStateNormal];
        [self.ddbtn12306 setTitleColor:BlueColor forState:UIControlStateNormal];
        _line.frame = CGRectMake(SWIDTH / 2, 44, SWIDTH / 2, 1);
        
    }
    _isSelected = !_isSelected;
   
    [self.mainTableView reloadData];
}
- (IBAction)titlebtnclick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.titlebggo.centerX = sender.centerX;
        
    }];
    
    
    [self.qbdd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.yzfdd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.wzfdd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([sender isEqual:self.qbdd]) {
        cur_index = 0;
    }else if ([sender isEqual:self.yzfdd]) {
        cur_index = 1;
    }else if ([sender isEqual:self.wzfdd]) {
        cur_index = 2;
    }    
    [self.mainTableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isQpdd) {
        return 275;
    }
    return 140;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isQpdd) {
        if (cur_tag<self.mainDataSource.count) {
            
            NSArray *a  = self.mainDataSource[cur_tag];
            return a.count;
        }
        return 0;
    }
    if (cur_tag<self.mainDataSource.count) {
        
        NSArray *a  = self.mainDataSource[cur_tag];
        NSArray *b  = a[cur_index];
        return b.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //抢票订单相关
    if (self.isQpdd) {
        
        NSArray *a  = self.mainDataSource[cur_tag];
        
        OrderData *data = a[indexPath.row];
        
        QPOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qpordercell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.qpjieguo.layer.cornerRadius = 4;
        cell.qpjieguo.layer.masksToBounds = YES;
        cell.chakan.layer.borderWidth = 1;
        cell.chakan.layer.cornerRadius = 2;
        cell.chakan.layer.borderColor = cell.chakan.titleLabel.textColor.CGColor;
        cell.chakan.hidden = NO;
        
        cell.chufadi.text = data.from_station_name;
        cell.mudidi.text = data.to_station_name;
        //type == 0是线上, type ==1是线下
        if (data.type == 0) {
            if ([data.ordernumber isEqualToString:@"0"]) {
                cell.oriderid.text = @"";
            }
            else{
                cell.oriderid.text = [NSString stringWithFormat:@"取票号:%@",data.ordernumber];
            }
            
        }
        else{
            cell.oriderid.text = [NSString stringWithFormat:@"订单号:%@",data.orderid];
        }
        
        NSInteger statusDate = [data.status integerValue];
        if (cur_tag==0) {
            NSMutableString * start_date = [NSMutableString stringWithFormat:@"%@",data.start_date];
            [start_date deleteCharactersInRange:NSMakeRange(start_date.length - 1, 1)];
            NSArray * dataArray = [start_date componentsSeparatedByString:@","];
            NSMutableArray * startDataArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                NSString * startString = dataArray[i];
                NSMutableString * startMutableString = [NSMutableString stringWithFormat:@"%@", startString];
                [startMutableString insertString:@"-" atIndex:4];
                [startMutableString insertString:@"-" atIndex:7];
                [startDataArray addObject:startMutableString];
            }
            NSString * dataString = [startDataArray  componentsJoinedByString:@","];
//            if (statusDate == 6 || statusDate == 7) {
//                cell.chufariqi.text = data.sure_date;
//                cell.checi.text = data.sure_checi;
//
//            }
//            else{
                cell.chufariqi.text = dataString;
                cell.checi.text = data.train_codes;
              
//            }
            cell.zuoxi.text =data.seat_type;
           
        }else{
            cell.chufariqi.text = data.train_date;
            cell.checi.text = data.checi;
            if (statusDate == 6 || statusDate == 7) {
                cell.chufariqi.text = data.sure_date;
                cell.checi.text = data.sure_checi;
                
            }
            else{
                cell.chufariqi.text = data.train_date;
                cell.checi.text = data.checi;
                
            }
            NSString *zw = @"";
            for (NSDictionary *dic in data.zwcodearr) {
                zw = [zw stringByAppendingString:dic[@"zwname"]];
                zw = [zw stringByAppendingString:@","];

            }
            if (zw.length>0) {
                zw = [zw substringToIndex:zw.length-1];
            }
            cell.zuoxi.text =  zw;
        }
        NSString *qpxx = @"";
        for (NSDictionary *dic in data.passengers) {
            qpxx = [qpxx stringByAppendingString:dic[@"passengersename"]];
            qpxx = [qpxx stringByAppendingString:@","];
        }
        if (qpxx.length>0) {
            qpxx = [qpxx substringToIndex:qpxx.length-1];
        }
        cell.qpxinxi.text = qpxx;
        cell.chakan.userInteractionEnabled = NO;
        
#pragma mark - 人工抢票状态
//        status				订单状态 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态
        NSInteger status = [data.status integerValue];
        NSString *qpresultStr = [NSString stringWithFormat:@""];
        if (cur_tag==1) {
            
            switch (status) {
                case 0:
                    qpresultStr = @"占座失败";
                    break;
                case 1:
                    qpresultStr = @" 等待付款";
                    break;
                case 2:
                    qpresultStr = @" 订单已取消";
                    break;
                case 3:
                    qpresultStr = @" 已经付款抢票中";
                    break;
                case 4:
                    qpresultStr = @" 已退款";
                    break;
                case 5:
                    qpresultStr = @" 正在为您抢票......";
                    break;
                case 6:
                    qpresultStr = @" 已出票";
                    break;
                case 7:
                    qpresultStr = @" 已发送";
                    break;
                    
                default:
                    break;
            }
            cell.qpjieguo.text = qpresultStr;
            cell.qpjieguo.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];

        }
//        status		订单状态，0：订单关闭 1：已下单,待付款；4，占座失败/取消占座，等待关闭 5：已付款，等待占座出票；6：退款/退票中；7：退款成功；8：占座出票请求已发送，等待出票；9：出票成功；10；出票成功，返还余款
#pragma mark - 12306的抢票状态
        
        if (cur_tag==0) {
            switch (status) {
                    case 0:
                    qpresultStr = @" 订单关闭";
                    break;
                case 1:
                    qpresultStr = @" 已下单,待付款";
                    break;
                case 2:
//                    qpresultStr = @" 待付款";
                    break;
                case 3:
//                    qpresultStr = @" 已经付款等待抢票";
                    break;
                case 4:
                    qpresultStr = @" 占座失败/取消占座";
                    break;
                case 5:
                    qpresultStr = @" 已付款，等待占座出票";
                    break;
                case 6:
                    qpresultStr = @" 退款/退票中";
                    break;
                case 7:
                    qpresultStr = @" 退款成功";
                    break;
                case 8:
                    qpresultStr = @" 等待出票";
                    break;
                case 9:
                {
                    NSString *startTime = data.start_time;
                    
                    if (startTime.length>=16) {
                        startTime = [startTime substringFromIndex:5];
                        startTime = [startTime substringToIndex:5];
                        startTime = [startTime stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
                        startTime = [startTime stringByAppendingString:@"日 "];
                           
                        
                    }

                    qpresultStr = @" 出票成功";
                    Customer *pas = data.passengers.firstObject;
                    
                    
                    if ([pas isKindOfClass:[NSDictionary class]]) {
                        //我删除的
                        NSString *zwname = pas.zwname;
                        
                        qpresultStr = [NSString stringWithFormat:@" 购票成功,%@ (%@) %@ %ld张",data.checi,startTime,zwname,(unsigned long)data.passengers.count];
                    }else{
                        qpresultStr = [NSString stringWithFormat:@" 购票成功,%@ (%@)",data.checi,startTime];

                    }

                }
                    
                    break;
                case 10:
                    qpresultStr = @" 出票成功，返还余款";
                {
                    NSString *startTime = data.start_time;
                    
                    if (startTime.length>=16) {
                        startTime = [startTime substringFromIndex:5];
                        startTime = [startTime substringToIndex:5];
                        startTime = [startTime stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
                        startTime = [startTime stringByAppendingString:@"日 "];
                        
                    }
                    
                    qpresultStr = @" 出票成功";
                    Customer *pas = data.passengers.firstObject;
                    
                    
                    if ([pas isKindOfClass:[NSDictionary class]]) {
                        NSString *zwname = pas.zwname;
                        
                        qpresultStr = [NSString stringWithFormat:@" 购票成功,%@ (%@) %@ %ld张",data.checi,startTime,zwname,(unsigned long)data.passengers.count];
                    }else{
                        qpresultStr = [NSString stringWithFormat:@" 购票成功,%@ (%@)",data.checi,startTime];
                        
                    }

                    
                }
                    break;
     
                default:
                    break;
            }
            cell.qpjieguo.text = qpresultStr;
            if ([data.status integerValue]==9 || [data.status integerValue]==10) {
                cell.qpjieguo.backgroundColor = [UIColor colorWithRed:110/255.0 green:183/255.0 blue:105/255.0 alpha:1.0];
            }else{
                cell.qpjieguo.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
                
            }
            if ([qpresultStr isEqualToString:@"出票成功"]) {
                 cell.qpjieguo.backgroundColor = BlueColor;
            }
        }
        return cell;
        
    }else{
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordercell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        @try {
            NSArray *a  = self.mainDataSource[cur_tag];
            NSArray *b  = a[cur_index];
            OrderData *data = b[indexPath.row];
            //type == 0是线上, type ==1是线下
            if (data.type == 0) {
                if ([data.ordernumber isEqualToString:@"0"]) {
                   cell.dingdanID.text = @"";
                }
                else{
                     cell.dingdanID.text = [NSString stringWithFormat:@"取票号:%@",data.ordernumber];
                }
                
            }
            else{
                cell.dingdanID.text = [NSString stringWithFormat:@"订单号:%@",data.orderid];
            }
            cell.checi.text = data.checi;
            cell.quxiaobtn.hidden = YES;
            cell.zfbtn.hidden = YES;
            cell.quxiaobtn.layer.borderWidth = 1;
            cell.quxiaobtn.layer.borderColor  = qiColor.CGColor;
            cell.quxiaobtn.layer.cornerRadius = 5;
            cell.quxiaobtn.layer.masksToBounds = YES;

            cell.zfbtn.layer.cornerRadius = 5;
            cell.zfbtn.layer.masksToBounds = YES;
            
            NSString *startTime = data.start_time;
             cell.shijian.text = @"";
            if (startTime.length>=16) {
                startTime = [startTime substringFromIndex:5];
                startTime = [startTime substringToIndex:11];
                startTime = [startTime stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
                startTime = [startTime stringByReplacingOccurrencesOfString:@" " withString:@"日 "];
                startTime = [startTime stringByAppendingString:@"开"];
                cell.shijian.text = startTime;

            }
     
            
            
            cell.chufadi.text = data.from_station_name;
            cell.mididdi.text = data.to_station_name;
            
            NSDictionary *pass = (NSDictionary *)data.passengers[0];
            NSString *price = pass[@"price"];
            if (!price) {
                price = pass[@"max_price"];
            }
            CGFloat money = [price floatValue];
            if (cur_tag==0) {
                money = money/100.0;
            }
            cell.zuoxi.text = [NSString stringWithFormat:@"%@ %.1f元",pass[@"zwname"],money];
            
            NSString *chengke = @"";
            for (NSDictionary *pas in data.passengers) {
                chengke = [chengke stringByAppendingString:[NSString stringWithFormat:@"%@、",pas[@"passengersename"]]];
            }
            if (chengke.length>2) {
                chengke = [chengke substringToIndex:chengke.length-1];
                
            }
            chengke = [chengke stringByAppendingString:[NSString stringWithFormat:@"共%lu人",(unsigned long)data.passengers.count]];
            
            cell.chengke.text = chengke;
            cell.quxiaobtn.hidden = YES;
            cell.zfbtn.hidden = YES;
            cell.zhuangtaiBtn.hidden = NO;
            [cell.quxiaobtn addTarget:self action:@selector(cancleOrder:) forControlEvents:UIControlEventTouchUpInside];
            cell.zfbtn.userInteractionEnabled = NO;
            
            cell.zhuangtaiBtn.layer.cornerRadius = 4;
            cell.zhuangtaiBtn.layer.masksToBounds  = YES;
            


            UIColor *blueColor = BlueColor;
            cell.zhuangtaiBtn.backgroundColor = jieGuoColor;
//            status		订单状态，0:占座失败 1：已下单,占座中；2：已占座，等待付费；3：付款取消/超时付款，订单关闭。5：已付款，等待出票；6：退款/退票中；7：退款成功；8：出票请求已发送，等待出票；9：出票成功

#pragma mark - 12306普通订票
            if (cur_tag==1) {
                NSInteger statue = [data.status integerValue];
                NSString *buttonTitle = @"";
                switch (statue) {
                    case 0:
                        buttonTitle = @"占座失败";
                        break;
                    case 1:
                        buttonTitle = @"占座中";
                        break;
                    case 2:{
                        buttonTitle = @"等待支付";
                        cell.quxiaobtn.hidden = NO;
                        cell.zfbtn.hidden = NO;
                        cell.zhuangtaiBtn.hidden = YES;
                        
                        break;
                    }
                    case 3:{
                        buttonTitle = @"订单关闭";
                        break;
                    }
                    case 5:{
                        buttonTitle = @"已付款待出票";
                        cell.zhuangtaiBtn.backgroundColor = blueColor;          

                        break;
                    }
                    case 6:{
                        buttonTitle = @"退款/退票中";
                        break;
                    }
                    case 7:{
                        buttonTitle = @"退款成功";
                        break;
                    }
                    case 8:{
                        buttonTitle = @"等待出票";
//                        cell.zhuangtaiBtn.backgroundColor = blueColor;          

                        break;
                    }
                    case 9:{
                        if ([data.is_ticket_change isEqualToString:@"1"] && ![data.newtickets isEqualToString:@"<null>"]) {
                            buttonTitle = @"改签成功";
                        }
                        else{
                            buttonTitle = @"出票成功";
                        }
                        
//                        cell.zhuangtaiBtn.backgroundColor = blueColor;          

                        break;
                    }
                    case 10:{
                        buttonTitle = @"退票中";
//                        cell.zhuangtaiBtn.backgroundColor = blueColor;          
                        
                        break;
                    }
                    case 11:{
                        buttonTitle = @"退票失败";
//                        cell.zhuangtaiBtn.backgroundColor = blueColor;          
                        
                        break;
                    }
                    default:
                        buttonTitle = @"状态未知";
//                         cell.zhuangtaiBtn.backgroundColor = blueColor;
                        break;
                }
                
                [cell.zhuangtaiBtn setTitle:buttonTitle forState:UIControlStateNormal];
                if ([buttonTitle isEqualToString:@"出票成功"] || [buttonTitle isEqualToString:@"已付款待出票"] || [buttonTitle isEqualToString:@"等待出票"] || [buttonTitle isEqualToString:@"出票成功"] ||[buttonTitle isEqualToString:@"改签成功"]) {
                    cell.zhuangtaiBtn.backgroundColor = BlueColor;
                }
                else if ([buttonTitle isEqualToString:@"退款成功"])
                cell.zhuangtaiBtn.backgroundColor = OrangeColor;
                else{
                cell.zhuangtaiBtn.backgroundColor =  jieGuoColor;;
                }
            }
            
                       
            
#pragma mark - 人工定制购票
//            status				订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态
            NSInteger status = [data.status integerValue];
            NSString *qpresultStr = [NSString stringWithFormat:@""];
            
//            cell.zhuangtaiBtn.backgroundColor = [UIColor lightGrayColor];


            if (cur_tag==0) {
                switch (status) {
                    case 0:
                        qpresultStr = @"无票";
                        cell.zhuangtaiBtn.backgroundColor = jieGuoColor;

                        break;
                    case 1:
                        qpresultStr = @"等待支付";
                        cell.quxiaobtn.hidden = NO;
                        cell.zfbtn.hidden = NO;
                        cell.zhuangtaiBtn.hidden = YES;
                        
                        break;
                    case 2:
                        qpresultStr = @"订单已取消";
                        cell.zhuangtaiBtn.backgroundColor = jieGuoColor;
                        
                        break;
                    case 3:
                        qpresultStr = @"已付款待出票";
                        cell.zhuangtaiBtn.backgroundColor = blueColor;

                        break;
                    case 4:
                        qpresultStr = @"已退款";
                        break;
                    case 5:
                        qpresultStr = @"已被提取";
                        cell.zhuangtaiBtn.backgroundColor = blueColor;

                        break;
                    case 6:
                        qpresultStr = @"已出票";
                        cell.zhuangtaiBtn.backgroundColor = blueColor;

                        break;
                    case 7:
                        qpresultStr = @" 已发送";
                        break;
                        
                    default:
                        break;
                }
                [cell.zhuangtaiBtn setTitle:qpresultStr forState:UIControlStateNormal];
            }
            

            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        cell.zhuangtaiBtn.userInteractionEnabled = NO;
        
        return cell;
        
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    NSArray *a  = self.mainDataSource[cur_tag];
    NSArray *b  = a[cur_index];
    OrderData *data;
    if ([b isKindOfClass:[OrderData class]]) {
        data = (OrderData *)b;
    }else{
        data = b[indexPath.row];
    }
    
    
    
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSDictionary *par = @{@"UToken":UToken,@"orderid":data.orderid};
        
        NSString *url = @"Action/delGrabOffline/";
        if (_isQpdd) {
            url = cur_tag==0?@"Action/delGrabOnline/":@"Action/delGrabOffline/";
            if (cur_tag==0) {
                if ([data.status integerValue]==1) {
                    
                    url= @"Action/grabOnlineClose/";
                }
            }
            
        }else{
            url = cur_tag==0?@"Action/delBuyOffline/":@"Action/delBuyOnline/";
        }

        
        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:url showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            if ([obj[@"code"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.mainTableView.mj_header beginRefreshing];
                });
            }
            
        } andError:^(id error) {
            
        }];   
        
    }];
    return @[delete];
}

-(void)cancleOrder:(UIButton *)btn{
    //    
    OrderCell *cell ;
    UIView *view = btn.superview;
    while (![view isKindOfClass:[OrderCell class]]) {
        view = view.superview;
    }
    cell = (OrderCell *)view;
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    
    NSArray *a  = self.mainDataSource[cur_tag];
    NSArray *b  = a[cur_index];
    OrderData *data = b[indexPath.row];
    
    
    NSDictionary *par = @{@"UToken":UToken,@"orderid":data.orderid};
    NSString *url = @"Action/grabOfflineCancel/";
    if (_isQpdd) {
        url = cur_tag==0?@"Action/grabOnlineCancel/":@"Action/grabOfflineCancel/";
        if (cur_tag==0) {
            url= @"Action/grabOnlineClose/";
        }
        
    }else{
        url = cur_tag==0?@"Action/buyOfflineCancel/":@"Action/buyOnlineCancel/";
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:url showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mainTableView.mj_header beginRefreshing];
            });
        }
        
    } andError:^(id error) {
        
    }];   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderData *data;
    if (_isQpdd) {
        NSArray *a  = self.mainDataSource[cur_tag];
        
        data = a[indexPath.row];
    }else{
        NSArray *a  = self.mainDataSource[cur_tag];
        NSArray *b  = a[cur_index];
        data = b[indexPath.row];
        
    }
    OrderDetailAndPay *vc = (OrderDetailAndPay *)[self getVCInBoard:@"Main" ID:@"OrderDetailAndPay"];
    vc.orderData = data;
    vc.orderid = data.orderid;
    __weak typeof(self) weakSelf = self;

    vc.touchEvent = ^(NSString *ss){
        [weakSelf.mainTableView.mj_header beginRefreshing];
    };
    if (_isQpdd) {
        vc.url = cur_tag==0?@"Action/grabRowOnline/":@"Action/grabRowOffline/";
        vc.tuipiaoUrl = cur_tag==0?@"Action/grabOnlineReturn/":@"Action/grabOfflineReturn/";
        if (cur_tag==0) {
            QPOrderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           
            vc.orderCellView = cell;
            
            
        }
    }else{
        vc.url = cur_tag==0?@"Action/buyRowOffline/":@"Action/buyRowOnline/";
        vc.tuipiaoUrl = cur_tag==0?@"Action/buyOfflineReturn/":@"Action/buyOnlineReturn/";

    }
    vc.title = @"订单详情";
    PUSH(vc);
    
}


#pragma mark 返回
- (void)backrootAction{
    
    
   
}

#pragma mark 返回按钮的事件
- (BOOL)navigationShouldPopOnBackButton{
    
    UINavigationController * navVC = self.navigationController;
    NSMutableArray * viewControllers = [[NSMutableArray alloc]init];
    if ([navVC viewControllers].count > 3) {
        for (UIViewController * vcView in [navVC viewControllers]) {
            
            if ([vcView isKindOfClass:[HomeViewController class]]) {
                [viewControllers addObject:vcView];
                break;
            }
        }
        [navVC setViewControllers:viewControllers animated:YES];
        
    }
        [self.navigationController popViewControllerAnimated:YES];

    return NO;

}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
