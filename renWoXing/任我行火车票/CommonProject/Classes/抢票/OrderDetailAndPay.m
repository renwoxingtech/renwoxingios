//
//  OrderDetailAndPay.m
//  CommonProject
//
//  Created by mac on 2017/2/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderDetailAndPay.h"
#import "PayView.h"
#import "CBAlertView.h"
#import "NSString+Hash.h"
#import "payRequsestHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "PaySuccessVc.h"
#import "BHUD.h"
#import "GaiQianVC.h"
#import "HZBAlertView.h"

#import "WXInsuranceController.h"
#import "HomeViewController.h"
#import "WodeViewController.h"
#import "NormalOrderVc.h"

#define WaitTick @"等待出票"
#define ZhanTick @"占座中"
/*
 
 //线上订票status		订单状态，0:占座失败 1：已下单,占座中；2：已占座，等待付费；3：付款取消/超时付款，订单关闭。5：已付款，等待出票；6：退款/退票中；7：退款成功；8：出票请求已发送，等待出票；9：出票成功


 //线上抢票
 //订单状态订单状态，0：订单关闭 1：已下单,待付款；4，占座失败/取消占座，等待关闭 5：已付款，等待占座出票；6：退款中；7：退款成功；8：占座出票请求已发送，等待出票；9：出票成功；10；出票成功，返还余款0033;11:退票中;12:退票失败



 // 线下订票
 //订单状态 订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取 6已出票 7.已发送


 // 线下抢票
 //订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取 6已出票 7.已发送


 */

@interface OrderDetailAndPay ()
{
    NSMutableArray *passengersData;
    PayView *payView ;
    OrderData *res;
    
    
    BOOL is12306Dp;
    BOOL is12306Qp;
    BOOL isRxOnlineDp;
    BOOL isrxDp;
    BOOL isrxQp;
    __block NSInteger timeout;
    NSArray *baoxianInfo;
    BOOL isZx;
    BOOL hasExec;
    BOOL hasAdd123;
    NSTimer *timer;
    UIButton *bgButon;
    NSInteger orderStatus;
    NSString *chufaStr;
    NSString *daodaStr;
    NSString *chufaStrCode;
    NSString *daodaStrCode;
    UIAlertController *_payAlert;
    NSInteger currentDayFlag; //1 发车前  2发车当天  3 发车后
    BOOL isDeng;
     BOOL isZhan;
    UIView *detailV;
    NSString *_biaoXianString;
    NSIndexPath * _indexPath_insurance;
    CGFloat _totalP;
}
@property (weak, nonatomic) IBOutlet UILabel *chuFaTime;
@property (weak, nonatomic) IBOutlet UILabel *daoDaTime;
@property (weak, nonatomic) IBOutlet UILabel *PersonMessage;
@property (strong, nonatomic) IBOutlet UIView *viewBaoXian;
@property(nonatomic,weak)UIButton * baoXian_Button;
@end

@implementation PersonOrderDetailCell

@end

@implementation OrderDetailAndPay

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone:timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (NSString *)time:(NSString *)time{
    NSString *chufaRiQi = [time substringWithRange:NSMakeRange(0, 10)];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * destDate = [dateFormatter dateFromString:chufaRiQi];
    NSString * weekString = [self weekdayStringFromDate:destDate];
    NSLog(@"时间: %@",weekString);
    
    NSString *chufaDetailedtime1 = [res.start_time substringWithRange:NSMakeRange(5, 1)];
    NSString *chufaDetailedtime2 = [res.start_time substringWithRange:NSMakeRange(6, 1)];
    NSString *chufaDetailedtime3 = [res.start_time substringWithRange:NSMakeRange(8, 1)];
    NSString *chufaDetailedtime4 = [res.start_time substringWithRange:NSMakeRange(9, 1)];
    NSString * chufaDetailedtime = nil;
    if ([chufaDetailedtime1 isEqualToString:@"0"] || [chufaDetailedtime3 isEqualToString:@"0"] ) {
        if ([chufaDetailedtime1 isEqualToString:@"0"] && ![chufaDetailedtime3 isEqualToString:@"0"] ) {
            chufaDetailedtime = [NSString stringWithFormat:@"%@月%@%@日 %@",chufaDetailedtime2,chufaDetailedtime3,chufaDetailedtime4,weekString];
        }
        else if (![chufaDetailedtime1 isEqualToString:@"0"] && [chufaDetailedtime3 isEqualToString:@"0"]){
            chufaDetailedtime = [NSString stringWithFormat:@"%@%@月%@日 %@",chufaDetailedtime1,chufaDetailedtime2,chufaDetailedtime4,weekString];
        }
        else{
            chufaDetailedtime = [NSString stringWithFormat:@"%@月%@日 %@",chufaDetailedtime2,chufaDetailedtime4,weekString];
        }
    }
    else{
        chufaDetailedtime = [NSString stringWithFormat:@"%@%@月%@%@日 %@",chufaDetailedtime1,chufaDetailedtime2,chufaDetailedtime3,chufaDetailedtime4,weekString];
    }
    return chufaDetailedtime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    _biaoXianString = @"¥30";
    self.bottomView.hidden = YES;
    self.topBgView.frame = CGRectMake(0, 0, SWIDTH, 104);
    self.topBgView.backgroundColor = BlueColor;
    NSLog(@"%@",self.preObjvalue);
    currentDayFlag = 0;
    self.chuFaTime.hidden = YES;
    self.daoDaTime.hidden = YES;
    self.bgScrollView.scrollEnabled = YES;
    [self.baoxianSwitch addTarget:self action:@selector(changeBX:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayResult:) name:@"AliPayResultNotify" object:nil];
    
    baoxianInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoxianInfo"];
    [self getBaoxian];
    res = self.orderData;
    self.mainTableView.bounces = YES;
    self.mainTableView.mj_header = nil;
    self.baoxianview.hidden = YES;

    if ([self.url containsString:@"grabRowOnline"]) {
        is12306Qp = YES;

    }else  if ([self.url containsString:@"buyRowOnline"]) {
        is12306Dp = YES;
    }else  if ([self.url containsString:@"grabRowOffline"]) {
        isrxQp = YES;//人工抢票
    }else  if ([self.url containsString:@"buyRowOffline"]) {
        isrxDp = YES;
    }
    bgButon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    bgButon.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    bgButon.alpha = 0.0;
    bgButon.hidden = YES;
    [bgButon addTarget:self action:@selector(hidView) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgButon];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidView) name:@"hiddenVew" object:nil];
}

- (void)hidView{
    [BHUD dismissHud];
    [UIView animateWithDuration:0.2 animations:^{
        bgButon.alpha = 0.0;
    } completion:^(BOOL finished) {
        [bgButon removeFromSuperview];
    }];
}

#pragma mark - 12306抢票详情视图
-(void)init12306Qpdetail{
    detailV = [[NSBundle mainBundle] loadNibNamed:@"Qp123DetailView" owner:nil options:nil].firstObject;
    detailV.frame = CGRectMake(10, 0, SWIDTH-20, 261);
    [self.view addSubview:detailV];
    OrderData *data = res;
    NSString *qpxx = @"";
    for (NSDictionary *dic in data.passengers) {
        qpxx = [qpxx stringByAppendingString:dic[@"passengersename"]];
        qpxx = [qpxx stringByAppendingString:@","];
    }
    if (qpxx.length>0) {
        qpxx = [qpxx substringToIndex:qpxx.length-1];
    }
    
    NSInteger status = [res.status integerValue];
    NSString *qpresultStr = @"";
    if (status == 1) {
         [self CreatrightItem];
    }
    
    if (is12306Qp) {
        switch (status) {
            case 0:
            {
                if(res.msg && res.msg.length>0){
                    qpresultStr = res.msg;
                }else
                    qpresultStr = @" 订单关闭";
            }
                break;
            case 1:
                qpresultStr = @" 已下单,待付款";
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                qpresultStr = @" 占座失败/取消占座，等待关闭";
                break;
            case 5:
                qpresultStr = @" 已付款，等待占座出票";
               
                break;
            case 6:
                qpresultStr = @" 退票中";
                break;
            case 7:
                qpresultStr = @" 退款成功";
                break;
            case 8:
                qpresultStr = @" 等待出票";
                if (is12306Qp) {
                    [self CreatrightTuiPiaoItem];
                }
                break;
            case 9:
                qpresultStr = @" 出票成功";
                break;
            case 10:
                qpresultStr = @" 出票成功，返还余款";
                break;
                
            default:
                break;
        }
    }
    else{
        // 线下订票   status                订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态
        switch (status) {
            case 0:
            {
                if(res.msg  && res.msg.length>0){
                    qpresultStr = res.msg;
                }else
                    qpresultStr = @" 无票";
            }
                break;
                
            case 1:
                qpresultStr = @" 已下单,等待付款";
                break;
            case 2:
                qpresultStr = @" 订单已取消";
                break;
            case 3:
//                if (isrxDp) {
                    //                    status                订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态
//                    qpresultStr = @"已付款，等待出票";
//                }else
                    qpresultStr = @" 已经付款等待抢票";
                //人工抢票取消订单
                if (isrxQp) {
                    [self CreatrightTuiPiaoItem];
                }
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
    }
    [self setTiplableText:qpresultStr];
    
    //时间分割
    
    NSMutableString * start_time = [NSMutableString string];
      NSArray * allTime = [NSArray array];
    if (is12306Qp) {
         allTime = [data.start_date componentsSeparatedByString:@","];
        for (int i =0; i< allTime.count - 1; i++) {
            NSString * time = allTime[i];
            NSMutableString * str = [NSMutableString stringWithFormat:@"%@",time];
            [str insertString:@"-" atIndex:4];
            [str insertString:@"-" atIndex:7];
            
            if (i == allTime.count - 2) {
            }
            else{
                [str insertString:@"," atIndex:10];
            }
            
            [start_time appendString:str];
        }
    }
    else{
        start_time = [data.train_date mutableCopy];
    }
    
    
    
  //车次分割
  
    if (is12306Qp) {
        [self getCheCi:data.train_codes withData:data withstartTime:start_time withString:qpxx withsult:qpresultStr];
    }
    else{
        NSArray * zwcodearr = data.zwcodearr;
        NSMutableArray * zwnameMutableS = [NSMutableArray array];
        for (NSDictionary * dict in zwcodearr) {
            NSString * zwname = dict[@"zwname"];
            [zwnameMutableS addObject:zwname];
        }
        NSString * zwname = [zwnameMutableS.copy componentsJoinedByString:@","];
        data.seat_type = zwname;
        data.start_date = data.train_date;
        data.train_codes = data.checi;
        [self getCheCi:data.checi withData:data withstartTime:start_time withString:qpxx withsult:qpresultStr];
    }

}

- (void)getCheCi:(NSString *)type withData:(OrderData *)data withstartTime:(NSMutableString *)start_time withString:(NSString *)qpxx withsult:(NSString *)qpresultStr{
    NSMutableString *train_codes = [NSMutableString stringWithFormat:@"%@",type];
    type = [type substringToIndex:[type length] -1];
    NSArray *titles = @[data.from_station_name?data.from_station_name:@"",data.to_station_name?data.to_station_name:@"",data.start_date?start_time:@"",data.train_codes?train_codes:@"",data.seat_type?data.seat_type:@"",qpxx,qpresultStr];
    for (int i=0; i<titles.count; i++) {
        UILabel *lable = [detailV viewWithTag:i+1];
        lable.text = titles[i];
        if (i==titles.count-1) {
            lable.layer.cornerRadius = 4;
            lable.layer.masksToBounds = YES;
            if ([lable.text isEqualToString:@" 已下单,待付款"] || [lable.text isEqualToString:@" 退票中"]) {
                lable.textColor = OrangeColor;
            }
            else if ([lable.text isEqualToString:@" 占座失败/取消占座，等待关闭"] || [lable.text isEqualToString:@" 退款成功"] || [lable.text isEqualToString:@" 订单关闭"]){
                lable.textColor = qiColor;
            }
            else{
                lable.textColor = BlueColor;
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AliPayResultNotify" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.mainTableView.frame = CGRectMake(0, _PersonMessage.bottom + 2, SWIDTH, SHEIGHT - _PersonMessage.bottom - 47 - 64);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
    [BHUD dismissHud];

    timeout = 0;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)getBaoxian{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/Insurance/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        baoxianInfo = obj[@"data"];
        if (baoxianInfo) {
            [[NSUserDefaults standardUserDefaults] setObject:baoxianInfo forKey:@"baoxianInfo"];            
        }
        [self calShowPrice];
        
    } andError:nil];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateStatus{
    [self loadNetData];
}

#pragma mark 视图加载
-(void)initTopView{
    NSInteger status = [res.status integerValue];
    if (status==1 || status==2 ) {
        self.tiplable.text = @"下单成功";
    }
//   12306抢票 status	 订单状态，0：订单关闭 1：已下单,待付款；4，占座失败/取消占座，等待关闭 5：已付款，等待占座出票；6：退票中；7：退款成功；8：占座出票请求已发送，等待出票；9：出票成功；10；出票成功，返还余款

    NSInteger stat = [res.status integerValue];
#pragma mark - 12306抢票
    if (is12306Qp) {
        if (stat == 6 || stat == 7 || stat == 9 || stat == 10)
        {
            
        }else
        {
            [self.view removeAllSubviews];
            [self init12306Qpdetail];
            NSString *dateStr = res.start_date;
            BOOL isShowPay = NO;
            NSString *currentStr = [AppManager getCurrentTimeStrWithformat:@"yyyyMMdd"];
            NSArray *datesArr = [dateStr componentsSeparatedByString:@","];
            for (NSString *str in datesArr) {
                
                NSMutableString * timeString = [NSMutableString stringWithFormat:@"%@",str];
                [timeString insertString:@"-" atIndex:4];
                [timeString insertString:@"-" atIndex:7];
                NSString *tempStr = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
                if ([tempStr integerValue] >= [currentStr integerValue]) {
                    isShowPay = YES;
                    break;
                }
            }
            if (stat ==1&&isShowPay) { //1：已下单,待付款；
                [self initPayView];

            }
            return;
        }
    }

    #pragma mark - 12306订票
    if (status==2 && is12306Dp) { //线上订票
        [self CreatrightItem];
        [self initPayView];
        self.baoxianview.hidden = NO;
        self.baoxianlable.text = @"铁路意外险";
        self.baoxianlable.userInteractionEnabled = YES;
        self.baoxianlable.contentMode = UIViewContentModeTopLeft;
        UIButton * baoXian_Button = [[UIButton alloc]initWithFrame:CGRectMake(90, self.baoxianlable.top, self.baoxianlable.width - 100 , self.baoxianlable.height)];
        self.baoXian_Button = baoXian_Button;
        baoXian_Button.backgroundColor = [UIColor whiteColor];
        [baoXian_Button setTitle:@"¥30.0/份" forState:UIControlStateNormal];
        baoXian_Button.titleLabel.font = [UIFont mysystemFontOfSize:15];
        [baoXian_Button setTitleColor:zhangColor forState:UIControlStateNormal];
        baoXian_Button.contentMode = UIViewContentModeTopLeft;
        [baoXian_Button addTarget:self action:@selector(getbiaoXian:) forControlEvents:UIControlEventTouchUpInside];
        self.baoXian_Button.userInteractionEnabled = YES;
        [self.baoxianlable addSubview:self.baoXian_Button];
        
        self.mainTableView.tableFooterView = self.baoxianview;
        CGFloat hh = passengersData.count*100+72;
         self.mainTableView.contentSize = CGSizeMake(SWIDTH,hh);
    }else {
        CGFloat hh = passengersData.count*100;
       self.mainTableView.contentSize = CGSizeMake(SWIDTH,hh);
    }
    
    if (is12306Dp) {
//        status		订单状态，0:占座失败 1：已下单,占座中；2：已占座，等待付费；3：付款取消/超时付款，订单关闭。5：已付款，等待出票；6：退款/退票中；7：退款成功；8：出票请求已发送，等待出票；9：出票成功
        NSString *statusText = @"";
        switch (status) {
            case 0:
            {
                if(res.msg  && res.msg.length>0){
                    statusText = res.msg;
                }else
                    statusText = @"占座失败";
            }
                break;
            case 1:
                statusText = @"已下单,占座中";
                break;
            case 2:
                statusText = @"已占座，等待付费";
                [self CreatrightItem];
                break;
            case 3:
                statusText = @"付款取消/超时付款,订单关闭";
                break;
            case 4:
                break;
            case 5:
                statusText = @"已付款，等待出票";
                break;
            case 6:
                statusText = @"退票中";
                break;
            case 7:
                statusText = @"退款成功";
                break;
            case 8:
                statusText = @"等待出票";
                break;
            case 9:
                statusText = @"出票成功";
                break;
            case 10:
                statusText = @"退票中";
                break;
            case 11:
                statusText = @"退票失败";
                break;

            default:
                 statusText = @"状态未知";
                break;
        }
        if (status==2) {
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval order_time = [res.seattime integerValue];
            if (now-order_time<20*60) {
                
                [self startDaojishi:20*60-(now-order_time)];
    
            }
        }
        [self setTiplableText:statusText];
    }else if (is12306Qp){
//        status														订单状态，0：订单关闭 1：已下单,待付款；4，占座失败/取消占座，等待关闭 5：已付款，等待占座出票；6：退款/退票中；7：退款成功；8：占座出票请求已发送，等待出票；9：出票成功；10；出票成功，返还余款

        NSString *qpresultStr = @"";
        
        switch (status) {
            case 0:
            {
                if(res.msg  && res.msg.length>0){
                    qpresultStr = res.msg;
                }else
                    qpresultStr = @" 订单关闭";
            }
                break;
            case 1:
                qpresultStr = @" 已下单,待付款";
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                qpresultStr = @" 占座失败/取消占座，等待关闭";
                break;
            case 5:
                qpresultStr = @" 已付款，等待占座出票";
                break;
            case 6:
                qpresultStr = @" 退票中";
                break;
            case 7:
                qpresultStr = @" 退款成功";
                break;
            case 8:
                qpresultStr = @" 等待出票";
                break;
            case 9:
                qpresultStr = @" 出票成功";
                break;
            case 10:
                qpresultStr = @" 出票成功，返还余款";
                break;
    
            default:
                break;
        }
        if (status==1) {
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval order_time = [res.order_time integerValue];
            if (now-order_time<20*60) {
                
                [self startDaojishi:20*60-(now-order_time)];
        
            }
        }
         [self setTiplableText:qpresultStr];
    }
    else if (isrxQp){
        // 线下订票   status                订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态
        NSString *qpresultStr = @"";
        if (stat == 6 || stat == 7) {
            switch (stat) {
                case 6:
                qpresultStr = @" 已出票";
                break;
                case 7:
                qpresultStr = @" 已发送";
                break;
                default:
                    break;
            }
    [self setTiplableText:qpresultStr];
        }else{
            [self.view removeAllSubviews];
            [self init12306Qpdetail];
            NSString *dateStr = res.train_date;
            BOOL isShowPay = NO;
            NSString *currentStr = [AppManager getCurrentTimeStrWithformat:@"yyyyMMdd"];
            NSArray *datesArr = [dateStr componentsSeparatedByString:@","];
            for (NSString *str in datesArr) {
              NSString * strDate = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
                if ([strDate integerValue] >= [currentStr integerValue]) {
                    isShowPay = YES;
                    break;
                }
            }
            if (stat ==1&&isShowPay) { //1：已下单,待付款；
                [self initPayView];
                
            }
            return;
        }
    }
    
    else if(isrxDp){
        NSString *qpresultStr = [NSString stringWithFormat:@""];
// 线下订票   status				订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态        
        switch (status) {
            case 0:
            {
                if(res.msg  && res.msg.length>0){
                    qpresultStr = res.msg;
                }else
                qpresultStr = @" 无票";
            }
                break;

            case 1:
                qpresultStr = @" 已下单,等待付款";
                [self CreatrightItem];
                break;
            case 2:
                qpresultStr = @" 订单已取消";
                break;
            case 3:
                if (isrxDp) {
//                    status				订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态
                    qpresultStr = @"已付款，等待出票";
                }else
                qpresultStr = @" 已经付款等待抢票";
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
        CGFloat bottH = 0;
        
        if (status==1) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 27)];
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = BlueColor;
            btn.titleLabel.font = Font(15);
            btn.layer.cornerRadius = 4;
            
            [btn setTitle:@"取消订单" forState:UIControlStateNormal];
            btn.tag = 10;
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = item;
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval order_time = [res.order_time integerValue];
            if (now-order_time<20*60) {
                [self startDaojishi:20*60-(now-order_time)];
            }
            bottH = 50;
            [self initPayView];
        }else{
             [self setTiplableText:qpresultStr];
        }
        
        //更新配送信息视图
        {
            self.shoujianren.text = res.take_uname;
            if (res.take_phone.length==1&&[res.take_phone isEqualToString:@"0"]) {
                _shoujihao.text = @"";
            }else{
                _shoujihao.text = res.take_phone;
            }
            if (!res.take_province) {
                self.peisongdizhi.text = [NSString stringWithFormat:@"%@",res.from_station_name];
                
            }else{
                NSString *dizhiStr = [NSString stringWithFormat:@"%@ %@ %@ %@",res.take_province,res.take_city,res.take_county,res.take_address];
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:dizhiStr];
                NSRange contentRange = {0,[content length]};
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                self.peisongdizhi.attributedText = content;
            }
            UIButton *btn = [[UIButton alloc]initWithFrame:self.peisongdizhi.frame];
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(seeMail:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:@"" forState:UIControlStateNormal];
            btn.tag = 10;
            [self.peisongdizhi.superview addSubview:btn];
            Customer *cus = res.passengers.firstObject;
            if ([cus isKindOfClass:[NSDictionary class]]) {
                cus = [Customer mj_objectWithKeyValues:cus];
            }
            CGFloat singleIns = [cus.insurance integerValue];//保险
            if (singleIns<50) {
                singleIns = singleIns*100;
            }
            self.tlyiwaixian.text = [NSString stringWithFormat:@"¥%.1f元/份",singleIns/100.0];
        }
        self.bottomView.hidden = NO;
        self.mainTableView.tableFooterView = self.bottomView;
        self.bottomView.userInteractionEnabled = YES;
        
        CGFloat hh = passengersData.count*100+self.bottomView.height;
         self.mainTableView.contentSize = CGSizeMake(SWIDTH, hh);
    }
    self.chufadi.text = res.from_station_name;
    self.mudidi.text = res.to_station_name;
    self.chufashijian.text = res.start_time;
    self.daodashijian.text = res.arrive_time;
    self.chufadi.text = res.from_station_name;
    self.mudidi.text = res.to_station_name;
    NSString *chufatime = [res.start_time substringWithRange:NSMakeRange(11, 5)];
    NSString *daodatime = [res.arrive_time substringWithRange:NSMakeRange(11, 5)];
    self.chufashijian.text = chufatime;
    self.daodashijian.text = daodatime;
    self.chuFaTime.text = [self time:res.start_time];
    self.daoDaTime.text = [self time:res.arrive_time];
    NSString *n  = [res.runtime stringByReplacingOccurrencesOfString:@":" withString:@"时"] ;
    self.lishi.text = [n stringByAppendingString:@"分"];
    self.checi.text = res.checi;
    
    NSDate *date1 = [AppManager dateFromString:res.start_time format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *wek = [self showWeekOrDate:date1];
    NSString *date1Str = [AppManager stringFromDate:date1 format:@"yyyy年MM月dd日 HH:mm"];
    NSString *fache =  [NSString stringWithFormat:@"%@ 开(%@)",date1Str,wek] ;
    self.facehtime.text = fache;
    
    if (isrxQp && ([res.status integerValue] == 6 ||[res.status integerValue] == 7))
    {
        self.checi.text = res.sure_checi;
        self.facehtime.text = [NSString stringWithFormat:@"%@开",res.sure_date];
        self.shengyuLab.hidden = YES;
    }
    else{
      self.shengyuLab.hidden = NO;
    }
    
    NSDate *date2 = [NSDate date];
    NSTimeInterval time=[date1 timeIntervalSinceDate:date2];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minite=(((int)time)%(3600*24)%3600)/60;
    
    NSString *dateContent = @"已发车";
    currentDayFlag = 1;
    if (days>0) {
        currentDayFlag = 3;
        dateContent = [[NSString alloc] initWithFormat:@"剩余 %i天%i小时%i分",days,hours,minite];
    }else if(hours>=0 && minite>=0){
        currentDayFlag = 2;
        dateContent = [[NSString alloc] initWithFormat:@"剩余 %i小时%i分",hours,minite];
    }
    self.shengyuLab.text = dateContent;
    self.shengyuLab.layer.cornerRadius = 4;
    self.shengyuLab.layer.masksToBounds = YES;
    [self.shengyuLab sizeToFit];
    self.shengyuLab.width+=10;
    self.shengyuLab.height+=8;
    
    [self.mainTableView reloadData];

}

-(void)seeMail:(UIButton *)btn{
    
    if (res.mailno.length<1) {
        [MBProgressHUD showHudWithString:@"暂无配送信息" model:MBProgressHUDModeCustomView];
        return;
    }
    NSString *orderNo = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?postid=%@",res.mailno];
    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"WebViewController"];
    vc.preObjvalue = orderNo;
    
    PUSH(vc);
    
}
-(void)startDaojishi:(NSInteger)time{
    timeout = time; //倒计时时间

    if (hasExec) {
        return;
    }
    hasExec = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _tiplable.text = @"未在规定时间内付款";
                payView.payBtn.enabled = NO;
            });
        }else{
            NSInteger seconds = timeout;
            NSInteger min = seconds/60;
            NSInteger sec = (seconds%60);
             payView.payBtn.enabled = YES;
            NSString *strTime = [NSString stringWithFormat:@"下单成功 请您在%ld分%ld秒内支付", (long)min,(long)sec];
            dispatch_async(dispatch_get_main_queue(), ^{
                _tiplable.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(NSString *)showWeekOrDate:(NSDate *)date{
    NSString *dateStr = [AppManager stringFromDate:date format:@"yyyy-MM-dd"];
    NSString *today = [AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSString *tomorrow = [AppManager stringFromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24] format:@"yyyy-MM-dd"];
    NSString *afterTom = [AppManager stringFromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*2] format:@"yyyy-MM-dd"];
    NSString *newStr = @"";
    
    if ([dateStr isEqualToString:today]) {
        newStr = @"今天";
    }else
        if ([dateStr isEqualToString:tomorrow]) {
            newStr = @"明天";
        }else
            if ([dateStr isEqualToString:afterTom]) {
                newStr = @"后天";
            }else
                newStr = [OrderDetailAndPay getWeekDayFordate:[date timeIntervalSince1970]];
    return newStr;
    
}

//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

#pragma mark 点击取消订单
-(void)cancelOrder:(UIButton *)btn{
   [self sureCancelOrder:nil];
}

#pragma mark 点击取消订单调用  没有付款
-(void)sureCancelOrder:(UIButton *)btn{
    
    NSDictionary *par = @{@"UToken":UToken,@"orderid":res.orderid};
    NSString *url = @"Action/grabOfflineCancel/";
    if ([self.url containsString:@"grabRowOnline"]) {
        is12306Qp = YES;
    }else  if ([self.url containsString:@"buyRowOnline"]) {
        is12306Dp = YES;
    }else  if ([self.url containsString:@"grabRowOffline"]) {
        isrxQp = YES;
    }else  if ([self.url containsString:@"buyRowOffline"]) {
        isrxDp = YES;
    } 
    if (isrxQp) {
        url = @"Action/grabOfflineCancel/";
    }else if (isrxDp) {
        url = @"Action/buyOfflineCancel/";
    }else if (is12306Qp) {
        url = @"Action/grabOnlineCancel/";
        if ([res.status integerValue]==1) {
            url= @"Action/grabOnlineClose/";
        }
    }else if (is12306Dp) {
        url = @"Action/buyOnlineCancel/";
    }
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退此订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:url showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            NSString * msg = obj[@"msg"];
            if ([obj[@"code"] integerValue] == 1) {
                 [MBProgressHUD showHudWithString:@"订单已取消" model:MBProgressHUDModeCustomView];
                timeout = 0;
                payView.hidden = YES;
                //            [self loadNetData];//我注销的
                if (self.touchEvent) {
                    self.touchEvent(@"");
                }
                [self.navigationController popViewControllerAnimated:YES];
               
            }
            else{
                [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
            }
            
        } andError:^(id error) {
            
        }];
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark 展示数据网络请求
-(void)loadNetData{
    
    if (!self.orderid) {
        [MBProgressHUD showHudWithString:@"订单号为空" model:MBProgressHUDModeCustomView];
        return;
    }
    if (!self.url) {
         [MBProgressHUD showHudWithString:@"url为空" model:MBProgressHUDModeCustomView];
        return;
    }
    NSDictionary *par = @{@"UToken":UToken,@"orderid":self.orderid};
    _orderid = self.orderid;
    [MBProgressHUD showHudWithString:@"加载中"];
    
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:self.url showLoading:NO showMsg:YES isFullUrk:NO andComplain:^(id obj)
    {
       
        NSInteger status = [[NSString stringWithFormat:@"%@",obj[@"data"][@"status"]] integerValue];
        if ([obj[@"code"] integerValue]==1 ) {
            if (status == 1 && is12306Dp) {
                
            }
            else{
                [MBProgressHUD hideHud];
            }
            NSArray *a = obj[@"data"][@"passengers"];
            res = [OrderData mj_objectWithKeyValues:obj[@"data"]];
            [AppManager formatJsonStr:[obj mj_JSONString]];
            
            passengersData = [Customer mj_objectArrayWithKeyValuesArray:a];
            
            [self initTopView];
           
            chufaStr = [NSString stringWithFormat:@"%@",obj[@"data"][@"from_station_name"]];
            daodaStr = [NSString stringWithFormat:@"%@",obj[@"data"][@"to_station_name"]];;
            chufaStrCode = [NSString stringWithFormat:@"%@",obj[@"data"][@"from_station_code"]];;
            daodaStrCode = [NSString stringWithFormat:@"%@",obj[@"data"][@"to_station_code"]];;

        }
        else{
           [MBProgressHUD hideHud];
        }
        [self.mainTableView reloadData];
        
    } andError:^(id error) {
        [MBProgressHUD hideHud];
        [MBProgressHUD showHudWithString:@"加载失败,请稍后重试!" model:MBProgressHUDModeCustomView];
    }];
}

//钱数都为分
-(void)showPrice:(CGFloat)buyedPrice insurance:(CGFloat)insurance count:(NSInteger)count{

    CGFloat singleIns = 0.0;
    singleIns = insurance;
    
    
    payView.baoxianPrice.text =  [NSString stringWithFormat:@"%.1f元/份x%ld",singleIns/100.0,(long)count];
    payView.chepiaoPrice.text = [NSString stringWithFormat:@"¥%.1fx%ld",buyedPrice,(long)count];
    CGFloat totalprice = singleIns/100.0 * count + buyedPrice * count;
    [payView.moneyBtn setTitle:[NSString stringWithFormat:@"实付款:%.1f",totalprice] forState:UIControlStateNormal];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonOrderDetailCell"];
    Customer *cus = passengersData[indexPath.row];
    cell.name.text = cus.passengersename;
    cell.numbern_id.text = cus.passportseno;
    cell.zhengjianleixing.text = cus.passporttypeseidname;
    cell.zauweixinxi.text = [NSString stringWithFormat:@"%@",cus.zwname];
    cell.yiwaixian.hidden = ![cus.insurance floatValue];
    cell.yiwaixian.text = @"铁路意外险已购买";

    cell.zhuangTaiBtn.backgroundColor = BlueColor;

    cell.jiage.hidden = YES;
    NSString *price = cus.max_price;
    if (!price) {
        price = cus.price;
    }
    if (price) {
        cell.jiage.hidden = NO;
        if (is12306Dp || is12306Qp) {
            cell.jiage.text  = [NSString stringWithFormat:@"¥%.1f",[price floatValue]];
        }else
            cell.jiage.text  = [NSString stringWithFormat:@"¥%.1f",[price floatValue]/100.0];
    }
    
    //12306抢票和12306订票的乘客状态
//    status		用户订票状态；0：占座失败 1：正常；2：退票中；3：退票失败；4退票成功，退款中；5退款完成
    if (is12306Dp || is12306Qp) {
        NSInteger status = [cus.status integerValue];
        [cell.zhuangTaiBtn setTitle:[self statusStrwithsts:status] forState:0];
        cell.zhuangTaiBtn.hidden = NO;

        if (status==1) {

             [cell.zhuangTaiBtn setTitle:self.tiplable.text forState:0];

            if (self.tiplable.text.length>6) {
                
                cell.zhuangTaiBtn.hidden = YES;
                if ([self.tiplable.text containsString:@"下单成功"]) {

                    [cell.zhuangTaiBtn setTitle:@"等待支付" forState:0];
                    cell.zhuangTaiBtn.hidden = NO;
                    
                }
            }else{
                cell.zhuangTaiBtn.hidden = NO;
                
            }
        }
    }else{
 [cell.zhuangTaiBtn setTitle:self.tiplable.text forState:0];

        if (self.tiplable.text.length>6) {
            cell.zhuangTaiBtn.hidden = YES;
            
        }else{
            cell.zhuangTaiBtn.hidden = NO;
            
        }
        if ([self.tiplable.text containsString:@"下单成功"]) {
 [cell.zhuangTaiBtn setTitle:@"等待支付" forState:0];
            cell.zhuangTaiBtn.hidden = NO;
        }
    }
    
    ///显示座位信息
    NSString *zw = @"";
    for (NSDictionary *dic in res.zwcodearr) {
        zw = [zw stringByAppendingString:dic[@"zwname"]];
        zw = [zw stringByAppendingString:@","];
    }
    if (zw.length>0) {
        zw = [zw substringToIndex:zw.length-1];
    }
    cell.zauweixinxi.text  = zw;
    if (is12306Dp) {
        cell.zauweixinxi.text = cus.zwname;
    }else if(is12306Qp){
        cell.zauweixinxi.text = res.seat_type;
        
    }else if(isrxDp){
        cell.zauweixinxi.text = cus.zwname;

    }
//    else if(isrxQp && cus.zwname.length<1){
//        NSString *zw = @"";
//        for (NSDictionary *dic in res.zwcodearr) {
//            zw = [zw stringByAppendingString:dic[@"zwname"]];
//            zw = [zw stringByAppendingString:@","];
//        }
//        if (zw.length>0) {
//            zw = [zw substringToIndex:zw.length-1];
//        }
//        cell.zauweixinxi.text  = zw;
//
//
//
//    }
    else if (isrxQp){
        if ([res.status integerValue] == 6 || [res.status integerValue] == 7) {
                        cell.zauweixinxi.text = cus.zwcode;
                    }
    }
    if ([self.tiplable.text containsString:@"下单成功"]) {
 [cell.zhuangTaiBtn setTitle:@"等待支付" forState:0];
        cell.zhuangTaiBtn.hidden = NO;
    }
    cell.zauweixinxi.text = [NSString stringWithFormat:@"%@ %@",cell.zauweixinxi.text,cus.cxin?cus.cxin:@""];


    cell.persontype.text = cus.piaotypename;
    cell.persontype.hidden = NO;
    cell.zhuangTaiBtn.layer.cornerRadius = 4;
    cell.zhuangTaiBtn.layer.masksToBounds = YES;
    cell.tuipiaobtn.layer.borderWidth = 1;
    cell.gaiqianBtn.layer.borderWidth = 1;
    ///退款按钮显示
//    12306订票 status		订单状态，0:占座失败 1：已下单,占座中；2：已占座，等待付费；3：付款取消/超时付款，订单关闭。5：已付款，等待出票；6：退款/退票中；7：退款成功；8：出票请求已发送，等待出票；9：出票成功
// 线下订票   status				订单状态  0:无票 1:已下单,等待付款 2.取消订单 3.已付款，等待出票 4.已退款； 5.已被提取/锁定状态 6.已出票/锁定状态 7.已发送/锁定状态

    if (is12306Dp) {
        if ([res.status integerValue]==5) {
            cell.tuipiaobtn.hidden = NO;
             cell.gaiqianBtn.hidden = NO;
        }else{
            cell.tuipiaobtn.hidden = YES;
            cell.gaiqianBtn.hidden = YES;
        }
        
    }
    cell.tuipiaobtn.hidden = YES;
    cell.gaiqianBtn.hidden = YES;
 
    if (isrxDp || isrxQp) {
        if ([res.status integerValue]==3) {
            cell.tuipiaobtn.hidden = NO;
            cell.gaiqianBtn.hidden = NO;
        }else{
            cell.tuipiaobtn.hidden = YES;
            cell.gaiqianBtn.hidden = YES;
        }
    }
    if (is12306Dp && [res.status integerValue] ==9 && [cus.status integerValue]==1) {
        cell.tuipiaobtn.hidden = NO;
        cell.gaiqianBtn.hidden = NO;
        
    }
    if (is12306Qp || is12306Dp) {
 [cell.zhuangTaiBtn setTitle: _tiplable.text forState:0];
    }
   
    if (is12306Qp && [res.status integerValue] == 10 &&  [cus.status integerValue]==1) {
        cell.tuipiaobtn.hidden = NO;
        cell.gaiqianBtn.hidden = NO;
    }
    cell.tuipiaobtn.layer.borderColor = cell.tuipiaobtn.titleLabel.textColor.CGColor;
     cell.gaiqianBtn.layer.borderColor = cell.gaiqianBtn.titleLabel.textColor.CGColor;

    [cell.tuipiaobtn addTarget:self action:@selector(tuipiaoAction:) forControlEvents:UIControlEventTouchUpInside];
   [ cell.zhuangTaiBtn addTarget:self action:@selector(tuipiaoAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.gaiqianBtn addTarget:self action:@selector(gaiqianAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cus.status integerValue]==1) {
        cell.zhuangTaiBtn.hidden = YES;
    }else{
        cell.zhuangTaiBtn.hidden = NO;
        NSDictionary *dic = @{@"0":@"占座失败",@"2":@"退票中",@"3":@"退票失败",@"4":@"退票成功，退款中",@"5":@"退款成功"};
        NSString *str = dic[cus.status];
        if (str.length>0) {
            [cell.zhuangTaiBtn setTitle: str forState:0];
            if ([str containsString:@"退款"]) {
                cell.tuipiaobtn.hidden = YES;
            }
        }else{
              cell.zhuangTaiBtn.hidden = YES;
        }
    }
    cell.gaiqianBtn.hidden = YES;
    if (is12306Qp) {
        if (([res.status integerValue]==9||[res.status integerValue]==10)&&[cus.status integerValue]==1) {
             cell.zhuangTaiBtn.hidden = NO;
             [cell.zhuangTaiBtn setTitle: @"购票成功" forState:0];
            
            if ([cus.ticket_change_status integerValue]==0) {
                cell.gaiqianBtn.hidden = NO;
                [cell.gaiqianBtn setTitle:@"改签" forState:0];
                
            }else if ([cus.ticket_change_status integerValue]==1){
                cell.gaiqianBtn.hidden = NO;
                cell.gaiqianBtn.size = CGSizeMake(100, 30);
                cell.gaiqianBtn.hidden = YES;
//                [cell.gaiqianBtn setTitle:@"取消改签" forState:0];
                
            }else if ([cus.ticket_change_status integerValue]==2){
                cell.gaiqianBtn.hidden = YES;
            }
            
        }
        if ([_tiplable.text isEqualToString:@"出票成功"]) {
            cell.tuipiaobtn.hidden = NO;
        }
    }
    if (is12306Dp) {
        if (([res.status integerValue]==9)&&[cus.status integerValue]==1) {
            cell.zhuangTaiBtn.hidden = NO;
            [cell.zhuangTaiBtn setTitle: @"购票成功" forState:0];
            
            if ([res.status integerValue]==9&&[cus.status integerValue]==1) {
                if ([cus.ticket_change_status integerValue]==0) {
                    cell.gaiqianBtn.hidden = NO;
                    [cell.gaiqianBtn setTitle:@"改签" forState:0];
                    
                }else if ([cus.ticket_change_status integerValue]==1){
                    cell.gaiqianBtn.hidden = NO;
                     cell.gaiqianBtn.size = CGSizeMake(100, 30);
                    cell.gaiqianBtn.hidden = YES;
//                    [cell.gaiqianBtn setTitle:@"取消改签" forState:0];
                    
                }else if ([cus.ticket_change_status integerValue]==2){
                    cell.gaiqianBtn.hidden = YES;
                                    [cell.zhuangTaiBtn setTitle: @"已改签" forState:0];
                }
            }
            
        }
    }

    if ([self.shengyuLab.text containsString:@"已发车"]) {
        cell.tuipiaobtn.hidden = YES;
    }

    if (currentDayFlag==1) {//已发车 且错过了今天
        cell.gaiqianBtn.hidden = YES;
    }
    
    if ([res.status integerValue] == 7) {
        cell.tuipiaobtn.hidden = YES;
        cell.gaiqianBtn.hidden = YES;
    }

    return cell;
}

#pragma mark 点击改签按钮
- (void)gaiqianAction:(UIButton *)btn{

    PersonOrderDetailCell *cell ;
    UIView *view = btn.superview;
    while (![view isKindOfClass:[PersonOrderDetailCell class]]) {
        view = view.superview;
    }
    cell = (PersonOrderDetailCell *)view;
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];

    Customer *data = passengersData[indexPath.row];
    NSLog(@"%@",data.person_id);

    if ([btn.currentTitle isEqualToString:@"改签"]) {
        
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要改签吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:actionCancel];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults]setObject:data.passengersid forKey:GaiQianKey];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",data.ticket_no] forKey:@"ordernumber"];;
            NSString *str = @"1"; //判断是否是改签
            if (is12306Qp) {
                str = @"2";
            }
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"qiangpiaoFlag"];;
            
            GaiQianVC *vc = (GaiQianVC *)[self getVCInBoard:@"Main" ID:@"GaiQianVC"];
            vc.chufaStr = chufaStr;
            vc.daodaStr = daodaStr;
            vc.orderID = _orderid;
            vc.chufaStrCode = chufaStrCode;
            vc.daodaStrCode = daodaStrCode;
            vc.orderURL = self.url;
            PUSH(vc);
        }];
        [alertVC addAction:actionOK];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark 付款后 取消订单
- (void)cancelBtn:(UIButton *)btn{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"订单已经提交,您确定要提交订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:alertCancle];
    UIAlertAction * alertOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * par = [NSDictionary dictionary];
        NSString * urlString = @"";
//        if (is12306Qp) {
//            urlString = @"Action/grabOnlineReturn";
//           par = @{@"UToken":UToken,@"orderid":self.orderid,@"ticket_no":data.ticket_no?data.ticket_no:@""};
//        }
//        else{
            urlString = @"Action/grabOfflineReturn/";
            par = @{@"UToken":UToken,@"orderid":self.orderid};
//        }
        
        
        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:urlString showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            NSString * msg = obj[@"msg"];
            if ([obj[@"code"] integerValue] == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
            }
        } andError:^(id error) {
            
        }];
    }];
    [alert addAction:alertOk];
    [self presentViewController:alert animated:YES completion:nil];
    
   
}


#pragma mark 点击退票按钮
-(void)tuipiaoAction:(UIButton *)btn{
   if (![btn.currentTitle isEqualToString:@"退票"]) {
            return;
        }
    __weak typeof(self) weakSelf = self;;
    NSString *m1 = @"确定要退票吗？";
    if (isrxDp || isrxQp) {
        m1 = @"同一订单的所有车票都将退票，确定要退票吗？";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:m1 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PersonOrderDetailCell *cell ;
        UIView *view = btn.superview;
        while (![view isKindOfClass:[PersonOrderDetailCell class]]) {
            view = view.superview;
        }
        cell = (PersonOrderDetailCell *)view;
        
        NSIndexPath *indexPath = [weakSelf.mainTableView indexPathForCell:cell];
        
        Customer *data = passengersData[indexPath.row];
        
        NSDictionary *par = @{@"UToken":UToken,@"orderid":self.orderid,@"ticket_no":data.ticket_no?data.ticket_no:@""};
        //线下
        if ([weakSelf.tuipiaoUrl isEqualToString:@"grabOfflineReturn/"]) {
            par =  @{@"UToken":UToken,@"orderid":self.orderid};
        }
        
        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:weakSelf.tuipiaoUrl showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
            NSString * msg = obj[@"msg"];
            if ([obj[@"code"] integerValue] == 1) {
//                [weakSelf loadNetData];//我注销的
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
            }
        } andError:^(id error) {
            
        }];   

    }];
   
  
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:act3];
    
     [alert addAction:act1];
    [self presentViewController:alert animated:YES completion:nil];

}
-(NSString *)statusStrwithsts:(NSInteger)stcode{
    NSString *buttonTitle = @"";
    //    status		用户订票状态；0：占座失败 1：正常；2：退票中；3：退票失败；4退票成功，退款中；5退款完成

    switch (stcode) {
        case 0:
            buttonTitle = @"占座失败";
            break;
        case 1:
            break;
        case 2:{
            buttonTitle = @"退票中";
            break;
        }
        case 3:{
            buttonTitle = @"退票失败";
            break;
        }
        case 4:{
            buttonTitle = @"退票成功";
            break;
        }
        case 5:{
            buttonTitle = @"退款成功";
            break;
        }
        default:
            break;
    }
    
    return buttonTitle;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return passengersData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 120;
    
}

-(void)initPayView{
    if (is12306Qp) {
        NSInteger status = [res.status integerValue];
//        status		订单状态，0：订单关闭 1：已下单,待付款；4，占座失败/取消占座，等待关闭 5：已付款，等待占座出票；6：退款/退票中；7：退款成功；8：占座出票请求已发送，等待出票；9：出票成功；10；出票成功，返还余款
        if (status!=1) {
            return;
        }
    }
    if (!payView) {
        
        payView = [[PayView alloc]initWithFrame:CGRectMake(0, SHEIGHT - 45 - 64, SWIDTH, 45)];
        payView.clipsToBounds = YES;
        [payView.moneyBtn addTarget:self action:@selector(changeHeight) forControlEvents:UIControlEventTouchUpInside];
        [payView.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:payView];
    }
    
    [self calShowPrice];
    NSLog(@"");
}

-(void)changeHeight{
    [UIView animateWithDuration:0.5 animations:^{
        
        if (payView.height==45) {
             payView.jianTou_ImageView.image = [UIImage imageNamed:@"dakai"];
            if (is12306Dp ) {
                payView.height = 127;
                
            }
            else if (is12306Qp){
                payView.height = 167;
            }
            else
                payView.height = 245;
            payView.top = SHEIGHT - payView.height - 64;
        }else{
            payView.height = 45;
            payView.jianTou_ImageView.image = [UIImage imageNamed:@"xiala_icon"];
            payView.top = SHEIGHT - payView.height - 64;
            
        }
    }];
}

-(void)calShowPrice{
    if (is12306Dp || is12306Qp) {
        [self show12306Price];
        return;
    }
    Customer *cus = res.passengers.firstObject;
    if ([cus isKindOfClass:[NSDictionary class]]) {
        cus = [Customer mj_objectWithKeyValues:cus];
    }
    CGFloat buyedPrice = [cus.max_price floatValue];//单张最高票价
    CGFloat purch_fee = [cus.purch_fee floatValue];//手续费
    CGFloat singleIns = [cus.insurance integerValue];//保险
    CGFloat express_fee = [res.express_fee floatValue];//配送费
    
    NSInteger count = res.passengers.count;
    if (count==0) {
        count = 1;
    }
    if (singleIns<50) {
        singleIns = singleIns*100;
    }
    payView.chepiaoPrice.text = [NSString stringWithFormat:@"¥%.1f元x%ld",buyedPrice/100.0,(long)count];
    payView.baoxianPrice.text = [NSString stringWithFormat:@"¥%.1f元x%ld",singleIns/100.0,(long)count];
    payView.vipLable.text = [NSString stringWithFormat:@"¥%.1d元x%ld",[cus.q_fee intValue]/100,(long)count];
    payView.peisongfei.text = [NSString stringWithFormat:@"¥%.1f元",express_fee/100.0];
    payView.shouxufei.text = [NSString stringWithFormat:@"¥%.1f元x%ld",purch_fee/100.0,(long)count];
    
    CGFloat totalprice = singleIns*count+buyedPrice*count+purch_fee*count + express_fee + [cus.q_fee intValue] * count;
    if (is12306Dp) {
        totalprice = singleIns*count+buyedPrice*count;
        
    }
    [payView.moneyBtn setTitle:[NSString stringWithFormat:@"实付款:¥%.1f元",totalprice/100.0] forState:UIControlStateNormal];
    
}

-(void)show12306Price{
    
    Customer *cus = res.passengers.firstObject;
    if ([cus isKindOfClass:[NSDictionary class]]) {
        cus = [Customer mj_objectWithKeyValues:cus];
    }
    CGFloat buyedPrice = [cus.price floatValue];//单张最高票价
    CGFloat singleIns = [cus.insurance integerValue];//保险
    
    if (is12306Qp) {
        buyedPrice = [res.max_price floatValue];
        
    }
    
    NSInteger instype = 1;
    if (is12306Qp) {
        instype  = 2;
    }

    NSInteger count = res.passengers.count;
    if (count==0) {
        count = 1;
    }
    
        buyedPrice = buyedPrice/100.0;
    if (is12306Dp) {
        buyedPrice = buyedPrice*100;
    }
    
    CGFloat totalP = 0.0;
    for (NSDictionary *dict in res.passengers) {
        totalP += [dict[@"price"] floatValue];
    }
    if (totalP<=0) {
        totalP = buyedPrice*count;
    }
    payView.chepiaoPrice.text = [NSString stringWithFormat:@"共¥%.1f元",totalP];
    payView.baoxianPrice.text = [NSString stringWithFormat:@"¥%.1f元x%ld",singleIns / 100,(long)count];
    payView.vipLable.text = [NSString stringWithFormat:@"¥%.1f元x%ld",[cus.q_fee floatValue] / 100,(long)count];
    CGFloat  totalprice = singleIns / 100 * count + buyedPrice * count + [cus.q_fee floatValue] / 100 * count ;
    if (is12306Dp) {
        NSCharacterSet * nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        _biaoXianString = [_biaoXianString stringByTrimmingCharactersInSet:nonDigits];
        payView.baoxianPrice.text = [NSString stringWithFormat:@"¥%@元x%ld",_biaoXianString,(long)count];
        totalprice = totalP + [_biaoXianString floatValue] *count;
        _totalP = totalP;

    }
    
    [payView.moneyBtn setTitle:[NSString stringWithFormat:@"实付款:¥%.1f元",totalprice] forState:UIControlStateNormal];
 
}

#pragma mark 点击支付按钮
-(void)payAction:(NSDictionary *)info{
    NSArray *arr = @[@"微信",@"支付宝"];
    NSArray *ims = @[@"weixin",@"zhifu"];
    __weak typeof(self) weakSelf = self;
    CBAlertView *view = [[CBAlertView alloc]initWithTitle:@"请选择支付方式" actionsTitles:arr imgnames:ims showCancel:YES showSure:YES event:^(id value) {
        NSLog(@"%@",value);
        if ([value integerValue]==0) {
            /*
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未安装微信" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                [alert show];
                return ;
            }
             
            
            if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi])
            {
                [LoadingView showAMessage:@"请安装最新版微信客户端"];
                return;
            }
             */
            [weakSelf getPrepayID:1];
        }else{
            [weakSelf getPrepayID:2];
            
        }
        
    }];
    
    
}
-(void)getPrepayID:(NSInteger)index{
    //    实参字段名			参考值				说明
    //    UToken				*******				登录获取到的utoken
    //    orderid									订单id
    //    insurance								最贵票面保险
    //    all_insurance							保险总额
    //    apitype									1为线上订票，2为线上抢票，3为线下订票，4，线下抢票
    //    paytype									1为微信支付，2为支付宝支付
    NSInteger apitype = 1;
    if (is12306Dp) {
        apitype=1;
    }else if(is12306Qp){
        apitype=2;        
    }else if (isrxDp) {
        apitype=3;
    }else if(isrxQp){
        apitype=4;        
    }
    Customer *cus = res.passengers.firstObject;
    if ([cus isKindOfClass:[NSDictionary class]]) {
        cus = [Customer mj_objectWithKeyValues:cus];
    }
    if (is12306Dp) {
        Customer *cus = res.passengers.firstObject;
        if ([cus isKindOfClass:[NSDictionary class]]) {
            cus = [Customer mj_objectWithKeyValues:cus];
        }
    }
    
    CGFloat singleIns = 0;
    CGFloat all_insurance = 0;
    NSDictionary *par = [NSDictionary dictionary];
    if (is12306Dp || isrxDp ) {
        singleIns = [_biaoXianString floatValue];
        CGFloat moneryBiaoXian =[_biaoXianString integerValue] * (res.passengers.count);
        all_insurance = [[NSString stringWithFormat:@"%f",moneryBiaoXian] floatValue];
       par = @{@"UToken":UToken,@"orderid":self.orderid,@"insurance":@(singleIns * 100),@"all_insurance":@(all_insurance * 100),@"apitype":@(apitype),@"paytype":@(index)};
    }
    else{
        singleIns = [cus.insurance floatValue];
        CGFloat moneryBiaoXian =[cus.insurance integerValue] * (res.passengers.count);
        all_insurance = [[NSString stringWithFormat:@"%f",moneryBiaoXian] floatValue];
        par = @{@"UToken":UToken,@"orderid":self.orderid,@"insurance":@(singleIns),@"all_insurance":@(all_insurance),@"apitype":@(apitype),@"paytype":@(index),@"q_fee":@([cus.q_fee intValue])};
    }
    
    NSLog(@"支付参数:%@",par);
    
    __weak typeof(self) weakSelf = self;
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:@"Action/orderPay/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
        NSLog(@"%@",[obj mj_JSONString]);
        
        if ([obj[@"code"] integerValue]==1) {
            NSString *prepayid = obj[@"data"][@"prepay_id"];
            if (prepayid.length>0||prepayid!=nil) {

            }
            if (index==1) {
                [weakSelf wxPayWithInfo:prepayid];
            }else{
                [weakSelf AliPayWithInfo:prepayid];
                
            }
        }
        
    } andError:^(id error) {
        
    }];
    
    
}

#pragma mark - 微信支付
-(void)wxPayWithInfo:(NSString *)prePayid{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.wxpayDelegate = self;
    payRequsestHandler *req = [payRequsestHandler alloc] ;
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ( prePayid != nil) {
        //获取到prepayid后进行第二次签名
        NSString    *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str	= [time_stamp md5Hash];
        
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: APP_ID        forKey:@"appid"];
        [signParams setObject: nonce_str    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: MCH_ID        forKey:@"partnerid"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        [signParams setObject: prePayid     forKey:@"prepayid"];
        
        //生成签名
        NSString *sign  = [req createMd5Sign:signParams];
        
        //添加签名
        [signParams setObject: sign  forKey:@"sign"];
        
        dict = [NSMutableDictionary dictionaryWithDictionary:signParams];
    }
    if (dict) {
        
        //调起微信支付
        PayReq *req2             = [[PayReq alloc] init];
        req2.partnerId           = [dict objectForKey:@"partnerid"];
        req2.prepayId            = [dict objectForKey:@"prepayid"];
        req2.nonceStr            = [dict objectForKey:@"noncestr"];
        req2.timeStamp           = [dict[@"timestamp"] intValue];
        req2.package             = [dict objectForKey:@"package"];
        req2.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req2];
        //日志输出
        //NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
    
    
}
#pragma mark 微信回调
-(void)onResp:(BaseResp *)resp{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    //    NSString *strTitle = @"";
    NSDictionary *CodeDict = @{@"0":@"支付成功",@"-1":@"失败",@"-2":@"您点击了取消",@"-3":@"发送失败",@"-4":@"授权失败",@"-5":@"微信不支持"};
    
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
            {
                if (_isGaiqian) { //改签成功 页面不跳转
                    [self title:@"恭喜您，改签成功" okTitle:@"确定" cancelTitle:nil];
                }else{

                PaySuccessVc *vc = (PaySuccessVc *)[self getVCInBoard:@"Main" ID:@"PaySuccessVc"];
                vc.orderid = self.orderid;
                vc.isQp = isrxQp || is12306Qp;
                
                PUSH(vc);
                }
            }
                break;
                
            default:
                
                strMsg = [NSString stringWithFormat:@"支付结果：%@！",[CodeDict valueForKey:[NSString stringWithFormat:@"%d",resp.errCode]]];
                
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:actionOK];
                [self presentViewController:alertVC animated:YES completion:nil];

                break;
        }
    }
    
    NSLog(@"%@",resp.errStr );
    
}
#pragma mark - 支付宝支付
-(void)AliPayWithInfo:(NSString *)info{
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:info fromScheme:@"zrggrwxappzfb" callback:^(NSDictionary *resultDic) {
        [weakSelf handleAlipayResult:resultDic];
        
    }];
}
-(void)handleAlipayResult:(id)notif{
    
    NSDictionary *codeDic = @{@"9000":@"订单支付成功",
                              @"8000":@"正在处理中",
                              @"4000":@"订单支付失败",
                              @"6001":@"您取消了支付",
                              @"6002":@"网络连接出错"};
    
     NSString *status = @"";
    
    if ([notif isKindOfClass:[NSDictionary class]]) {
        NSDictionary *diccc = (NSDictionary *)notif;
        
        status = diccc[@"resultStatus"]; 
    }else{
        NSNotification *notif111 = (NSNotification *)notif;
        
        status = notif111.object[@"resultStatus"] ;
    }
    
    NSString *msg = codeDic[status];

    if ([status isEqualToString:@"9000"]) {
        if (_isGaiqian) {//改签成功 页面不跳转
            [self title:@"恭喜您，改签成功!" okTitle:@"确定" cancelTitle:nil];
            
        }else{
            PaySuccessVc *vc = (PaySuccessVc *)[self getVCInBoard:@"Main" ID:@"PaySuccessVc"];
            vc.orderid = self.orderid;
            vc.isQp = isrxQp || is12306Qp;

            PUSH(vc);
        }

        return;
    }
    if (msg) {
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:actionOK];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}
-(void)changeBX:(UISwitch *)sw{
    [self show12306Price ];
}

- (void)setTiplableText:(NSString *)text{
    self.tiplable.text = text;
    if ([self.tiplable.text containsString:@"取消"]) {
    }

    if ([text containsString:WaitTick]&&isDeng==NO) { //等待出票中
        isDeng=YES;
//          [MBProgressHUD showHudWithString:@"等待出票中"];
        bgButon.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            bgButon.alpha = 1.0;
        }];
        if (is12306Qp) {
            
        }
        else{
            timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];
        }
       
        [self loadNetData];
    }

    if ([text containsString:ZhanTick]&&isZhan==NO) {//占座中
        isZhan=YES;
//        [MBProgressHUD showHudWithString:@"加载中"];
        bgButon.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            bgButon.alpha = 1.0;
        }];
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];
//        [self loadNetData];
    }

    if (isDeng) {
        if (![text containsString:WaitTick]) {
            [timer invalidate];
            [self hidView];
        }
    }
    if (isZhan) {
        if (![text containsString:ZhanTick]) {
            [timer invalidate];
            [self hidView];
        }
    }
}

#pragma mark 提示界面
- (void)title:(NSString *)title okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle{
    UIAlertController * payView = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:nil];
    [payView addAction:okAction];
    [self presentViewController:payView animated:YES completion:nil];
}


#pragma mark 点击保险按钮
- (void)getbiaoXian:(UIButton *)button{
    WXInsuranceController * insuranceVC = [[WXInsuranceController alloc]init];
        insuranceVC.insurance_type = 1;

    [insuranceVC setInsurance_block:^(NSString *price, NSIndexPath *index_last) {
        if ([price isEqualToString:@""]) {
            [self.baoXian_Button setTitle:@"不购买保险" forState:UIControlStateNormal];
            _biaoXianString = @"¥0";
            
        }
        else{
            [self.baoXian_Button setTitle:[NSString stringWithFormat:@"%@.0/份",price] forState:UIControlStateNormal];
            _biaoXianString = price;
        }
        _indexPath_insurance = index_last;
        NSCharacterSet * nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        _biaoXianString = [_biaoXianString stringByTrimmingCharactersInSet:nonDigits];
        
        payView.baoxianPrice.text = [NSString stringWithFormat:@"¥%@元x%ld",_biaoXianString,res.passengers.count];
        [payView.moneyBtn setTitle:[NSString stringWithFormat:@"实付款:¥%.1f元",(_totalP + [_biaoXianString floatValue] * res.passengers.count)] forState:UIControlStateNormal];
        
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval order_time = [res.seattime integerValue];
        if (now-order_time<20*60) {
            hasExec = NO;
            [self startDaojishi:20*60-(now-order_time)];
            
        }
        
    }];
    insuranceVC.indexPath_new = _indexPath_insurance;
    [self.navigationController pushViewController:insuranceVC animated:YES];
}


#pragma mark 取消订单按钮
- (void)CreatrightItem{
    UIButton *deletebtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 27)];
    [deletebtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
              [deletebtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    deletebtn.backgroundColor = BlueColor;
    deletebtn.titleLabel.font = Font(15);
    deletebtn.layer.cornerRadius = 4;
    [deletebtn setTitle:@"取消订单" forState:UIControlStateNormal];
    deletebtn.tag = 10;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:deletebtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 付款后取消订单 (退票)
- (void)CreatrightTuiPiaoItem{
    UIButton *deletebtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 27)];
    [deletebtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if (is12306Qp) {
        [deletebtn addTarget:self action:@selector(sureCancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [deletebtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    deletebtn.backgroundColor = BlueColor;
    deletebtn.titleLabel.font = Font(15);
    deletebtn.layer.cornerRadius = 4;
    [deletebtn setTitle:@"取消订单" forState:UIControlStateNormal];
    deletebtn.tag = 10;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:deletebtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 返回按钮的事件
- (BOOL)navigationShouldPopOnBackButton{
    
    UINavigationController * navVC = self.navigationController;
    NSMutableArray * viewControllers = [[NSMutableArray alloc]init];
    NSLog(@"navVC======%@",[navVC viewControllers]);
    if ([navVC viewControllers].count > 6) {
        for (UIViewController * vcView in [navVC viewControllers]) {
            
            if ([vcView isKindOfClass:[HomeViewController class]]) {
                [viewControllers addObject:vcView];
                break;
            }
            if ([vcView isKindOfClass:[NormalOrderVc class]] ||[vcView isKindOfClass:[WodeViewController class]]) {
                [viewControllers addObject:vcView];
                break;
            }
//            if ([vcView isKindOfClass:[]]) {
//                []
//            }
           
        }
        [navVC setViewControllers:viewControllers animated:YES];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

@end
