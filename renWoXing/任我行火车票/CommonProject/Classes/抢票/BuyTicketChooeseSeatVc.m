//
//  BuyTicketChooeseSeatVc.m
//  CommonProject
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BuyTicketChooeseSeatVc.h"
#import "SKBView.h"
#import "CCPActionSheetView.h"
#import "ChoosePerson.h"
#import "LoginVc.h"
#import "SubmitOrderVc.h"
#import "OrderDetailAndPay.h"
#import "NSString+Hash.h"
#import "CocoaSecurity.h"
#import "NSString+Encryption.h"
#import "RSA.h"
#import "DZXZVc.h"
#import "QiangpiaoFSHomeVc.h"



@interface ShikebiaoData : NSObject


@end
@implementation ShikebiaoData



@end

@interface BuyTicketChooeseSeatVc ()
{
    CheCiRes *res;
    NSInteger zuoxiCount;
    NSMutableArray <NSString *>*zuoweiarr;
    NSInteger chedIndex;
    NSMutableArray *priceArr ;
    BOOL isadd;
    SKBView *skbv ;
    
}
@property (weak, nonatomic) IBOutlet UIView *buyChoseView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,weak)UIView * shadeView;
@end

@implementation BuyTicketChooeseSeatVc

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title =@"车次详情";
    UIButton * time_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [time_Btn setTitle:@"时刻表" forState:UIControlStateNormal];
    time_Btn.titleLabel.font = [UIFont mysystemFontOfSize:14];
    [time_Btn addTarget:self action:@selector(shikeb:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right_Item = [[UIBarButtonItem alloc]initWithCustomView:time_Btn];
    self.navigationItem.rightBarButtonItem = right_Item;
    
    res = self.preObjvalue;
    
    self.topView.frame = CGRectMake(0,0,SWIDTH, 84);
    self.chufadi.text = res.from_station_name;
    self.mudidi.text = res.to_station_name;
    self.chufashijian.text = res.start_time;
    self.daodashijian.text = res.arrive_time;
    
    
    self.chufadi.text = res.from_station_name;
    self.mudidi.text = res.to_station_name;
    
    self.lishi.text = [NSString stringWithFormat:@"%@分",[res.run_time stringByReplacingOccurrencesOfString:@":" withString:@"时"] ];
    
    self.chufashijian.text = res.start_time;
    self.daodashijian.text = res.arrive_time;
    self.checi.text = res.train_code;
    if ([res.start_station_name isEqualToString:res.from_station_name]) {
        if ([res.end_station_name isEqualToString:res.to_station_name]) {
            self.indicatorView.image = [UIImage imageNamed:@"qi-zhong"];
        }else{
            self.indicatorView.image = [UIImage imageNamed:@"qi-zhuan"];
            
        }
    }else{
        if ([res.end_station_name isEqualToString:res.to_station_name]) {
            self.indicatorView.image = [UIImage imageNamed:@"zhuan-zhong"];
        }else{
            self.indicatorView.image = [UIImage imageNamed:@"zhuan-zhuan"];
            
        }
    }
    
    [self loadNetData2];
    
    NSString *place = @"--";
    NSDictionary *dicc = [res mj_keyValues];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in dicc.allKeys) {
        if ([key containsString:@"_num"] && ![dicc[key] isEqualToString:place]) {
            [keys addObject:key];
        }
    }
    
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.frame = CGRectMake(0, self.topView.bottom, SWIDTH, SHEIGHT-self.topView.bottom);
    [self.view addSubview:self.bgScrollView];
    
    [self.view addSubview:self.buyChoseView];
    [self handleData];
    
    [self addBorder:self.goumai1];
    [self addBorder:self.goumai2];
    [self addBorder:self.goumai3];
    [self addBorder:self.goumai4];
    if (_isGaiqian) {
        self.title = @"改签车票确认";
    }

}
-(void)addBorder:(UIButton *)btn{
    btn.layer.borderColor = BlueColor.CGColor;
    btn.layer.borderWidth = 1;
}

#pragma mark 点击立即购买按钮
- (IBAction)buyAction:(UIButton *)sender {
    
    BOOL is12306Logined = [[NSUserDefaults standardUserDefaults] boolForKey:@"is12306login"];
    
    BOOL isLogined = [[NSUserDefaults standardUserDefaults] boolForKey:@"isrxlogin"];
    if (sender.tag==1) {
        if (!is12306Logined) {
            //去12306登陆；
            LoginVc *vcv = (LoginVc *)[self getVCInBoard:nil ID:@"LoginVc"];
            vcv.is12306 = YES;
            vcv.preObjvalue = @[res,@(sender.tag)];//tag :1   3   4
            vcv.title = @"登录";
            PUSH(vcv);
        }else{
            
            if (!self.preObjvalue) {
                [MBProgressHUD showHudWithString:@"请返回重新选择车次" model:MBProgressHUDModeCustomView];
                return;
            }
            SubmitOrderVc *vc = (SubmitOrderVc *)[self getVCInBoard:nil ID:@"SubmitOrderVc"];
            vc.preObjvalue = self.preObjvalue;
            vc.is12306dingpiao = YES;
            vc.type = 1;
            if (chedIndex<zuoweiarr.count) {
                vc.buyedZuowei = zuoweiarr[chedIndex];
                NSDictionary *dicc = [res mj_keyValues];
                vc.buyedPrice = dicc[priceArr[chedIndex]];
            }else{
                 [MBProgressHUD showHudWithString:@"出现错误，请返回列表刷新重试" model:MBProgressHUDModeCustomView];
                return;
            }
            vc.title = @"12306提交订单";
            PUSH(vc);
        }
    }else{
        if (!isLogined) {
            //去任行登陆；
            LoginVc *vcv = (LoginVc *)[self getVCInBoard:nil ID:@"LoginVc"];
            vcv.preObjvalue = @[res,@(sender.tag)];//tag :1   3   4
            vcv.title = @"登录";
            PUSH(vcv);
        }else{
            if (!self.preObjvalue) {
                 [MBProgressHUD showHudWithString:@"请返回重新选择车次" model:MBProgressHUDModeCustomView];
                return;
            }
            
            DZXZVc *vc = (DZXZVc *)[self getVCInBoard:nil ID:@"DZXZVc"];
            vc.preObjvalue = self.preObjvalue;
            vc.buyedZuowei = zuoweiarr[chedIndex];

            if (sender.tag == 3) {
                vc.from =6;
                
                SubmitOrderVc *vc = (SubmitOrderVc *)[self getVCInBoard:nil ID:@"SubmitOrderVc"];
                vc.type = 1;
                vc.title = @"选择座位";
                
                vc.issirendingzhi = YES;
         
                vc.preObjvalue = res;
                vc.isspsm = YES;
                vc.buyedZuowei = zuoweiarr[chedIndex];
                NSDictionary *dicc = [res mj_keyValues];            
                vc.buyedPrice = dicc[priceArr[chedIndex]];
                vc.buyedZuoweiCode = priceArr[chedIndex];
                
                PUSH(vc);

            }
            //任行快捷出票type == 0
            else if (sender.tag == 2){
                
                SubmitOrderVc *vc = (SubmitOrderVc *)[self getVCInBoard:nil ID:@"SubmitOrderVc"];
                vc.preObjvalue = self.preObjvalue;
                vc.type = 0;
                if (chedIndex<zuoweiarr.count) {
                    vc.buyedZuowei = zuoweiarr[chedIndex];
                    NSDictionary *dicc = [res mj_keyValues];
                    
                    vc.buyedPrice = dicc[priceArr[chedIndex]];
                    
                    
                }else{
                    [MBProgressHUD showHudWithString:@"出现错误，请返回列表刷新重试" model:MBProgressHUDModeCustomView];
                    return;
                }
                PUSH(vc);

            }
            else{
                
                vc.from = 7;
                vc.buyedZuowei = zuoweiarr[chedIndex];
                NSDictionary *dicc = [res mj_keyValues];            
                vc.buyedPrice = dicc[priceArr[chedIndex]];
                vc.buyedZuoweiCode = priceArr[chedIndex];
                PUSH(vc);
            }
        }

    }
}

-(void)handleData{
    NSString *place = @"--";
    NSDictionary *dicc = [res mj_keyValues];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in dicc.allKeys) {
        if ([key containsString:@"_num"] && ![dicc[key] isEqualToString:place]) {
            [keys addObject:key];
        }
    }
    
    zuoweiarr = [NSMutableArray array];
    NSMutableArray <NSString *>*keyarr = [NSMutableArray array];
    
    for (NSString *kkkk in keys) {
        //        NSString *numkey = [kkkk stringByReplacingOccurrencesOfString:@"num" withString:@"price"];
        NSArray *aa = [self nameWithCode:kkkk];
        NSInteger index = [aa.lastObject integerValue];
        
        NSString *info = [NSString stringWithFormat:@"%02ld%@",(long)index,aa[0]];
        NSString *tmpkey = [NSString stringWithFormat:@"%02ld%@",(long)index,kkkk];
        [keyarr addObject:tmpkey];
        
        [zuoweiarr addObject:info];
    }
    [zuoweiarr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        NSInteger a = [[s1 substringToIndex:2] integerValue];
        NSInteger b = [[s2 substringToIndex:2] integerValue];
        
        return a>b;
    }];
    [keyarr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        NSInteger a = [[s1 substringToIndex:2] integerValue];
        NSInteger b = [[s2 substringToIndex:2] integerValue];
        
        return a>b;
    }];
    for (int i=0; i<zuoweiarr.count; i++) {
        zuoweiarr[i] = [zuoweiarr[i] substringFromIndex:2];
    }
    for (int i=0; i<keyarr.count; i++) {
        keyarr[i] = [keyarr[i] substringFromIndex:2];
    }
    NSLog(@"");
    
    
    priceArr = [NSMutableArray array];
    for (int i=0; i<keyarr.count; i++) {
        [priceArr addObject:[keyarr[i] stringByReplacingOccurrencesOfString:@"_num" withString:@"_price"]];
        
    }
    NSDictionary *dic = [res mj_keyValues];
    NSInteger index = 100;
    zuoxiCount = zuoweiarr.count;
    
    //座位信息View创建
    for (int i=0; i<zuoweiarr.count; i++) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"bugTicket" owner:self options:nil].firstObject;
        UIView *v = [view viewWithTag:6];
        
        UILabel *l1 = [v viewWithTag:1];
        l1.text = zuoweiarr[i];
        UILabel *l2 = [v viewWithTag:2];
        NSString *str = [NSString stringWithFormat:@"%@",dic[priceArr[i]]];
        NSString *price = [NSString stringWithFormat:@"¥%@",str];;
        if([str floatValue]<=0){
            price = @"--";
        }
        l2.text = price;
        UILabel *l3 = [v viewWithTag:3];
        l3.numberOfLines = 0;
        NSString *lk = keyarr[i];
         NSString *vbb =  dic[lk];
        if (IsStrEmpty(res.yushouriqi)) {
            if ([vbb isEqualToString:@"0"]) {
                l3.text = @"无票";
            }
            else{
                l3.text = [NSString stringWithFormat:@"%@张",vbb];
            }
        }
        else{
            NSArray * dateArray = [res.yushouriqi componentsSeparatedByString:@"-"];
           NSString * timeString1 = [res.sale_date_time substringWithRange:NSMakeRange(0, 2)];
         NSString * timeString2 = [res.sale_date_time substringWithRange:NSMakeRange(2, 2)];
            l3.text = [NSString stringWithFormat:@"%@月%@日%@:%@开售",dateArray[1],dateArray[2],timeString1,timeString2];
            l3.font = [UIFont mysystemFontOfSize:12];

        }
        NSString *note = dicc[@"note"];
        
        if (note && note.length>0) {
            l3.text = [NSString stringWithFormat:@"%@",note];
            
        }
        
        view.frame = CGRectMake(0,(47+10)*i, SWIDTH, 57);
        UIButton *btn = [view viewWithTag:4];
        if ([vbb integerValue]<1 && IsStrEmpty(res.yushouriqi)) {
            [btn setTitle:@"抢票" forState:UIControlStateNormal];
            if (note && note.length>0) {
                [btn setTitle:@"预约抢票" forState:UIControlStateNormal];
            }
            btn.backgroundColor = [UIColor colorWithRed:252/255.0 green:110/255.0 blue:81/255.0 alpha:1];
        }
         if (!IsStrEmpty(res.yushouriqi)){
            [btn setTitle:@"预约抢票" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont mysystemFontOfSize:13];
             btn.backgroundColor = BlueColor;
        }
        if (_isGaiqian&&![btn.currentTitle isEqualToString:@"预约抢票"]) {
            [btn setTitle:@"改签" forState:UIControlStateNormal];
            btn.backgroundColor = BlueColor;
        }
        [btn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = index;
        btn.tag = index;
        
        index++;
        
        [self.bgScrollView addSubview:view];
    }
    
    
    CGFloat h = zuoweiarr.count*57+90+100;
    if (h<self.bgScrollView.height) {
        h = self.bgScrollView.height+1;
    }
    self.bgScrollView.contentSize = CGSizeMake(SWIDTH, h);
    [self.bgScrollView addSubview: self.buyChoseView];
    self.buyChoseView.hidden = YES;
}

#pragma mark 点击抢票或者改签按钮/购买按钮
-(void)buyBtnClicked:(UIButton *)btn{
        chedIndex = btn.tag-100;
        
        if ([btn.currentTitle isEqualToString:@"抢票"]) {
            
            QiangpiaoFSHomeVc *base = (QiangpiaoFSHomeVc *)[self getVCInBoard:nil ID:@"QiangpiaoFSHomeVc"];
            base.preObjvalue = self.preObjvalue;
            
            base.buyedZuowei = zuoweiarr[chedIndex];
            NSDictionary *dicc = [res mj_keyValues];
            base.buyedPrice = dicc[priceArr[chedIndex]];
            base.buyedZuoweiCode = priceArr[chedIndex];
            PUSH(base);
            return;
        }
    
    if ([btn.currentTitle containsString:@"预约抢票"])
    {
        //遮罩
        UIView * shadeView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.shadeView = shadeView;
        shadeView.backgroundColor = [UIColor colorWithRed:0/255.0 green:9/255.0 blue:31/255.0 alpha:0.5];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:shadeView];
        
        UIView * styleVie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH - 60, 161)];
        styleVie.backgroundColor = [UIColor whiteColor];
        styleVie.center = shadeView.center;
        styleVie.layer.cornerRadius = 8;
        styleVie.layer.masksToBounds = YES;
        [shadeView addSubview:styleVie];
        
        //添加手势
        UITapGestureRecognizer * tapShade = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShade)];
        tapShade.numberOfTapsRequired = 1;//tap次数
        tapShade.numberOfTouchesRequired = 1;//手指数
        [shadeView addGestureRecognizer:tapShade];
        
        //线下抢票
        UIImageView * offLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 27.5, 25, 28)];
        offLineImageView.image = [UIImage imageNamed:@"rengong_icon"];
        [styleVie addSubview:offLineImageView];
        UIButton * offLineBtn = [[UIButton alloc]initWithFrame:CGRectMake(offLineImageView.right + 20, 0, styleVie.width - offLineImageView.right - 20 - 23, 80)];
        [offLineBtn setTitle:@"人工线下抢票" forState:UIControlStateNormal];
        [offLineBtn setTitleColor:zhangColor forState:UIControlStateNormal];
        offLineBtn.titleLabel.font = [UIFont mysystemFontOfSize:18];
        offLineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [offLineBtn addTarget:self action:@selector(clickOffLine:) forControlEvents:UIControlEventTouchUpInside];
        [styleVie addSubview:offLineBtn];
        
        //箭头
        UIImageView * arrowOffImageView = [[UIImageView alloc]initWithFrame:CGRectMake(styleVie.width - 15 - 8, 0, 8, 15)];
        arrowOffImageView.centerY = offLineBtn.centerY;
        arrowOffImageView.image = [UIImage imageNamed:@"more_icon"];
        [styleVie addSubview:arrowOffImageView];
        
        //分割线
        UIView * lineVie = [[UIView alloc]initWithFrame:CGRectMake(0, offLineBtn.bottom, styleVie.width, 1)];
        lineVie.backgroundColor = E5Color;
        [styleVie addSubview:lineVie];
        
        //线上抢票
        UIImageView * onlineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, lineVie.bottom + 27.5, 25, 28)];
        onlineImageView.image = [UIImage imageNamed:@"12306_icon1"];
        [styleVie addSubview:onlineImageView];
        UIButton * onlineBtn = [[UIButton alloc]initWithFrame:CGRectMake(onlineImageView.right + 20, lineVie.bottom, styleVie.width - offLineImageView.right - 20 - 23, 80)];
        [onlineBtn setTitle:@"12306抢票" forState:UIControlStateNormal];
        [onlineBtn setTitleColor:zhangColor forState:UIControlStateNormal];
        onlineBtn.titleLabel.font = [UIFont mysystemFontOfSize:18];
        onlineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [onlineBtn addTarget:self action:@selector(clickOnLine:) forControlEvents:UIControlEventTouchUpInside];
        [styleVie addSubview:onlineBtn];
        
        ///箭头
        UIImageView * arrowOnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(styleVie.width - 15 - 8, 0, 8, 15)];
        arrowOnImageView.centerY = onlineBtn.centerY;
        arrowOnImageView.image = [UIImage imageNamed:@"more_icon"];
        [styleVie addSubview:arrowOnImageView];
        
//        DZXZVc *vc = (DZXZVc *)[self getVCInBoard:nil ID:@"DZXZVc"];
//        vc.preObjvalue = self.preObjvalue;
//        vc.buyedZuowei = zuoweiarr[chedIndex];
//        vc.from = 4;
//        PUSH(vc);
    }
        if ([btn.currentTitle containsString:@"改签"]) {
            
            UILabel *ll = [btn.superview viewWithTag:3];
            
            NSString * price = nil;
            if ([ll.text isEqualToString:@"0"]) {
                price = @"无票";
            }
            else{
                price = [ll.text stringByReplacingOccurrencesOfString:@"张" withString:@""];
            }
            if ([price integerValue]==0) {
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"暂无车票" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * actionOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:actionOk];
                [self presentViewController:alertVC animated:YES completion:nil];
                return;
            }
            UIView *vvv = btn.superview;
            UILabel *l1 = [vvv viewWithTag:1];
            
            CheCiRes *checi = res;
            
            if (!checi) {
                return;
            }
            NSMutableDictionary *par = [NSMutableDictionary dictionary];
            par[@"UToken"] = UToken;
            par[@"change_checi"] = checi.train_code;
            par[@"from_station_code"] = checi.from_station_code;
            par[@"from_station_name"] = checi.from_station_name;
            par[@"to_station_code"] = checi.to_station_code;
            par[@"to_station_name"] = checi.to_station_name;
            
            par[@"orderid"] = self.orderID;
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"ordernumber"];
            if (str.length==0) {
                str = @"";
            }
            par[@"ordernumber"] = str ;
            NSString *zwcode = [self zuoweiCodeWithName:l1.text];
            par[@"change_zwcode"]=zwcode;
            
            NSMutableString *ss = [NSMutableString stringWithString:res.train_start_date];
            [ss insertString:@"-" atIndex:4];
            [ss insertString:@"-" atIndex:7];
            
            par[@"change_datetime"] = [NSString stringWithFormat:@"%@ %@:00",ss,checi.start_time];
            NSString *LoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
            NSString *LoginUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
            
            
            par[@"LoginUserName"] = LoginUserName;
            par[@"LoginUserPassword"] = LoginUserPassword;
            par[@"runtime"] = checi.run_time;
            par[@"arrive_time"] = [NSString stringWithFormat:@"%@ %@:00" ,ss,checi.arrive_time];
            
            NSString *flage = [[NSUserDefaults standardUserDefaults]objectForKey:@"qiangpiaoFlag"];;
            NSString *gaiqianStr = @"Action/ticket_chagne/";
            NSString * url = @"Action/buyRowOnline/";
            NSString *  tuipiaoUrl = @"Action/buyOnlineReturn/";
            if ([flage integerValue]==2) {
                gaiqianStr = @"Action/changeGrabTicketOnline/";
                url = @"Action/grabRowOnline/";
                tuipiaoUrl = @"Action/grabOnlineReturn/";
            }
            [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:gaiqianStr showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
                NSLog(@"改签成功 %@",obj);
                if ([obj[@"code"] integerValue] == 1) {
                    NSString *orderid = obj[@"data"][@"orderid"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        OrderDetailAndPay *vc = (OrderDetailAndPay *)[self getVCInBoard:nil ID:@"OrderDetailAndPay"];
                        vc.orderid = orderid;
                        vc.url = url;
                        vc.tuipiaoUrl = tuipiaoUrl;
                        PUSH(vc);
                    });
                }
            } andError:^(id error) {
                
            }];
            return;
        }
        UIView *currentView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            for (int i=0; i<zuoxiCount; i++) {
                UIView *vvv = [self.bgScrollView viewWithTag:100+i];
                UIButton *btn342 = [vvv viewWithTag:4];
                if (vvv.tag>btn.superview.tag&&!self.buyChoseView.hidden) {
                    vvv.frame = CGRectMake(0,(47+10)*i+self.buyChoseView.height, SWIDTH, 57);
                }else{
                    vvv.frame = CGRectMake(0,(47+10)*i, SWIDTH, 57);
                }
                
                if ([currentView isEqual:vvv]) {
                    if ([btn.currentTitle isEqualToString:@"抢票"]) {
                        
                    }else
                        if ([btn.currentTitle isEqualToString:@"购买"]||[btn.currentTitle isEqualToString:@"改签"]) {
                            //                        [btn setTitle:@"收起" forState:UIControlStateNormal];
                            self.buyChoseView.hidden = NO;
                            self.buyChoseView.top = btn.superview.bottom;
                            self.buyChoseView.alpha = 1.0;
                        }else{
                            //                        [btn setTitle:@"购买" forState:UIControlStateNormal];
                            self.buyChoseView.hidden = YES;
                            self.buyChoseView.alpha = 0.0;
                            
                        }
                }else if ([btn342.currentTitle isEqualToString:@"抢票"]) {
                    
                }else{
                    //                [btn342 setTitle:@"购买" forState:UIControlStateNormal];
                }
            }
        }];
   
}
-(NSArray *)nameWithCode:(NSString *)code{
    NSString *name = @"";
    NSInteger index = 0;
    
    
    if ([code containsString:@"swz"]) {
        name = @"商务座";
        index = 1;
    }else if ([code containsString:@"tdz"]) {
        name = @"特等座";
        index = 2;
    }else if ([code containsString:@"ydz"]) {
        name = @"一等座";
        index = 3;
    }else if ([code containsString:@"edz"]) {
        name = @"二等座";
        index = 4;
    }else if ([code containsString:@"gjrw"]) {
        name = @"高级软卧";
        index = 5;
    }else if ([code containsString:@"rw_"]) {
        name = @"软卧";
        index = 6;
    }else if ([code containsString:@"rz"]) {
        name = @"软座";
        index = 7;
    }else if ([code containsString:@"yw_"]) {
        name = @"硬卧";
        index = 8;
    }else if ([code containsString:@"yz"]) {
        name = @"硬座";
        index = 9;
    }else if ([code containsString:@"wz"]) {
        name = @"无座";
        index = 10;
    }else if ([code containsString:@"qtxb"]) {
        name = @"其它席别";
        index = 11;
    }
    return @[name,@(index)];
}

#pragma mark 点击线下抢票
- (void)clickOffLine:(UIButton *)sender{
    self.shadeView.hidden = YES;
    DZXZVc *vc = (DZXZVc *)[self getVCInBoard:nil ID:@"DZXZVc"];
    vc.from = 5;
    vc.buyedZuowei = zuoweiarr[chedIndex];
    vc.preObjvalue = self.preObjvalue;
    NSDictionary *dicc = [res mj_keyValues];
    vc.buyedPrice = dicc[priceArr[chedIndex]];
    vc.buyedZuoweiCode = priceArr[chedIndex];
    vc.title = @"添加人工抢票任务";
    PUSH(vc);
}

#pragma mark 点击线上抢票
- (void)clickOnLine:(UIButton *)sender{
    self.shadeView.hidden = YES;
    DZXZVc *vc = (DZXZVc *)[self getVCInBoard:nil ID:@"DZXZVc"];
    vc.from = 4;
    vc.preObjvalue = self.preObjvalue;
    vc.buyedZuowei = zuoweiarr[chedIndex];
    NSDictionary *dicc = [res mj_keyValues];
    vc.buyedPrice = dicc[priceArr[chedIndex]];
    vc.buyedZuoweiCode = priceArr[chedIndex];
    vc.title = @"添加12306抢票任务";
    PUSH(vc);
}

#pragma mark 点击遮罩
- (void)hideShade{
    self.shadeView.hidden = YES;
}

#pragma mark 点击
- (void)shikeb:(UIButton *)sender {
    isadd = YES;
    if (self.mainDataSource.count>0) {
        skbv = [[SKBView alloc]initWithTitles:self.mainDataSource chufadi:self.chufadi.text];
        CCPActionSheetView *alertview = [[CCPActionSheetView alloc] initWithAlertView:skbv];
        alertview.viewAnimateStyle = ViewAnimateFromTop;
        isadd = NO;

    }else{
        [self loadNetData2];

    }
    
    
}
-(void)loadNetData2{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *key = @"AwCT4ccslMB3TFQ6M8H6qadrOT8ZCXVg";
    parameters[@"partnerid"] = @"bjrwx";
    parameters[@"reqtime"] = [AppManager getCurrentTimeStrWithformat:@"yyyyMMddHHmmss"];//yyyyMMddHHmmss
    NSString *md5Key = [key md5Hash];
    NSLog(@"md5Key   %@",md5Key);
    
    parameters[@"method"] = @"get_train_info";
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",parameters[@"partnerid"],parameters[@"method"],parameters[@"reqtime"],md5Key];
    NSLog(@"sign   %@",sign);
    parameters[@"sign"] = [sign md5Hash];//md5(partnerid+method+reqtime+md5(key))
    
    
    parameters[@"train_no"] = res.train_no;
    parameters[@"train_code"] = res.train_code;
    parameters[@"purpose_codes"] = @"ADULT";
    
    NSMutableString *trainDate = [NSMutableString stringWithString:res.train_start_date];
    [trainDate insertString:@"-" atIndex:4];
    [trainDate insertString:@"-" atIndex:7];

    parameters[@"train_date"] = trainDate;//yyyy-MM-dd
    
    parameters[@"from_station"] = res.from_station_code;
    parameters[@"to_station"] = res.to_station_code;
    
    
    NSString *posturl = [NSString stringWithFormat:@"http://searchtrain.hangtian123.net/trainSearch"];
    
    NSDictionary *postPar = @{@"jsonStr":[parameters mj_JSONString]};
    
    [[Httprequest shareRequest] postObjectByParameters:postPar andUrl:posturl showLoading:YES showMsg:YES isFullUrk:YES andComplain:^(id obj) {
        NSLog(@"");
        NSDictionary *dic = obj;
        @try {
            if (dic[@"data"]) {
                if (dic[@"data"][0][@"data"]) {
                    NSArray *arr = dic[@"data"][0][@"data"];
                    self.mainDataSource = [NSMutableArray array];
                    
                    for (NSDictionary *dictt in arr) {
                        NSMutableArray *arr2 = [NSMutableArray array];
                        [arr2 addObject:dictt[@"station_name"]];
                        [arr2 addObject:dictt[@"arrive_time"]];
                        [arr2 addObject:dictt[@"start_time"]];
                        [arr2 addObject:dictt[@"stopover_time"]];
                        [self.mainDataSource addObject:arr2];
                    }
                }
            }
            if (isadd ) {
                [skbv.superview removeFromSuperview];
                skbv = [[SKBView alloc]initWithTitles:self.mainDataSource chufadi:self.chufadi.text];
                CCPActionSheetView *alertview = [[CCPActionSheetView alloc] initWithAlertView:skbv];
                alertview.viewAnimateStyle = ViewAnimateFromTop;

            }
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    } andError:nil];
    
}

- (IBAction)buysubact1:(UIButton *)sender {
}
@end
