//

//  SearchResVc.m
//  CommonProject
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SearchResVc.h"
#import "NSString+Hash.h"
#import "CocoaSecurity.h"
#import "NSString+Encryption.h"
#import "RSA.h"
#import "HZQDatePickerView.h"
#import "SelectTimeView.h"
#import "CalenderView.h"
#import "BuyTicketChooeseSeatVc.h"

#import "RMCalendarController.h"
#import "MJExtension.h"

@implementation ResultCell



@end

@interface SearchResVc ()<UITableViewDelegate,UITableViewDataSource,HZQDatePickerViewDelegate>
{
    TrainStation *st1;
    TrainStation *st2;
    HZQDatePickerView *_pikerView;
    NSString *train_date;
    UIButton *shaixuanView;
    BOOL gt;
    BOOL dc;
    BOOL pt;
    BOOL qt;
    NSString *startTime;
    NSString *endTime;
    NSString *tmpstartTime;
    NSString *tmpendTime;
    BOOL showPrice;
    NSMutableArray *originalDataSource;
    NSMutableArray *selectDatas;
    NSInteger isgtdc;
    NSInteger cur_chose_time;
    UIButton *suresxBtn;
    UIView *shadeView;
    NSIndexPath *_indexPath;
    
}

/**
 *  前一天
 */
@property(nonatomic,strong)UIButton * yesterdayButton;
/**
 *   后一天
 */
@property(nonatomic,strong)UIButton * tomorrowButton;
/**
 *   今天
 */
@property(nonatomic,strong)UIButton * todayButton;
/**
 *   发车地
 */
@property(nonatomic,strong)UILabel * startLabel;
/**
 *   目的地
 */
@property(nonatomic,strong)UILabel * overLabel;

@end

@implementation SearchResVc

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetData2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//      self.navigationController.navigationBar.translucent = NO;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
    
    //发车label
    UILabel * startLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,30)];
    startLabel.font = Font(18);
    startLabel.textAlignment = NSTextAlignmentRight;
    startLabel.textColor = TitleColor;
    _startLabel = startLabel;
    [titleView addSubview:startLabel];
    
    //到达label
    UILabel * overLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleView.frame.size.width - 100, 0, 100, 30)];
    _overLabel = overLabel;
    overLabel.font = Font(18);
    overLabel.textAlignment = NSTextAlignmentLeft;
    overLabel.textColor = TitleColor;
    [titleView addSubview:overLabel];
    
    //中间的转换图标
    UIButton * changeButton = [[UIButton alloc]initWithFrame:CGRectMake(startLabel.frame.size.width, 0, 50, 30)];
    [changeButton setImage:[UIImage imageNamed:@"huhuan_icon"] forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"huhuan_icon"] forState:UIControlStateHighlighted];
    [titleView addSubview:changeButton];
    
    [changeButton addTarget:self action:@selector(qiehuanClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.titleView = titleView;
    
    
    //设置日期
    UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, 40)];
    oneView.backgroundColor = BlueColor;
    [self.view addSubview:oneView];
    
    //前一天
    UIButton * yesterdayButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, (SWIDTH - 30)/3 - 10, 40)];
    _yesterdayButton = yesterdayButton;
    [yesterdayButton setTitle:@"前一天" forState:UIControlStateNormal];
    [yesterdayButton setTitleColor:TitleColor forState:UIControlStateNormal];
    yesterdayButton.titleLabel.font = Font(14);
    [yesterdayButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateSelected];
    yesterdayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [oneView addSubview:yesterdayButton];
    
    [yesterdayButton addTarget:self action:@selector(predayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //日期
    UIImageView * dataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(yesterdayButton.frame.origin.x + yesterdayButton.width, 10, 20, 20)];
    UIImage * dataImage = [UIImage imageNamed:@"qili"];
    dataImageView.contentMode = UIViewContentModeScaleAspectFill;
    dataImageView.image = dataImage;
    [oneView addSubview:dataImageView];
    
    //今天
    UIButton * todayButton = [[UIButton alloc]initWithFrame:CGRectMake(dataImageView.frame.origin.x + dataImageView.width, 0, (SWIDTH - 30)/3, 40)];
    _todayButton = todayButton;
//    [todayButton setTitle:@"前一天" forState:UIControlStateNormal];
    [todayButton setTitleColor:TitleColor forState:UIControlStateNormal];
    todayButton.titleLabel.font = Font(14);
    todayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [oneView addSubview:todayButton];
    
    [todayButton addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //明天
    UIButton * tomorrowButton = [[UIButton alloc]initWithFrame:CGRectMake(todayButton.frame.origin.x + todayButton.width, 0, (SWIDTH - 30)/3 - 10, 40)];
    _tomorrowButton = tomorrowButton;
    [tomorrowButton setTitle:@"后一天" forState:UIControlStateNormal];
    [tomorrowButton setTitleColor:TitleColor forState:UIControlStateNormal];
    tomorrowButton.titleLabel.font = Font(14);
    tomorrowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [oneView addSubview:tomorrowButton];
    
    [tomorrowButton addTarget:self action:@selector(newxtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_isFromDZ) {
        oneView.hidden = YES;
        UIButton * sure_Button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [sure_Button setTitle:@"确定" forState:UIControlStateNormal];
        [sure_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sure_Button.titleLabel.font = [UIFont mysystemFontOfSize:14];
        [sure_Button addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:sure_Button];
        self.navigationItem.rightBarButtonItem = rightButton;
        self.mainTableView.frame = CGRectMake(0, 0, SWIDTH, SHEIGHT - 47);
    }
    else{
       self.mainTableView.frame = CGRectMake(0, oneView.bottom, SWIDTH, SHEIGHT - oneView.bottom - 44);
    }
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SWIDTH, SHEIGHT)];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    view.hidden = YES;
//    view.top = 64;
    shadeView = view;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:view];

    self.mainTableView.backgroundColor = BgWhiteColor;
    NSArray *arr = self.preObjvalue;
    self.bglightV.hidden = YES;
    [self.bglightV.superview sendSubviewToBack:self.bglightV];
    selectDatas = [NSMutableArray array];
    @try {
        st1 = arr[0];
        st2 = arr[1];
        train_date = arr[2];
        isgtdc = [arr[3] integerValue];
        NSDate *date  = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"yyyy-MM-dd";
        if ([[fmt stringFromDate:date] isEqualToString:train_date]) {
            _yesterdayButton.enabled = NO;
            [_yesterdayButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateNormal];
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    //    NSInteger xsp = [arr[4] integerValue];
    [startLabel setText:st1.name];
    [overLabel setText:st2.name];
//    [self.chufadi setText:st1.name];
//    [self.mudidi setText:st2.name];
    
    
    
    
    NSString *str = [train_date stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    str = [str stringByAppendingString:@"日"];
    [todayButton setTitle:str forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNetData2];

    }];
    //    [self loadNetData2];
    [self.mainTableView.mj_header beginRefreshing];
    tmpstartTime = @"00:00";
    tmpendTime = @"24:00";
    NSDate *date = [AppManager dateFromString:train_date format:@"yyyy-MM-dd"] ;
    
    cur_chose_time = [date timeIntervalSince1970];
    NSLog(@"");
    if (_from==6) {
        _qiehuan.userInteractionEnabled = NO;
    }
    
    
}


#pragma mark 车次信息
-(void)loadNetData2{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    

    parameters[@"train_date"] = train_date;//yyyy-MM-dd
    
    parameters[@"from_station"] = st1.szm;
    parameters[@"to_station"] = st2.szm;
    
    parameters[@"purpose_codes"] = @"ADULT";
    NSString *posturl = [NSString stringWithFormat:@"https://api.renxing12306.com/Open/train_query_a"];
    
    NSDictionary *postPar = @{@"data":[parameters mj_JSONString]};
    shadeView.hidden = NO;
    _qiehuan.userInteractionEnabled = NO;
    
    [[Httprequest shareRequest] postObjectByParameters:postPar andUrl:posturl showLoading:NO showMsg:YES isFullUrk:YES andComplain:^(id obj) {
        NSLog(@"");
        NSArray *arr= obj[@"data"];
        NSLog(@"%@",obj);
        NSString * codeID = [NSString stringWithFormat:@"%@",obj[@"code"]];
        NSString * msg = obj[@"msg"];
        if ([codeID isEqualToString:@"200"]) {
            _qiehuan.userInteractionEnabled = YES;
            self.mainDataSource = [CheCiRes mj_objectArrayWithKeyValuesArray:arr];
            NSString *tdtime = [AppManager getCurrentTimeStrWithformat:@"yyyy-MM-dd"];
            NSString *slectCheci = [[NSUserDefaults standardUserDefaults]objectForKey:SelectCheCiKey];
            NSArray *contentArray = [slectCheci componentsSeparatedByString:@" ,"];
            for (int i=0; i<self.mainDataSource.count;i++) {
                CheCiRes *res  = self.mainDataSource[i];
                res.train_start_date = [train_date stringByReplacingOccurrencesOfString:@"-" withString:@""];
                ;
                
                if (contentArray.count>1) {
                    for (int j=0; j<contentArray.count; j++) {
                        NSString *code = contentArray[j];
                        code = [code stringByReplacingOccurrencesOfString:@"," withString:@""];
                        if ([res.train_code isEqualToString:code]) {
                            res.isChoosed = YES;
                            [selectDatas addObject:res];
                            continue;
                        }
                    }
                }
            }
            //我删除的
           if ([tdtime isEqualToString:train_date]) {
                NSString *time = [AppManager getCurrentTimeStrWithformat:@"HH:mm"];
                NSInteger minute = [self solveMinuteWithTime:time];
                //过滤一小时内的车次
                NSInteger count = 30;
                for (int i=0; i<self.mainDataSource.count;) {
                    CheCiRes *res  = self.mainDataSource[i];
                    
                    NSInteger sttime = [self solveMinuteWithTime:res.start_time];
                    if (sttime-minute<count) {
                        [self.mainDataSource removeObject:res];
                        
                    }else{
                        i++;
                    }
                }
               
            }
            originalDataSource = self.mainDataSource;
            [self.mainTableView reloadData];
            
            
            if (isgtdc && !_isputong) {
                
                [self shaixuan:nil];
                [self sureShaixuan:suresxBtn];
                [shaixuanView removeFromSuperview];
                shaixuanView = nil;
            }else if (_isputong){
                [self shaixuan:nil];
                [self sureShaixuan:suresxBtn];
                [shaixuanView removeFromSuperview];
                shaixuanView = nil;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
            });
            
            if (_from==6) {
                _qiehuan.userInteractionEnabled = NO;
            }
        }
        else{
            [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
        }
         shadeView.hidden = YES;
        if ([self.mainTableView.mj_header isRefreshing]) {
            [self.mainTableView.mj_header endRefreshing];
            
        }
        if ([self.mainTableView.mj_footer isRefreshing]) {
            [self.mainTableView.mj_footer endRefreshing];
            
        }
        
    } andError:^(id error) {
        shadeView.hidden = YES;
        _qiehuan.userInteractionEnabled = YES;
        if ([self.mainTableView.mj_header isRefreshing]) {
            [self.mainTableView.mj_header endRefreshing];
            
        }
        if ([self.mainTableView.mj_footer isRefreshing]) {
            [self.mainTableView.mj_footer endRefreshing];
            
        }
        if (_from==6) {
            _qiehuan.userInteractionEnabled = NO;
        }
    }];
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //是否来自于坐席订制
    if (self.isFromDZ) {
        
        CheCiRes *res = self.mainDataSource[indexPath.row];
        if (!res.isChoosed) {
            if (self.issingle) {
                [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CheCiRes *res = obj;
                    res.isChoosed = NO;
                }];
            }else{
                if (selectDatas.count>=5) {
                    [MBProgressHUD showHudWithString:@"本次只能选择5个车次" model:MBProgressHUDModeCustomView];
                    return;
                }
            }
        }
        res.isChoosed = !res.isChoosed;
        
        [self.mainTableView reloadData];
        [selectDatas removeAllObjects];
        [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CheCiRes *res = obj;
            if (res.isChoosed) {
                [selectDatas addObject:res];
            }
        }];
        
        if (self.touchEvent) {
            self.touchEvent(selectDatas);
            
        }
        if (self.stationInfo) {
            self.stationInfo(st1, st2);
        }
        if (self.issingle) {
            POP;
        }
        return;
    }
    //跳转到买票的界面
    CheCiRes *res = self.mainDataSource[indexPath.row];
    BuyTicketChooeseSeatVc *vc = (BuyTicketChooeseSeatVc *)( BaseViewController *)[self getVCInBoard:nil ID:@"BuyTicketChooeseSeatVc"];
    vc.preObjvalue = res;
    //from是改签
    if (_from==6) {
        [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CheCiRes *res = obj;
            res.isChoosed = NO;
        }];
        [self.mainTableView reloadData];
        ResultCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chooseBtn.selected = YES;
        vc.isGaiqian = YES;
        vc.orderID = self.orderID;
        vc.orderURL = self.orderURL;
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            cell.chooseBtn.selected = NO;
        //        });
    }
    PUSH(vc);
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataSource.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(ResultCell  *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    CheCiRes *res = self.mainDataSource[indexPath.row];
    cell.chufadi.text = res.from_station_name;
    cell.mudidi.text = res.to_station_name;
    cell.yuyueBtn.userInteractionEnabled = NO;
    cell.lishi.text = [NSString stringWithFormat:@"%@分",[res.run_time stringByReplacingOccurrencesOfString:@":" withString:@"时"] ];
    
    cell.chufashijian.text = res.start_time;
    cell.daodashijian.text = res.arrive_time;
    cell.checi.text = res.train_code;
    cell.yuyueBtn.hidden = YES;
    //    cell.jiage.text = [NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]]];
    NSString * priceString = [NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]];
    [str addAttribute:NSForegroundColorAttributeName value:OrangeColor range:NSMakeRange(0,[priceString rangeOfString:@"."].location + 2)];
    [str addAttribute:NSForegroundColorAttributeName value:qiColor range:NSMakeRange([priceString rangeOfString:@"."].location + 2 , 1)];
    [str addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:Font(18) range:NSMakeRange(1, [priceString rangeOfString:@"."].location + 2)];
    [str addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([priceString rangeOfString:@"."].location + 2, 1)];
    
    //    cell.jiage.text = [NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]];
    cell.jiage.attributedText = str;
    
    //    cell.jiage.font = Font(16);
    cell.jiage.minimumScaleFactor = 0.5;
    if (self.isFromDZ) {
        cell.chooseBtn.hidden = NO;
    }else{
        cell.chooseBtn.hidden = YES;
        cell.chufadi.left = 12;
        cell.chufashijian.left = 12;
    }
    cell.chooseBtn.selected = res.isChoosed;
    
    cell.chooseBtn.userInteractionEnabled = NO;
    
    //设置中间指示图片
    if ([res.start_station_name isEqualToString:res.from_station_name]) {
        if ([res.end_station_name isEqualToString:res.to_station_name]) {
            cell.indicatorView.image = [UIImage imageNamed:@"qi-zhong"];
        }else{
            cell.indicatorView.image = [UIImage imageNamed:@"qi-zhuan"];
            
        }
    }else{
        if ([res.end_station_name isEqualToString:res.to_station_name]) {
            cell.indicatorView.image = [UIImage imageNamed:@"zhuan-zhong"];
        }else{
            cell.indicatorView.image = [UIImage imageNamed:@"zhuan-zhuan"];
            
        }
    }
    
     NSArray *arr =  [self getZuowei:res];
     UIView *superv = cell.zuowei1.superview;
    //    设置显示张数和票价
    if (IsStrEmpty(res.yushouriqi)) {
        
        //    设置显示张数和票价
        
       
        NSMutableArray *searTypeArr = [NSMutableArray array];
        for (NSString *ss  in arr) {
            [searTypeArr addObject:[ss componentsSeparatedByString:@":"].firstObject];
        }
        res.seatTypeArr = searTypeArr;
        
       
//        CGFloat w  = SWIDTH -16- (arr.count+1)*5;
        
//        CGFloat ww = w/arr.count;
        for (UIView *v in superv.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                
            }else{
                v.centerY = v.superview.height*0.5;
                v.hidden = YES;
                
            }
            
        }
        
        NSInteger index = 1;
        UILabel *preL;
        for (NSString *price in arr) {
            UILabel *l = [superv viewWithTag:index];
            l.text = price;
            l.textColor = zhangColor;
            if ([price containsString:@":0张"]) {
                l.textColor = qiColor;
            }
            
            
            
            if (index==1) {
                l.textAlignment = NSTextAlignmentLeft;
                l.width = cell.chufashijian.width;
                
                CGFloat ww = l.width;
                [l sizeToFit];
                if (l.width>ww) {
                    l.width = ww;
                }else if ([price containsString:@":0张"]) {
                    l.width+=10;
                }
                l.left = cell.chufadi.left;
                
            }else if (index==2) {
                l.textAlignment = NSTextAlignmentCenter;
                
                l.width = cell.lishi.width;
                CGFloat ww = l.width;
                [l sizeToFit];
                if (l.width>ww) {
                    l.width = ww;
                }else if ([price containsString:@":0张"]) {
                    l.width+=10;
                }
                l.centerX  = cell.lishi.centerX;
                
            }else if (index==3) {
                l.textAlignment = NSTextAlignmentRight;
                
                l.width = cell.daodashijian.width;
                l.right = cell.mudidi.right;
                
                
            }else if (index==4) {
                l.textAlignment = NSTextAlignmentRight;
                l.textAlignment = NSTextAlignmentLeft;
                l.width = cell.jiage.width;
                
                CGFloat ww = l.width;
                [l sizeToFit];
                if (l.width>ww) {
                    l.width = ww;
                }else if ([price containsString:@":0张"]) {
                    l.width+=10;
                }
                
                l.right = cell.jiage.right;
            }
            if ([price containsString:@":0张"]) {
                
                UILabel *qiang = [superv viewWithTag:index+10-1];
                qiang.hidden = NO;
                l.width-=10;
                qiang.left = l.right;
                //            qiang.top = l.top-5;
                //            qiang.layer.cornerRadius = 7.5;
                //            qiang.layer.masksToBounds = YES;
                if (qiang.tag==12) {
                    //                qiang.top = l.top-1;
                }
            }
            l.hidden = NO;
            preL = l;
            l.centerY = l.superview.height*0.5;
            CGFloat hhhhhh = 10.0/320*SWIDTH;
            if (hhhhhh>14) {
                hhhhhh = 14;
            }
            l.font = Font(hhhhhh);
            index+=1;
        }
        BOOL iszero = YES;
        for (NSString *price in arr) {
            if (![price containsString:@":0张"]) {
                iszero = NO;
                break;
            }
        }
//预约抢票时的价格，张数
        if (res.note.length>0) {
            cell.shuoming.text = res.note;
            cell.shuoming.hidden = NO;
            cell.yuyueBtn.hidden = NO;
            [cell.yuyueBtn setTitle:@"预约" forState:UIControlStateNormal];
            
            for (UIView *v in superv.subviews) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    
                }else{
                    v.centerY = v.superview.height*0.5;
                    v.hidden = YES;
                }
            }
            cell.shuoming.hidden = NO;
        }else{
            
            cell.shuoming.hidden = YES;
            cell.yuyueBtn.hidden = YES;
            
        }
        
        
        if (iszero) {
            [cell.yuyueBtn setTitle:@"可抢票" forState:UIControlStateNormal];
            cell.yuyueBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            cell.yuyueBtn.hidden = NO;
            cell.yuyueBtn.userInteractionEnabled = NO;
            [cell.shuoming bringSubviewToFront:cell.zuowei1];
            //        cell.zuowei1.frame = CGRectMake(8, 4, 200, 22);
            cell.shuoming.hidden = NO;
            cell.shuoming.text = @"暂无余票 , 建议人工线下抢票,成功率百分之98%";
            cell.shuoming.textColor = OrangeColor;
            cell.shuoming.font = [UIFont systemFontOfSize:11];
            for (int i = 10; i <15; i++) {
                UILabel *qiang = [superv viewWithTag:i];
                qiang.hidden = YES;
            }
            cell.zuowei2.hidden = YES;
            cell.zuowei3.hidden = YES;
            cell.zuowei4.hidden = YES;
            cell.zuowei1.hidden = YES;
        }
        
    }
    else{
        for (int i = 1; i <= arr.count; i++) {
            UILabel *l = [superv viewWithTag:i];
            l.hidden = YES;
        }
        cell.shuoming.hidden = NO;
        cell.robLabel1.hidden = YES;
        cell.robLabel2.hidden = YES;
        cell.robLabel3.hidden = YES;
        cell.robLabel4.hidden = YES;
        cell.shuoming.font = [UIFont mysystemFontOfSize:11];
        cell.shuoming.textColor = OrangeColor;
        NSArray * dateArray = [res.yushouriqi componentsSeparatedByString:@"-"];
        NSString * timeNsstring1 = [res.sale_date_time substringWithRange:NSMakeRange(0, 2)];
        NSString * timeNsstring2 = [res.sale_date_time substringWithRange:NSMakeRange(2, 2)];
        if ([timeNsstring2 isEqualToString:@"00"]) {
            cell.shuoming.text = [NSString stringWithFormat:@"%@月%@日%@点起售,可预约抢票,开售自动抢票",dateArray[1],dateArray[2],timeNsstring1];
        }
        else{
            //%@月%@日%@点%@分起售,可预约抢票,开售自动抢票
            cell.shuoming.text = [NSString stringWithFormat:@"%@月%@日%@点%@分起售,可预约抢票,开售自动抢票",dateArray[1],dateArray[2],timeNsstring1,timeNsstring2];
        }
        cell.yuyueBtn.hidden = NO;
        [cell.yuyueBtn setTitle:@"去预约" forState:UIControlStateNormal];
        cell.yuyueBtn.backgroundColor = BlueColor;
    }
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resue = @"searchres";
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:resue];
    if (!cell) {
        cell = [[ResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resue];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    CheCiRes *res = self.mainDataSource[indexPath.row];
    cell.chufadi.text = res.from_station_name;
    cell.mudidi.text = res.to_station_name;
    cell.yuyueBtn.userInteractionEnabled = NO;
    cell.lishi.text = [NSString stringWithFormat:@"%@分",[res.run_time stringByReplacingOccurrencesOfString:@":" withString:@"时"] ];
    
    cell.chufashijian.text = res.start_time;
    cell.daodashijian.text = res.arrive_time;
    cell.checi.text = res.train_code;
    cell.yuyueBtn.hidden = YES;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]]];
    NSString * priceString = [NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]];
    [str addAttribute:NSForegroundColorAttributeName value:huangTiColor range:NSMakeRange(0, [priceString rangeOfString:@"."].location + 2)];
    [str addAttribute:NSForegroundColorAttributeName value:qiColor range:NSMakeRange([priceString rangeOfString:@"."].location + 2 , 1)];
    [str addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:Font(18) range:NSMakeRange(1, [priceString rangeOfString:@"."].location + 1)];
    [str addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([priceString rangeOfString:@"."].location + 2, 1)];
    //    cell.jiage.text = [NSString stringWithFormat:@"¥%.1f起", [[self getMinPrice:res] floatValue]];
    cell.jiage.attributedText = str;
    //    cell.jiage.font = Font(16);
    cell.jiage.minimumScaleFactor = 0.5;
    
    
    cell.chooseBtn.selected = res.isChoosed;
    
    cell.chooseBtn.userInteractionEnabled = NO;
    
    //设置中间指示图片
    if ([res.start_station_name isEqualToString:res.from_station_name]) {
        if ([res.end_station_name isEqualToString:res.to_station_name]) {
            cell.indicatorView.image = [UIImage imageNamed:@"qi-zhong"];
        }else{
            cell.indicatorView.image = [UIImage imageNamed:@"qi-zhuan"];
            
        }
    }else{
        if ([res.end_station_name isEqualToString:res.to_station_name]) {
            cell.indicatorView.image = [UIImage imageNamed:@"zhuan-zhong"];
        }else{
            cell.indicatorView.image = [UIImage imageNamed:@"zhuan-zhuan"];
            
        }
    }
    
    if (self.isFromDZ||_from==6) {
        cell.chooseBtn.hidden = NO;
    }else{
        cell.chooseBtn.hidden = YES;
        cell.chufadi.left = 12;
        cell.chufashijian.left = 12;
    }
    NSArray *arr =  [self getZuowei:res];
   
     UIView *superv = cell.zuowei1.superview;
     //    设置显示张数和票价
    if (IsStrEmpty(res.yushouriqi)) {
       
        
       NSMutableArray *searTypeArr = [NSMutableArray array];
        for (NSString *ss  in arr) {
            [searTypeArr addObject:[ss componentsSeparatedByString:@":"].firstObject];
        }
        res.seatTypeArr = searTypeArr;
        
        for (UIView *v in superv.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                
            }else{
                v.centerY = v.superview.height*0.5;
                v.hidden = YES;
                
            }
            
        }
        
        NSInteger index = 1;
        UILabel *preL;
        for (NSString *price in arr) {
            UILabel *l = [superv viewWithTag:index];
            l.text = price;
            l.textColor = [UIColor blackColor];
            
            
            
            if (index==1) {
                l.textAlignment = NSTextAlignmentLeft;
                l.width = cell.chufashijian.width;
                
                CGFloat ww = l.width;
                [l sizeToFit];
                if (l.width>ww) {
                    l.width = ww;
                }else if ([price containsString:@":0张"]) {
                    l.width+=10;
                }
                l.left = cell.chufadi.left;
                
            }else if (index==2) {
                l.textAlignment = NSTextAlignmentCenter;
                
                l.width = cell.lishi.width;
                CGFloat ww = l.width;
                [l sizeToFit];
                if (l.width>ww) {
                    l.width = ww;
                }else if ([price containsString:@":0张"]) {
                    l.width+=10;
                }
                l.centerX  = cell.lishi.centerX;
                
            }else if (index==3) {
                l.textAlignment = NSTextAlignmentRight;
                
                l.width = cell.daodashijian.width;
                l.right = cell.mudidi.right;
                
                
            }else if (index==4) {
                l.textAlignment = NSTextAlignmentRight;
                l.textAlignment = NSTextAlignmentLeft;
                l.width = cell.jiage.width;
                
                CGFloat ww = l.width;
                [l sizeToFit];
                if (l.width>ww) {
                    l.width = ww;
                }else if ([price containsString:@":0张"]) {
                    l.width+=10;
                }
                
                l.right = cell.jiage.right;
            }
            if ([price containsString:@":0张"]) {
                
                UILabel *qiang = [superv viewWithTag:index+10-1];
                qiang.hidden = NO;
                l.width-=10;
                qiang.left = l.right;
                //            qiang.top = l.top-5;
                //            qiang.layer.cornerRadius = 7.5;
                //            qiang.layer.masksToBounds = YES;
                //            qiang.backgroundColor = [UIColor redColor];
                if (qiang.tag==12) {
                    //                qiang.top = l.top-1;
                }
            }
            l.hidden = NO;
            preL = l;
            l.centerY = l.superview.height*0.5;
            CGFloat hhhhhh = 10.0/320*SWIDTH;
            if (hhhhhh>14) {
                hhhhhh = 14;
            }
            l.font = Font(hhhhhh);
            index+=1;
        }
        BOOL iszero = YES;
        for (NSString *price in arr) {
            if (![price containsString:@":0张"]) {
                iszero = NO;
                break;
            }
        }
// 预约抢票时的价格，张数
        if (res.note.length>0) {
            cell.shuoming.text = res.note;
            cell.shuoming.hidden = NO;
            cell.yuyueBtn.hidden = NO;
            [cell.yuyueBtn setTitle:@"预约" forState:UIControlStateNormal];
            
            for (UIView *v in superv.subviews) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    
                }else{
                    v.centerY = v.superview.height*0.5;
                    v.hidden = YES;
                }
            }
            cell.shuoming.hidden = NO;
        }else{
            
            cell.shuoming.hidden = YES;
            cell.yuyueBtn.hidden = YES;
            
        }
        
        //没有票
        if (iszero) {
            [cell.yuyueBtn setTitle:@"可抢票" forState:UIControlStateNormal];
            cell.yuyueBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            cell.yuyueBtn.hidden = NO;
            cell.yuyueBtn.userInteractionEnabled = NO;
            [cell.shuoming bringSubviewToFront:cell.zuowei1];
            //        cell.zuowei1.frame = CGRectMake(8, 4, 200, 22);
            cell.shuoming.hidden = NO;
            cell.shuoming.text = @"暂无余票 , 建议人工线下抢票,成功率百分之98%";
            cell.shuoming.textColor = OrangeColor;
            cell.shuoming.font = [UIFont systemFontOfSize:11];
            for (int i = 11; i <15; i++) {
                UILabel *qiang = [superv viewWithTag:i];
                qiang.hidden = YES;
            }
            
            cell.zuowei1.hidden = YES;
            cell.zuowei2.hidden = YES;
            cell.zuowei3.hidden = YES;
            cell.zuowei4.hidden = YES;
            
            
        }
        
    }
    else{
        for (int i = 1; i <= arr.count; i++) {
            UILabel *l = [superv viewWithTag:i];
            l.hidden = YES;
        }
        cell.shuoming.hidden = NO;
        cell.robLabel1.hidden = YES;
        cell.robLabel2.hidden = YES;
        cell.robLabel3.hidden = YES;
        cell.robLabel4.hidden = YES;
        cell.shuoming.font = [UIFont mysystemFontOfSize:11];
        cell.shuoming.textColor = OrangeColor;
        NSArray * dateArray = [res.yushouriqi componentsSeparatedByString:@"-"];
        NSString * timeNsstring1 = [res.sale_date_time substringWithRange:NSMakeRange(0, 2)];
        NSString * timeNsstring2 = [res.sale_date_time substringWithRange:NSMakeRange(2, 2)];
        if ([timeNsstring2 isEqualToString:@"00"]) {
            cell.shuoming.text = [NSString stringWithFormat:@"%@月%@日%@点起售,可预约抢票,开售自动抢票",dateArray[1],dateArray[2],timeNsstring1];
        }
        else{
            //%@月%@日%@点%@分起售,可预约抢票,开售自动抢票
            cell.shuoming.text = [NSString stringWithFormat:@"%@月%@日%@点%@分起售,可预约抢票,开售自动抢票",dateArray[1],dateArray[2],timeNsstring1,timeNsstring2];
        }
        cell.yuyueBtn.hidden = NO;
        [cell.yuyueBtn setTitle:@"去预约" forState:UIControlStateNormal];
        cell.yuyueBtn.backgroundColor = BlueColor;
       
    }
    return cell;
}
-(NSString *)getMinPrice:(CheCiRes *)res{
    NSString *place = @"--";
    NSDictionary *dicc = [res mj_keyValues];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in dicc.allKeys) {
        if ([key containsString:@"_num"] && ![dicc[key] isEqualToString:place]) {
            NSString *newk = [key stringByReplacingOccurrencesOfString:@"_num" withString:@"_price"];
            [keys addObject:dicc[newk]];
        }
    }
    [keys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 floatValue]<[obj2 floatValue];
    }];
    
    return keys.lastObject;
}
-(NSArray *)getZuowei:(CheCiRes *)res{
    NSString *place = @"--";
    NSDictionary *dicc = [res mj_keyValues];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in dicc.allKeys) {
        if ([key containsString:@"_num"] && ![dicc[key] isEqualToString:place]) {
            [keys addObject:key];
        }
    }
    
    NSMutableArray <NSString *>*arr = [NSMutableArray array];
    for (NSString *kkkk in keys) {
        //        NSString *numkey = [kkkk stringByReplacingOccurrencesOfString:@"num" withString:@"price"];
        NSArray *aa = [self nameWithCode:kkkk];
        NSInteger index = [aa.lastObject integerValue];
        
        NSString *info = [NSString stringWithFormat:@"%02ld%@:%@张",(long)index,aa[0],dicc[kkkk]];
        if (showPrice) {
            NSString *pricekey = [kkkk stringByReplacingOccurrencesOfString:@"num" withString:@"price"];
            info = [NSString stringWithFormat:@"%02ld%@:¥%@",(long)index,aa[0],dicc[pricekey]];
        }
        
        [arr addObject:info];
    }
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        NSInteger a = [[s1 substringToIndex:2] integerValue];
        NSInteger b = [[s2 substringToIndex:2] integerValue];
        
        return a>b;
    }];
    for (int i=0; i<arr.count; i++) {
        arr[i] = [arr[i] substringFromIndex:2];
    }
    
    if (arr.count>4) {
        [arr removeLastObject];
    }
    if (arr.count>4) {
        [arr removeLastObject];
    }
    if (arr.count>4) {
        [arr removeLastObject];
    }
    return arr;
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


#pragma mark 后一天
- (IBAction)newxtAction:(UIButton *)sender {
    NSInteger space = 24*60*60;
    
    NSDate *cur = [NSDate date];
    NSString *timstr = [AppManager stringFromDate:cur format:@"yyyy-MM-dd"];
    NSDate *dateee = [AppManager dateFromString:timstr format:@"yyyy-MM-dd"];
    
    NSInteger min = [dateee timeIntervalSince1970];
    NSInteger max = min+space*30;
    
    //点击后一天获取的数据
    if ((cur_chose_time + space)>max) {
        sender.enabled = NO;
        [sender setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateNormal];
    }
    else if ((cur_chose_time + space) == max){
        sender.enabled = NO;
        [sender setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateNormal];
        cur_chose_time +=space;
    }
    
    else{
        _yesterdayButton.enabled = YES;
        cur_chose_time +=space;
        
    }
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:cur_chose_time];
    
    NSString *newStr = [AppManager stringFromDate:newDate format:@"yyyy-MM-dd"];
    train_date = newStr;
    [self dateStrtoYearStr:newStr];
    //    [self loadNetData2];
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 前一天
- (IBAction)predayAction:(UIButton *)sender {
    NSInteger space = 24*60*60;
    NSDate *cur = [NSDate date];
    NSString *timstr = [AppManager stringFromDate:cur format:@"yyyy-MM-dd"];
    NSDate *dateee = [AppManager dateFromString:timstr format:@"yyyy-MM-dd"];
    
    NSInteger min = [dateee timeIntervalSince1970];
    
    //点击前一天获取的数据
    if ((cur_chose_time - space) < min) {
        sender.enabled = NO;
         [sender setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateNormal];
    }
    else if ((cur_chose_time - space) == min){
        
        sender.enabled = NO;
        [sender setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateNormal];
        cur_chose_time -=space;
    }
    else{
        _tomorrowButton.enabled = YES;
        cur_chose_time -=space;
        
    }
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:cur_chose_time];
    
    NSString *newStr = [AppManager stringFromDate:newDate format:@"yyyy-MM-dd"];
    train_date = newStr;
    [self dateStrtoYearStr:newStr];
    
    //    [self loadNetData2];
    [self.mainTableView.mj_header beginRefreshing];
    
}
- (IBAction)shaixuan:(UIButton *)sender {
    self.bglightV.hidden = YES;
    if (shaixuanView) {
        shaixuanView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            shaixuanView.alpha = 1.0;
        }];
    }else
        [self createShaixuanView];
}
- (IBAction)chufatime:(UIButton *)sender {
    self.bglightV.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.bglightV.centerX = sender.centerX;
    }];
    
    [self.mainDataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CheCiRes *res1 = obj1;
        CheCiRes *res2 = obj2;
        NSInteger t11 = [[res1.start_time componentsSeparatedByString:@":"].firstObject integerValue]*60+ [[res1.start_time componentsSeparatedByString:@":"].lastObject integerValue];
        
        NSInteger t12 = [[res2.start_time componentsSeparatedByString:@":"].firstObject integerValue]*60+ [[res1.start_time componentsSeparatedByString:@":"].lastObject integerValue];
        
        
        return t11>t12;
        
        
    }];
    [self.mainTableView reloadData];
    
}
- (IBAction)lvxinghaoshi:(UIButton *)sender {
    self.bglightV.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.bglightV.centerX = sender.centerX;
    }];
    [self.mainDataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CheCiRes *res1 = obj1;
        CheCiRes *res2 = obj2;
        NSInteger t11 = [res1.run_time_minute integerValue];
        NSInteger t12 = [res2.run_time_minute integerValue];
        
        
        return t11>t12;
        
        
    }];
    [self.mainTableView reloadData];
    
    
}
- (IBAction)xianshipiaojia:(UIButton *)sender {
    self.bglightV.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.bglightV.centerX = sender.centerX;
    }];
    
    if ([sender.currentTitle isEqualToString:@"显示票价"]) {
        [sender setTitle:@"显示余票" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"显示票价" forState:UIControlStateNormal];
    }
    showPrice = !showPrice;
    [self.mainTableView reloadData];
}


#pragma mark 点击中间的日期
- (IBAction)dateAction:(UIButton *)sender {
    //    [self setupDateView:DateTypeOfStart];
//    [self showCalendaer];
    [self calendaer];
}

#pragma mark
#pragma mark 日历
- (void)calendaer{
    // CalendarShowTypeMultiple 显示多月
    // CalendarShowTypeSingle   显示单月
    RMCalendarController *c = [RMCalendarController calendarWithDays:60 showType:CalendarShowTypeMultiple];
    __weak typeof(self) weakSelf = self;
    // 此处用到MJ大神开发的框架，根据自己需求调整是否需要
    c.modelArr = [TicketModel mj_objectArrayWithKeyValuesArray:@[@{@"year":@2015, @"month":@7, @"day":@22,
                                                                   @"ticketCount":@194, @"ticketPrice":@283},
                                                                 @{@"year":@2015, @"month":@7, @"day":@17,
                                                                   @"ticketCount":@91, @"ticketPrice":@223},
                                                                 @{@"year":@2015, @"month":@10, @"day":@4,
                                                                   @"ticketCount":@91, @"ticketPrice":@23},
                                                                 @{@"year":@2015, @"month":@7, @"day":@8,
                                                                   @"ticketCount":@2, @"ticketPrice":@203},
                                                                 @{@"year":@2015, @"month":@7, @"day":@28,
                                                                   @"ticketCount":@2, @"ticketPrice":@103},
                                                                 @{@"year":@2015, @"month":@7, @"day":@18,
                                                                   @"ticketCount":@0, @"ticketPrice":@153}]]; //最后一条数据ticketCount 为0时不显示
    // 是否展现农历
    c.isDisplayChineseCalendar = YES;
    
    // YES 没有价格的日期可点击
    // NO  没有价格的日期不可点击
    c.isEnable = YES;
    c.title = @"选择日期";
    c.calendarBlock = ^(RMCalendarModel *model, NSIndexPath *indexPath_calender) {
        NSString * tit = [NSString stringWithFormat:@"%lu年%lu月%lu日",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day];
        _indexPath = indexPath_calender;
        
        [weakSelf.todayButton setTitle:tit forState:UIControlStateNormal];
        
        NSString * date_String = [NSString stringWithFormat:@"%lu-%02lu-%02lu",(unsigned long)model.year  ,(unsigned long)model.month,(unsigned long)model.day];
        
        [weakSelf getSelectDate:date_String type:1];
        [self dateStrtoYearStr:date_String];
        
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//        NSString * date_String = [NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)model.year,model.month,model.day];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate * lastDate = [dateFormatter dateFromString:date_String];
//        NSString *weekday = [self weekdayStringFromDate:lastDate];
//        NSLog(@"今天是%@",weekday);
//        _todayLable.text = weekday;
    };
    c.indexPath_calender = _indexPath;
    
    [self.navigationController pushViewController:c animated:YES];
}


-(void)showCalendaer{
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    view.layer.cornerRadius = 1;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];

    NSDictionary *peizhiPar = [[NSUserDefaults standardUserDefaults]objectForKey:@"peizhiPar"];

//    NSInteger oneDay = 24*60*60*1;  //1天的长度
    NSInteger userDay = [[peizhiPar objectForKey:@"advance"] integerValue];
    NSInteger stuDay = [[peizhiPar objectForKey:@"student_advance"] integerValue];
    if (userDay==0 || stuDay==0) {
        userDay = 60;
        stuDay = 75;
    }
    NSInteger day  = userDay;
    if (self.xsp) {
        day = stuDay;
    }
    

    CalenderView *calender = [[CalenderView alloc]initWithFrame:CGRectMake(30, 50, SWIDTH-60, 400)  andMaxDays:(int)day];
    calender.layer.cornerRadius = 5;
    calender.clipsToBounds = YES;
    calender.height = calender.viewHeight;
    calender.centerY = view.centerY;
    __weak typeof(self) weakSelf = self;
    calender.getDate = ^(NSString *str){
        NSLog(@"%@",str);
        [weakSelf getSelectDate:str type:1];

        [self dateStrtoYearStr:str];
    };
    [view addSubview:calender];


}

-(void)dateStrtoYearStr:(NSString *)str{
    NSMutableString *tit = [NSMutableString stringWithString:str];
    [tit replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [tit replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    [tit appendString:@"日"];
    [_todayButton setTitle:tit forState:UIControlStateNormal];
    
}
-(void)createShaixuanView{
    shaixuanView = [[UIButton alloc]init];
    
    [shaixuanView addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:shaixuanView];
    
    shaixuanView.frame = CGRectMake(0, 0, SWIDTH, SHEIGHT);
    
    shaixuanView.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:shaixuanView];
    [UIView animateWithDuration:0.2 animations:^{
        shaixuanView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    shaixuanView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAct)];
    //    [shaixuanView addGestureRecognizer:tap];
    
    CGFloat space = 45;
    CGFloat ww = SWIDTH-40;
    CGFloat h = 400;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ww, h)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [shaixuanView addSubview:view];
    view.center = shaixuanView.center;
    UILabel *titlelable;
    {
        //titlelable
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ww, space)];
        lable.textColor = BlueColor;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"筛选";
        lable.font = [UIFont systemFontOfSize:18];
        [view addSubview:lable];
        
        titlelable = lable;
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ww, 0.5)];
        view2.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:view2];
        
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(view.width-40, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        
        btn.tag = 1005;
        [view addSubview:btn];
    }
    {
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(10, titlelable.bottom, 120, 30)];
        lable1.textColor = qiColor;
        lable1.text = @"车辆类型";
        lable1.font = [UIFont systemFontOfSize:13];
        [view addSubview:lable1];
        
        {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, lable1.bottom+40, 120, 30)];
            lable.textColor = qiColor;
            lable.text = @"乘车时间";
            lable.font = [UIFont systemFontOfSize:13];
            [view addSubview:lable];
        }
        NSArray *titl = @[@"高铁(G/C)",@"动车(D)",@"普通(Z/K/T)",@"其他(L/Y等)"];
        CGFloat btnw = (view.width-20-15)/4.0;
        UIButton *lastBtn ;
        
        for (int i=0; i<4; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+(btnw+5)*i, lable1.bottom, btnw, 40)];
            [btn addTarget:self action:@selector(sxbbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor lightGrayColor];
            
            btn.backgroundColor = BlueColor;
            btn.selected = YES;
            
            if (isgtdc==YES && !_isputong) {
                if ( i<2) {
                    btn.backgroundColor = BlueColor;
                    btn.selected = YES;
                }else {
                    btn.selected = NO;
                    btn.backgroundColor = jieGuoColor;
                }
            }
            if (_isputong) {
                if ( i<2) {
                    btn.selected = NO;
                    btn.backgroundColor = jieGuoColor;
                }else {
                    btn.backgroundColor = BlueColor;
                    btn.selected = YES;
                    
                }
            }
            [btn setTitle:titl[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Font(13);
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.tag = 10+i;
            lastBtn = btn;
            [view addSubview:btn];
        }
        
        
        SelectTimeView *dateview = [[SelectTimeView alloc]initWithFrame:CGRectMake(15, lastBtn.bottom+27, (view.width-30), 200)];
        dateview.backgroundColor = [UIColor clearColor];
        
        dateview.getSelectTimeStr = ^(NSString *time1,NSString *time2){
            NSLog(@"%@  %@",time1,time2);
            tmpstartTime = time1;
            tmpendTime = time2;
            
        };
        [view addSubview:dateview];
        
        
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15,dateview.bottom, dateview.width, 45)];
            [btn addTarget:self action:@selector(sureShaixuan:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = BlueColor;
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Font(17);
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            
            
            [view addSubview:btn];
            suresxBtn = btn;
        }
    }
    
}
-(void)sxbbtnClick:(UIButton *)btn{
    //    for (int i=0; i<4; i++) {
    //        UIButton *b = [btn.superview viewWithTag:10+i];
    //        b.backgroundColor = [UIColor lightGrayColor];
    //
    //    }
    
    if ([btn.backgroundColor isEqual:BlueColor]) {
        btn.selected = NO;
        
        [btn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        btn.selected = YES;
        
        [btn setBackgroundColor:BlueColor];
    }
}
-(void)cancelAct{
    [UIView animateWithDuration:0.2 animations:^{
        shaixuanView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shaixuanView.hidden = YES;
    });
}
-(void)sureShaixuan:(UIButton *)btrn{
    startTime = tmpstartTime;
    endTime = tmpendTime;
    
    for (int i=0; i<4; i++) {
        UIButton *btn = [btrn.superview viewWithTag:10+i];
        
        if (btn.selected) {
            switch (btn.tag) {
                case 10:
                    gt = YES;
                    break;
                case 11:
                    dc = YES;
                    break;
                case 12:
                    pt = YES;
                    break;
                case 13:
                    qt = YES;
                    break;
                    
                default:
                    break;
            }
            
            
            
        }else{
            switch (btn.tag) {
                case 10:
                    gt = NO;
                    break;
                case 11:
                    dc = NO;
                    break;
                case 12:
                    pt = NO;
                    break;
                case 13:
                    qt = NO;
                    break;
                    
                default:
                    break;
            }
            
            
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        shaixuanView.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shaixuanView.hidden = YES;
    });
    
    
    
    
    //开始本地筛选
    NSMutableArray *reslut = [NSMutableArray array];
    for (CheCiRes *res  in originalDataSource) {
        if (gt || dc || pt || qt) {
            if (gt) {
                if ([res.train_type isEqualToString:@"G"] || [res.train_type isEqualToString:@"C"] ) {
                    [reslut addObject:res];
                }
            }
            if (dc) {
                if ([res.train_type isEqualToString:@"D"]) {
                    [reslut addObject:res];
                }
            }
            if (pt) {
                if ([res.train_type isEqualToString:@"Z"] || [res.train_type isEqualToString:@"K"]  || [res.train_type isEqualToString:@"T"] ||[res.train_type isEqualToString:@"D"]||[res.train_type isEqualToString:@"1"]||[res.train_type isEqualToString:@"6"]) {
                    [reslut addObject:res];
                }
            }
            if (qt) {
                if ([res.train_type isEqualToString:@"L"] || [res.train_type isEqualToString:@"Y"] ) {
                    [reslut addObject:res];
                }
            }
        }
    }
    
    
    
    NSInteger st111 = [self solveMinuteWithTime:startTime];
    NSInteger st222 = [self solveMinuteWithTime:endTime];
    
    NSMutableArray *result222 = [NSMutableArray array];
    
    for (CheCiRes *res  in reslut) {
        NSInteger tttm = [self solveMinuteWithTime:res.start_time];
        if (tttm>=st111 && tttm<=st222) {
            [result222 addObject:res];
            
        }
        
    }
    
    self.mainDataSource = result222;
    [self.mainTableView reloadData];
    
}
-(NSInteger)solveMinuteWithTime:(NSString *)str{
    if ([str componentsSeparatedByString:@":"].count) {
        
        NSInteger s21 =  [[str componentsSeparatedByString:@":"].firstObject integerValue];
        NSInteger s22 =  [[str componentsSeparatedByString:@":"].lastObject integerValue];
        NSInteger endminute = s21*60+s22;
        return endminute;
    }
    return 0;
    
}
- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, SWIDTH, SHEIGHT + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    // 今天开始往后的日期
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    //    NSDate *cur = [NSDate date];
    
    NSInteger oneDay = 24*60*60*1;  //1天的长度
    
    NSDate *theDate = [[NSDate date] initWithTimeIntervalSinceNow: +oneDay*30]; 
    // 在今天之前的日期
    [_pikerView.datePickerView setMaximumDate:theDate];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    
    train_date = date;
    
    NSDate *date2 = [AppManager dateFromString:train_date format:@"yyyy-MM-dd"] ;
    
    cur_chose_time = [date2 timeIntervalSince1970];
    
    //    [self loadNetData2];
    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark 点击更换地点
- (IBAction)qiehuanClick:(UIButton *)sender {
    TrainStation *st = st1;
    st1 = st2;
    st2 = st;
    [self setStaionTtile];
}

#pragma mark 交换地点
-(void)setStaionTtile{
    _startLabel.text = st1.name;
    _overLabel.text = st2.name;
    //    [self loadNetData2];
    [self.mainTableView.mj_header beginRefreshing];
    
}

#pragma mark 点击确定按钮
- (void)clickSure:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
