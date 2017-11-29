//
//  SubmitOrderVc.m
//  CommonProject
//
//  Created by gaoguangxiao on 2017/1/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SubmitOrderVc.h"
#import "ChoosePerson.h"
#import "CBAlertView.h"
#import "ChangyongPsvc.h"
#import "OrderDetailAndPay.h"
#import "ShowListView.h"
#import "WXInsuranceController.h"
#import "ChooseSeatView.h"
#import "BookingDetailsViewController.h"
#import "UIViewController+BackButtonHandler.h"


@interface SubmitOrderVc ()<UITextFieldDelegate,BackButtonHandlerProtocol>
{
    
    CheCiRes *res;
    NSArray *baoxianInfo;
    UserInfo *shouhuoInfo;
    UIView *chooseZxView;
    
    ShowListView *showL ;
    NSIndexPath  *_indexPath_insurance;
    NSString * _biaoXianString;
}

@property(nonatomic,strong)UIButton * nextBtn;
@property (strong, nonatomic) IBOutlet IBView *addPersonView;
@property(nonatomic,weak)UIView * seatView;
@property(nonatomic,strong)NSArray * seatTypeArray;
@property(nonatomic,weak)UIView * chooseSeat_View;
@property(nonatomic,strong)NSArray * tagArray;
/**
 *   点击支持在线选座
 */
@property(nonatomic,weak)UIButton * chooseSeat_Btn;

@end

@implementation SubmitOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _seatTypeArray = [NSArray array];
    _tagArray = [NSArray array];
    _biaoXianString = @"¥30";
    self.topBgView.frame = CGRectMake(0, 0, SWIDTH, 84);
    self.zuoweijiageview.frame = CGRectMake(0, self.topBgView.bottom, SWIDTH, 38);
    self.scrollview.frame = CGRectMake(0, self.zuoweijiageview.bottom,SWIDTH, SHEIGHT - self.zuoweijiageview.bottom - 47 );
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectCKKey];;
    
    UIButton * right_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [right_Btn setTitle:@"订票须知" forState:UIControlStateNormal];
    right_Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right_Btn.titleLabel.font = [UIFont mysystemFontOfSize:14];
    [right_Btn addTarget:self action:@selector(clickXuZhi:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right_Btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //添加/编辑乘车人
    UIButton * addPerson_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SWIDTH/2, self.addPersonView.height)];
    [addPerson_Btn setTitle:@"添加/编辑乘车人" forState:UIControlStateNormal];
    [addPerson_Btn setTitleColor:BlueColor forState:UIControlStateNormal];
    addPerson_Btn.backgroundColor = [UIColor clearColor];
    addPerson_Btn.titleLabel.font = [UIFont mysystemFontOfSize:17];
    [addPerson_Btn addTarget:self action:@selector(tjckAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addPersonView addSubview:addPerson_Btn];
    
    UIView * line_View = [[UIView alloc]initWithFrame:CGRectMake(SWIDTH/2 - 0.5, 10, 1, 30)];
    line_View.backgroundColor = E5Color;
    [self.addPersonView addSubview:line_View];
    
    //添加儿童乘客
    UIButton * addChildren_Btn = [[UIButton alloc]initWithFrame:CGRectMake(addPerson_Btn.right, 0, SWIDTH/2, self.addPersonView.height)];
    [addChildren_Btn setTitle:@"添加儿童乘客" forState:UIControlStateNormal];
    [addChildren_Btn setTitleColor:BlueColor forState:UIControlStateNormal];
    addChildren_Btn.backgroundColor = [UIColor clearColor];
    addChildren_Btn.titleLabel.font = [UIFont mysystemFontOfSize:17];
    [addChildren_Btn addTarget:self action:@selector(ClickWithaddChildren) forControlEvents:UIControlEventTouchUpInside];
    [self.addPersonView addSubview:addChildren_Btn];
    
    UIView * chooseSeat_View = [[UIView alloc]initWithFrame:CGRectMake(0, self.addPersonView.bottom + 5 + 103, SWIDTH, 47)];
    chooseSeat_View.backgroundColor = [UIColor whiteColor];
    self.chooseSeat_View = chooseSeat_View;
    [self.scrollview addSubview:chooseSeat_View];
    
    UILabel * lineSeat_Label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, chooseSeat_View.height)];
    lineSeat_Label.text = @"在线选座";
    lineSeat_Label.font = [UIFont mysystemFontOfSize:15];
    lineSeat_Label.textAlignment = NSTextAlignmentLeft;
    lineSeat_Label.textColor = zhangColor;
    [chooseSeat_View addSubview:lineSeat_Label];
    
    UIImageView * arrow_ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH - 15 - 8, 16, 8, 15)];
    arrow_ImageView.image = [UIImage imageNamed:@"more_icon"];
    [chooseSeat_View addSubview:arrow_ImageView];
    
    
    UIButton * chooseSeat_Btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, SWIDTH - 120 - 15, 47)];
    self.chooseSeat_Btn = chooseSeat_Btn;
    chooseSeat_Btn.backgroundColor = [UIColor clearColor];
    [chooseSeat_Btn setTitle:@"支持选座服务" forState:UIControlStateNormal];
    [chooseSeat_Btn setTitleColor:qiColor forState:UIControlStateNormal];
    chooseSeat_Btn.contentMode = UIViewContentModeLeft;
    chooseSeat_Btn.titleLabel.font = [UIFont mysystemFontOfSize:13];
    chooseSeat_Btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [chooseSeat_Btn addTarget:self action:@selector(clickChooseSeat) forControlEvents:UIControlEventTouchUpInside];
    [chooseSeat_View addSubview:chooseSeat_Btn];

    if (!self.selectedCustomer) {
        
        self.selectedCustomer = [NSMutableArray array];
    }
    _submitBtn.hidden = YES;
    
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SHEIGHT - 47 - 64, SWIDTH, 47)];
    _nextBtn.backgroundColor = BlueColor;
    [_nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn bringSubviewToFront:self.view];
    
    _shoujihao.delegate = self;
    _shoujihao.placeholder = @"请输入手机号";
    
    _shoujihao.returnKeyType = UIReturnKeyDone;
    _shoujihao.keyboardType = UIKeyboardTypeNumberPad;
    self.shengyuLab.layer.masksToBounds = YES;
    self.shengyuLab.layer.cornerRadius = 3;
    [self updateChengkeView];
    
      res = self.preObjvalue;
    
    if (self.is12306dingpiao) {
        self.title = @"12306订票";
        self.zuoweiView.hidden = YES;
        self.dibuView.hidden = YES;
        self.submitBtn.top = self.chengekexinxiView.bottom+30;
      
        if ([res.train_type isEqualToString:@"G"] || [res.train_type isEqualToString:@"C"] || [res.train_type isEqualToString:@"D"]) {
            //无座 座
            if ([self.buyedZuowei containsString:@"座"] && ![self.buyedZuowei isEqualToString:@"无座"]) {
                chooseSeat_View.hidden = NO;
            }
            else{
                chooseSeat_View.hidden = YES;
            }
        }
        else{
            chooseSeat_View.hidden = YES;
        }
        
    }
    else if (self.type == 0){
        self.title = @"任我行快捷出票";
        self.zuoweiView.hidden = YES;
        self.dibuView.hidden = YES;
        self.submitBtn.top = self.chengekexinxiView.bottom+30;
        if ([res.train_type isEqualToString:@"G"] || [res.train_type isEqualToString:@"C"] || [res.train_type isEqualToString:@"D"]) {
            if ([self.buyedZuowei containsString:@"座"]) {
                 chooseSeat_View.hidden = NO;
            }
            else{
                chooseSeat_View.hidden = YES;
            }
        }
        else{
            chooseSeat_View.hidden = YES;
        }
    }
    
    else if(self.isspsm){
        self.title = @"快递到家";
        self.zuoweiView.hidden = YES;
        self.dibuView.hidden = NO;
        self.dibuView.top = self.chengekexinxiView.bottom;
        self.submitBtn.top = self.chengekexinxiView.bottom+30;
        chooseSeat_View.hidden = YES;
        
    }else if(self.issirendingzhi){
        self.title  = @"选择座位";
        self.zuoweiView.top = self.chengekexinxiView.bottom;
        self.dibuView.top = self.zuoweiView.bottom;
        chooseSeat_View.hidden = YES;

    }
    
    //铁路保险
    [_baoxian_Btn setTitle:@"¥30.0/份" forState:UIControlStateNormal];
    [self.baoxian_Btn addTarget:self action:@selector(biaoXian) forControlEvents:UIControlEventTouchUpInside];
    
    if (![self.preObjvalue isKindOfClass:[CheCiRes class]]) {
        
        for (NSObject *obj in self.preObjvalue) {
            if ([obj isKindOfClass:[CheCiRes class]]) {
                
                res = self.preObjvalue;
                break;
            }
        }
    }
    
    
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
    self.zuoxi.text = self.buyedZuowei;
    CGFloat piaoj = [self getMaxPrice];
    if (piaoj<0) {
        piaoj = [self.buyedPrice floatValue];
    }
    if (self.is12306dingpiao) {
        
    }else{
        
        if (self.type == 0) {
            
        }
        else{
           self.buyedPrice = [NSString stringWithFormat:@"%.1f",piaoj]; 
        }
        
        
    }
    
    self.piaojia.text = [NSString stringWithFormat:@"¥%@",self.buyedPrice];
//    self.shoujihao.userInteractionEnabled = NO;
    
//    20170215
    NSMutableString *ss = [NSMutableString stringWithString:res.train_start_date];
    [ss insertString:@"-" atIndex:4];
    [ss insertString:@"-" atIndex:7];

    NSString *timestr = [NSString stringWithFormat:@"%@ %@:00",ss,res.start_time] ;
    
    NSMutableString *ss2 = [NSMutableString stringWithString:res.train_start_date];
    [ss2 insertString:@"年" atIndex:4];
    [ss2 insertString:@"月" atIndex:7];
    [ss2 insertString:@"日" atIndex:10];
    
    
    NSDate *date4 = [AppManager dateFromString:timestr  format:@"yyyy-MM-dd HH:mm:ss"];

    NSString *wek = [self showWeekOrDate:date4];
    
    NSString *fache =  [NSString stringWithFormat:@"%@ %@开(%@)",ss2,res.start_time,wek] ;
    self.facehtime.text = fache;
  
    NSDate *date1 = [AppManager dateFromString:timestr format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2 = [NSDate date];
    NSTimeInterval time=[date1 timeIntervalSinceDate:date2];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minite=(((int)time)%(3600*24)%3600)/60;

    NSString *dateContent = @"";
    
    if (days>0) {
        dateContent = [[NSString alloc] initWithFormat:@"剩余 %i天%i小时%i分",days,hours,minite];
    }else if(hours>=0 && minite>=0){
        dateContent = [[NSString alloc] initWithFormat:@"剩余 %i小时%i分",hours,minite];

    }
    self.shengyuLab.text = dateContent;
    [self.shengyuLab sizeToFit];
    self.shengyuLab.width+=10;
    self.shengyuLab.height+=8;

    
    [self updateChengkeView];
    
    
    [self getBaoxian];
    [self getShouhuo];
    
    
//    1 商务座    a c f (复选)    
//    2 一等座  ac df  (复选)    
//    3 二等座  abc df (复选)
//    4 普通座   连座 靠窗 (单选) 特等座  无座 软座
//    5 软卧      包间 下铺 (单选)
//    6 硬卧      至少12345张是下铺 (单选)
    if ([self.buyedZuowei containsString:@"商务座"]) {
        [self initZuoxiDingzhi:1];
    }else if ([self.buyedZuowei containsString:@"一等座"]) {
        [self initZuoxiDingzhi:2];
    }else if ([self.buyedZuowei containsString:@"二等座"]) {
        [self initZuoxiDingzhi:3];
    }else if ([self.buyedZuowei containsString:@"硬座"] || [self.buyedZuowei containsString:@"无座"]  || [self.buyedZuowei containsString:@"软座"]  || [self.buyedZuowei containsString:@"特等座"]) {
        [self initZuoxiDingzhi:4];
    }else if ([self.buyedZuowei containsString:@"软卧"]) {
        [self initZuoxiDingzhi:5];
    }else if ([self.buyedZuowei containsString:@"硬卧"]) {
        [self initZuoxiDingzhi:6];
    }
//    self.baoxianSW.userInteractionEnabled = NO;
    if (_isGaiqian) {
        self.title = @"改签车票确认";
        [_nextBtn setTitle:@"改签" forState:0];
        self.selectedCustomer = [NSMutableArray array];
        [self getChengKeXinxi];
    }
}

#pragma mark 在线选座位
- (void)clickChooseSeat{
    
    if (self.selectedCustomer.count <= 0) {
        [MBProgressHUD showHudWithString:@"请先选择乘客" model:MBProgressHUDModeCustomView];
        return;
    }
    else{
        ChooseSeatView * seatView = [[ChooseSeatView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
        [seatView getCustomerArray:self.selectedCustomer seatString:self.buyedZuowei];
        [[[UIApplication sharedApplication]keyWindow]addSubview:seatView];
        
        __weak typeof(self) weakSelf = self;
        seatView.chooseSeatBlock = ^(NSArray *seatArray, NSArray *tagArray) {
            weakSelf.seatTypeArray = seatArray;
            weakSelf.tagArray = tagArray;
            NSString * string = @"";
            NSString * numberString = @"";
            NSString * seatTypeString = @"";
            NSString * messageString = @"";
            for (NSString * seatString in seatArray) {
                numberString = [seatString substringWithRange:NSMakeRange(0, 1)];
                seatTypeString = [seatString substringWithRange:NSMakeRange(1, 1)];
                if ([numberString isEqualToString:@"1"]) {
                    messageString = [NSString stringWithFormat:@"前排%@,",seatTypeString];
                }
                else{
                    messageString = [NSString stringWithFormat:@"后排%@,",seatTypeString];
                }
                
                string = [string stringByAppendingString:messageString];
                
            }
            NSMutableString * stringMu = [NSMutableString stringWithFormat:@"%@", string];
            [stringMu deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
            [weakSelf.chooseSeat_Btn setTitle:[NSString stringWithFormat:@"%@",stringMu] forState:UIControlStateNormal];
        };
        
    }
}

#pragma mark 点击保险按钮
- (void)biaoXian{
    WXInsuranceController * insuranceVC = [[WXInsuranceController alloc]init];
    
    //快递到家 选择座位
    if ([self.title isEqualToString:@"快递到家"] || [self.title isEqualToString:@"选择座位"]) {
        insuranceVC.insurance_type = 3;
        
    }
    else if ([self.title isEqualToString:@"任我行快捷出票"] ||[self.title isEqualToString:@"12306订票"]){
        insuranceVC.insurance_type = 1;
    }
    else{
        
    }
    
    [insuranceVC setInsurance_block:^(NSString *price, NSIndexPath *index_last) {
        if ([price isEqualToString:@""]) {
            [_baoxian_Btn setTitle:@"不购买保险" forState:UIControlStateNormal];
            _biaoXianString = @"¥0";
            
        }
        else{
            [_baoxian_Btn setTitle:[NSString stringWithFormat:@"%@.0/份",price] forState:UIControlStateNormal];
            _biaoXianString = price;
        }
        _indexPath_insurance = index_last;
    }];
    insuranceVC.indexPath_new = _indexPath_insurance;
    [self.navigationController pushViewController:insuranceVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}
-(void)initZuoxiDingzhi:(NSInteger)type{
//    _zxddField
    UIView *sup = self.zxddField.superview;
    
    _zxddField.hidden = YES;
    UIView *bgv ;
    if (chooseZxView) {
        [chooseZxView removeAllSubviews];
    }else{
        bgv = [[UIView alloc]initWithFrame:sup.bounds];
        [sup addSubview:bgv];
        chooseZxView = bgv;

    }

    
    if (type==1) {
        NSArray *title = @[@"窗",@"A",@"C",@"过道",@"F",@"窗"];
        int cansel[] = {0,1,1,0,1,0};
        UIButton *lst;
        for (int i=0; i<title.count; i++) {
            UIButton *btn = [self zuoweibtnWithTitle:title[i] cansel:cansel[i]];
            btn.centerY = sup.height*0.5;
            
            btn.left = lst?lst.right:0;
            lst = btn;
            [bgv addSubview:btn];
            if (i==title.count-1) {
                bgv.width = btn.right;
                bgv.centerX = sup.centerX;
            }
        }
    }else if (type==2) {
        NSArray *title = @[@"窗",@"A",@"C",@"过道",@"D",@"F",@"窗"];
        int cansel[] = {0,1,1,0,1,1,0};
        UIButton *lst;
        for (int i=0; i<title.count; i++) {
            UIButton *btn = [self zuoweibtnWithTitle:title[i] cansel:cansel[i]];
            btn.centerY = sup.height*0.5;
            
            btn.left = lst?lst.right:0;
            lst = btn;
            [bgv addSubview:btn];
            if (i==title.count-1) {
                bgv.width = btn.right;
                bgv.centerX = sup.centerX;
            }
        }
    }else if (type==3) {
        NSArray *title = @[@"窗",@"A",@"B",@"C",@"过道",@"D",@"F",@"窗"];
        int cansel[] = {0,1,1,1,0,1,1,0};
        UIButton *lst;
        for (int i=0; i<title.count; i++) {
            UIButton *btn = [self zuoweibtnWithTitle:title[i] cansel:cansel[i]];
            btn.centerY = sup.height*0.5;
            
            btn.left = lst?lst.right:0;
            lst = btn;
            [bgv addSubview:btn];
            if (i==title.count-1) {
                bgv.width = btn.right;
                bgv.centerX = sup.centerX;
            }
        }
    }else if(type==4){
        UIButton *btn = [self zuoweibtnWithTitle:@"选择座位类型" cansel:NO];
        btn.width = SWIDTH-30;
        btn.left = 15;
        [bgv addSubview:btn];
        bgv.left = 0;
        btn.tag = 4;
        [btn addTarget:self action:@selector(chooseLeixing:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.centerY = bgv.height*0.5;
        
    }else if(type==5){
        UIButton *btn = [self zuoweibtnWithTitle:@"选择座位类型" cansel:NO];
        btn.width = SWIDTH-30;
        btn.left = 15;
        [bgv addSubview:btn];
        bgv.left = 0;
        btn.tag = 5;
        [btn addTarget:self action:@selector(chooseLeixing:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.centerY = bgv.height*0.5;
        
    }else if (type==6){
        UIButton *btn = [self zuoweibtnWithTitle:@"选择座位类型" cansel:NO];
        btn.width = SWIDTH-30;
        btn.left = 15;
        [bgv addSubview:btn];
        bgv.left = 0;
        btn.tag = 6;
        [btn addTarget:self action:@selector(chooseLeixing:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.centerY = bgv.height*0.5;
    }

}

#pragma mark 获取乘客信息
- (void)getChengKeXinxi{
    self.tjckbbjview.hidden = YES;
    NSDictionary *par = @{@"UToken":UToken,@"orderid":self.orderID};

    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:self.orderURL showLoading:NO showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue]==1) {
            NSArray *a = obj[@"data"][@"passengers"];
            [AppManager formatJsonStr:[obj mj_JSONString]];
            NSString *personID = [[NSUserDefaults standardUserDefaults]objectForKey:GaiQianKey];;
            NSMutableArray *result = [NSMutableArray array];
            for (int i=0; i<a.count; i++) {
                NSInteger idd = [a[i][@"passengerid"] integerValue];
                if (idd == [personID integerValue]) {
                    [result addObject:a[i]];
                }
            }
            self.selectedCustomer = [Customer mj_objectArrayWithKeyValuesArray:result];
            [self updateChengkeView];
        }
        [self.mainTableView reloadData];

    } andError:^(id error) {

    }];
}

-(void)chooseLeixing:(UIButton *)btn{
    CGRect frame = [btn.superview convertRect:btn.frame toView:self.scrollview];
    NSArray *a1 = @[@"优先连座",@"优先靠窗"];
    NSArray *a2 = @[@"优先包间",@"优先下铺"];
    
    NSArray *a3 = @[@"至少1张下铺",@"至少2张下铺",@"至少3张下铺",@"至少4张下铺",@"至少5张下铺"];
    NSArray *arr ;
    
    if (btn.tag == 4) {
        arr = a1;
        
    }
    if (btn.tag == 5) {
        arr = a2;
        
    }
    if (btn.tag == 6) {
        
        arr = a3;
        
    }
    if (!showL) {
        
        showL = [[ShowListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), SWIDTH, arr.count*40) dataSource1:arr ClickEvent:^(NSString *title, NSInteger index) {
            [btn setTitle:title forState:UIControlStateNormal];
            btn.selected = YES;
            showL = nil;
        } andPostName:nil];
        
        [self.scrollview addSubview:showL];
    }
    
}
-(UIButton *)zuoweibtnWithTitle:(NSString *)title cansel:(BOOL)cansele{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Font(15);
    
    if (cansele) {
        [btn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(zuoweibtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10;
    }else{
        
        [btn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    }
    
    return btn;
}
-(void)zuoweibtnAction:(UIButton *)btn{
    if ([self.buyedZuowei containsString:@"软卧"] || [self.buyedZuowei containsString:@"硬座"] || [self.buyedZuowei containsString:@"无座"]) {
        for (UIButton *b  in chooseZxView.subviews) {
            if ([b isKindOfClass:[UIButton class]]) {
                b.selected = NO;
            }
        }
        btn.selected = YES;
    }else
    btn.selected = !btn.selected;
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
                newStr = [SubmitOrderVc getWeekDayFordate:[date timeIntervalSince1970]];
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

-(void)getShouhuo{
    [_qupiaofangshi setTitle:@"快递到家" forState:UIControlStateNormal];
    if (!UToken) {
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            NSDictionary *infoDic = obj[@"data"];
            
            shouhuoInfo = [UserInfo mj_objectWithKeyValues:infoDic];
            if (shouhuoInfo.take_province) {
                _shoujianxixi.titleLabel.numberOfLines = 0;
                [_shoujianxixi setTitle:[NSString stringWithFormat:@"%@ %@ %@",shouhuoInfo.take_uname,shouhuoInfo.take_pcc,shouhuoInfo.take_address] forState:UIControlStateNormal];
                if (shouhuoInfo.take_phone.length==1&&[shouhuoInfo.take_phone isEqualToString:@"0"]) {
                    _shoujihao.text = @"";
                }else{
                    _shoujihao.text = shouhuoInfo.take_phone;
                }
//                _shoujihao.text = shouhuoInfo.take_phone;
            } 
        }
    } andError:nil];
}
-(void)getBaoxian{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/Insurance/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
         baoxianInfo = obj[@"data"];
        [self updateChengkeView];
    } andError:nil];
}

#pragma mark 更新界面
-(void)updateChengkeView{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = self.selectedCustomer.count*50 + 75;
        if (_isGaiqian) {
            height = self.selectedCustomer.count*50 + 25;
            self.cklistView.top = self.tjckbbjview.top;
            self.tjckbbjview.hidden = YES;
        }
        self.chengekexinxiView.height = height;
        self.chengekexinxiView.clipsToBounds = YES;
        
        NSInteger index= 100 ;
        for (Customer *cus in self.selectedCustomer) {
            UIView *view = [self.cklistView viewWithTag:index];
            UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH - 15 - 8, (view.height - 15) / 2, 8, 15)];
            arrowImageView.image = [UIImage imageNamed:@"more_icon"];
            [view addSubview:arrowImageView];
            UILabel *l1 = [view viewWithTag:10];
            l1.text = cus.name;
            UILabel *l2 = [view viewWithTag:11];
            l2.text = cus.type_name;
            UILabel *l3 = [view viewWithTag:12];
            l3.text = cus.id_number;
            if (_isGaiqian) {
                l1.text = cus.passengersename;
                l2.text = cus.piaotypename;
                l3.text = cus.passportseno;
                l1.left = 15;
                l2.left = l1.right;
                l3.left = l2.right;
                l3.width = SWIDTH- l3.left-15;
                UIButton *delete = [view viewWithTag:18];
                delete.hidden = YES;
            }
            
            index+=1;
        }
        
         self.chooseSeat_View.top = self.chengekexinxiView.bottom + 5;
        
         CGFloat hh = 0;
        //12306订票
        if (self.is12306dingpiao) {
           
            if ([res.train_type isEqualToString:@"G"] || [res.train_type isEqualToString:@"C"] || [res.train_type isEqualToString:@"D"]) {
                 hh = self.chooseSeat_View.bottom+30;
            }
            else{
                  hh = self.chengekexinxiView.bottom+30;
            }
  
        }
        //0是任行快捷出票
        else if(self.type == 0){
            if ([res.train_type isEqualToString:@"G"] || [res.train_type isEqualToString:@"C"] || [res.train_type isEqualToString:@"D"]) {
                hh = self.chooseSeat_View.bottom+30;
            }
            else{
                hh = self.chengekexinxiView.bottom+30;
            }
        }
        else if(self.isspsm){
            self.dibuView.top = self.chengekexinxiView.bottom;
            hh = self.dibuView.bottom;

        }else if(self.issirendingzhi){
            self.zuoweiView.top = self.chengekexinxiView.bottom;
            self.dibuView.top = self.zuoweiView.bottom;
            hh = self.dibuView.bottom;

        }
        
//        CGFloat hh =  self.submitBtn.bottom+30;
        
//        if (hh <= self.scrollview.height) {
//            hh = self.scrollview.height+1;
//        }
        self.scrollview.contentSize = CGSizeMake(SWIDTH,hh);
        
    } completion:nil];

//    CGFloat money = [self.buyedPrice floatValue]*100;
    CGFloat singleIns = 0.0;
    
    if (baoxianInfo) {
        for (NSDictionary *ins in baoxianInfo) {
            if (ins[@"insurance_type"] && [ins[@"insurance_type"] integerValue]==3) {
//                CGFloat min = [ins[@"min_val"] floatValue];
//                CGFloat max = [ins[@"max_val"] floatValue];
//                if (money<max && money>min) {
                    singleIns = [ins[@"money"] floatValue];
//                    break;
//                }
            }
        }      
        
    }
    
    if (_isGaiqian) {
        _submitBtn.top = self.chengekexinxiView.bottom+30;
    }
        
}


#pragma mark 删除乘客
- (IBAction)deleteck:(UIButton *)sender {
    NSInteger index = sender.superview.tag - 100;
    if (index<self.selectedCustomer.count) {
        [self.selectedCustomer removeObjectAtIndex:index];
        
        [_chooseSeat_Btn setTitle:@"支持选座服务" forState:UIControlStateNormal];
        
        
        [self updateChengkeView];
    }
}

#pragma mark 点击添加乘客
- (void)tjckAction:(UIButton *)sender {
    [_chooseSeat_Btn setTitle:@"支持选座服务" forState:UIControlStateNormal];
    if (!UToken) {
        UITabBarController *vc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        BaseViewController *vcv = (BaseViewController *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
        UINavigationController *nav = vc.selectedViewController;
        vcv.preObjvalue = @"tokenwrong";
        [nav pushViewController:vcv animated:YES];
        return;
    }
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isrxlogin"];
    
    if (!self.is12306dingpiao && !isLogin) {
        
        BaseViewController *vcv = (BaseViewController *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
        
        vcv.preObjvalue = @"SubmitOrder";
        PUSH(vcv);
        return;
    }
    if (self.selectedCustomer.count >= 5) {
        [MBProgressHUD showHudWithString:@"最多只能添加5位乘客" model:MBProgressHUDModeCustomView];
        return;
    }
    
    NSString *value = @"";
    for (Customer *cus in self.selectedCustomer) {
        value = [value stringByAppendingString:[NSString stringWithFormat:@",%@",cus.id_number]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:SelectCKKey];;

    ChoosePerson *vc = (ChoosePerson *)[self getVCInBoard:nil ID:@"ChoosePerson"];
    vc.customerArray = self.selectedCustomer;
    vc.preObjvalue = self.selectedCustomer;
    vc.ischoose12306 = self.is12306dingpiao;
    __weak typeof(self) weakSelf = self;
    vc.touchEvent = ^(id value){
        if ([value isKindOfClass:[NSArray class]]) {
//            self.selectedCustomer = value;
            [self.selectedCustomer removeAllObjects];
            [self.selectedCustomer addObjectsFromArray:value];
            [weakSelf updateChengkeView];

        }  
    };
    PUSH(vc);
}

#pragma mark 添加儿童乘客
- (void)ClickWithaddChildren{
    [_chooseSeat_Btn setTitle:@"支持选座服务" forState:UIControlStateNormal];
    if (_selectedCustomer.count >=5) {
        [MBProgressHUD showHudWithString:@"最多只能添加5位乘客" model:MBProgressHUDModeCustomView];
        return;
    }
    
    if (_selectedCustomer.count == 0) {
         [MBProgressHUD showHudWithString:@"请您先选择成人的信息!" model:MBProgressHUDModeCustomView];
    }
    else{
        Customer * cus = _selectedCustomer[0];
        Customer * cusNew = [cus copy];
        NSMutableArray * customerArray = [NSMutableArray array];
        cusNew.personType = [NSString stringWithFormat:@"1"];
        cusNew.type_name = @"儿童";
        cusNew.name = cus.name;
        cusNew.id_number = cus.id_number;
        cusNew.id_name = @"身份证";
        cusNew.id_type = cus.id_type;
        cusNew.passengerid = [NSString stringWithFormat:@"%u",100 +  (arc4random() % 101)];
        cusNew.piaotype = @"2";
        cusNew.person_id = [NSString stringWithFormat:@"%u",100 +  (arc4random() % 101)];
        [customerArray addObject:cusNew];
        [_selectedCustomer addObject:customerArray[0]];
        
        
        [self updateChengkeView];
    }
    
}


-(CGFloat)getMaxPrice{
    
    NSString *maxStr = @"";
    if ([self.buyedZuowei containsString:@"硬卧"]) {
        maxStr = @"ywx_price";
    }else if ([self.buyedZuowei containsString:@"高级软卧"]) {
        maxStr = @"gjrw_price";
        
    }else if ([self.buyedZuowei containsString:@"软卧"]) {
        maxStr = @"rwx_price";
    }else {
        maxStr = self.buyedZuoweiCode;
    }
    CGFloat maxP = 0;
    maxP = [[[res mj_keyValues] objectForKey:maxStr] floatValue];
    
    return maxP;
    
    
}


#pragma mark - 点击提交订单
- (void)submitAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    if (_isGaiqian) {//改签
        sender.userInteractionEnabled = YES;
    }
    if (self.selectedCustomer.count<1) {
        [MBProgressHUD showHudWithString:@"请先选择乘客" model:MBProgressHUDModeCustomView];
        sender.userInteractionEnabled = YES;
        return;
    } 

    BOOL isrxlogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isrxlogin"];
    
    if (!isrxlogin) {
        
        BaseViewController *vcv = (BaseViewController *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
        
        vcv.preObjvalue = @"SubmitOrder";
        PUSH(vcv);
        return;
    }
    
    
    if (self.issirendingzhi && self.shoujihao.text.length<5) {
        [MBProgressHUD showHudWithString:@"请填写手机号" model:MBProgressHUDModeCustomView];
        sender.userInteractionEnabled = YES;
        return;
    }
    
    CheCiRes *checi = res;
    
    if (!checi) {
        sender.userInteractionEnabled = YES;
        return;
    }
    
    NSMutableArray * piaoTypeLineArray = [NSMutableArray array];
    for (Customer *cus in self.selectedCustomer){
        if ([cus.piaotype intValue] == 2) {
            [piaoTypeLineArray addObject:cus.piaotype];
        }
    }
    if (piaoTypeLineArray.count == _selectedCustomer.count) {
        [MBProgressHUD showHudWithString:@"儿童票不能单独购买" model:MBProgressHUDModeCustomView];
        sender.userInteractionEnabled = YES;
        return;
    }

    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[@"UToken"] = UToken;
    par[@"checi"] = checi.train_code;
    par[@"from_station_code"] = checi.from_station_code;
    par[@"from_station_name"] = checi.from_station_name;
    par[@"to_station_code"] = checi.to_station_code;
    par[@"to_station_name"] = checi.to_station_name;
   
    par[@"runtime"] = checi.run_time;
    par[@"is_accept_standing"] = @0 ;
    
    if ([self.buyedZuowei isEqualToString:@"无座"]) {
        par[@"is_accept_standing"] = @1 ;
        
    }
    NSMutableString *ss = [NSMutableString stringWithString:res.train_start_date];
    [ss insertString:@"-" atIndex:4];
    [ss insertString:@"-" atIndex:7];
    
    par[@"train_date"] = ss;
    par[@"start_time"] = [NSString stringWithFormat:@"%@ %@:00" ,ss,checi.start_time];
    
    par[@"arrive_time"] = [NSString stringWithFormat:@"%@ %@:00" ,ss,checi.arrive_time];
    
    NSString *postUrl = @"Action/createBuyTicketOnline/";
    
    //12306订票 任行出票
    if (self.is12306dingpiao || self.type == 0) {
        if (self.seatTypeArray.count <= 0) {
            par[@"is_choose_seats"] = @"false";
            par[@"choose_seats"] = @"";
        }
        else{
            par[@"is_choose_seats"] = @"true";
            NSString * seat = @"";
            for (NSString * seatString in self.seatTypeArray) {
                seat = [seat stringByAppendingString:seatString];
            }
            par[@"choose_seats"] = seat;
        }
        if (self.is12306dingpiao) {
            NSString *LoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
            NSString *LoginUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
            
            par[@"LoginUserName"] = LoginUserName;
            par[@"LoginUserPassword"] = LoginUserPassword;
        }
        else{
            postUrl = @"Action/createBuyTicketOnlineTwo/";
            par[@"LoginUserName"] = @"";
            par[@"LoginUserPassword"] = @"";
           
        }
        
        NSMutableArray *passengers = [NSMutableArray array];
        //        坐席类型CODE,9:商务座，P:特等座，M:一等座，O:二等座，6:高级软卧，4:软卧，3:硬卧，2:软座，1:硬座
        //        票类型;1:成人票，2:儿童票，3:学生票，4:残军票
        NSString *zwcode = [self zuoweiCodeWithName:self.buyedZuowei];
       
        for (Customer *cus in self.selectedCustomer) {
            NSDictionary *passeng;
            if (_isGaiqian) {
            passeng=@{@"passengersename":cus.passengersename,@"passportseno":cus.passportseno,@"passporttypeseidname":cus.passporttypeseidname,@"passporttypeseid":cus.passporttypeseid,@"passengerid":cus.passengersid,@"zwname":self.buyedZuowei,@"zwcode":zwcode,@"price":self.buyedPrice,@"piaotype":cus.piaotype,@"cxin":@""};
                
            }
            else{
                
                NSDictionary *dic = @{@"1":@"身份证",@"2":@"港澳通行证",@"3":@"台湾通行证",@"4":@"护照"};
                NSString *key = [NSString stringWithFormat:@"%ld",(long)cus.id_type];
                NSString *value = dic[key];
                if (value.length==0) {
                    value = @"";
                    
                }
                
            passeng= @{@"passengersename":cus.name,@"passportseno":cus.id_number,@"passporttypeseidname":value,@"passporttypeseid":@(cus.id_type),@"passengerid":cus.passengerid,@"zwname":self.buyedZuowei,@"zwcode":zwcode,@"price":self.buyedPrice,@"piaotype":cus.piaotype,@"cxin":@""};
            }
            
            [passengers addObject:passeng];
        }
        par[@"passengers"] = passengers;

    }else {
//快递到家的接口
        //Action/createBuyTicketOffline/
        postUrl = @"Action/createBuyTicketOffline_test/";
        
        
        NSMutableString *dingzhiStr = [NSMutableString string];
        
        for (UIButton *btn in chooseZxView.subviews) {
            if (btn.selected) {
                [dingzhiStr appendString:[NSString stringWithFormat:@"%@,",btn.currentTitle]];
            }
        }
        NSLog(@"%@",dingzhiStr);
        if (dingzhiStr.length<1) {
            [dingzhiStr appendString:_zxddField.text];
        }
        par[@"prompt_message"] = dingzhiStr;

        
        
        par[@"take_phone"] = _shoujihao.text;
        
        par[@"sendtype"] = @"2";
        NSInteger sendtype = 2;
        if ([_qupiaofangshi.currentTitle isEqualToString:@"快递到家"]) {
            par[@"sendtype"] = @"1";
            sendtype = 1;
            
        }
            if (!shouhuoInfo) {
                [MBProgressHUD showHudWithString:@"请选择收件信息" model:MBProgressHUDModeCustomView];
                return;
            }
            par[@"take_uname"] =shouhuoInfo.take_uname;
            par[@"take_province"] = shouhuoInfo.take_province;
            par[@"take_city"] = shouhuoInfo.take_city;
            par[@"take_county"] = shouhuoInfo.take_county;
            par[@"take_address"] = shouhuoInfo.take_address;
        
        CGFloat maxP = [self getMaxPrice];
        
        par[@"max_price"] = @(maxP);

        //乘客信息
        NSMutableArray *passengers = [NSMutableArray array];
        for (Customer *cus in self.selectedCustomer) {
            NSString *zwcode = [self zuoweiCodeWithName:self.buyedZuowei];
            
            NSDictionary *passeng = @{@"passengersename":cus.name,@"passportseno":cus.id_number?cus.id_number:@"",@"passporttypeseidname":cus.id_name?cus.id_name:@"身份证",@"passporttypeseid":@(cus.id_type),@"passengerid":cus.passengerid,@"piaotype":cus.piaotype,@"cxin":@"",@"zwcode":zwcode};
            [passengers addObject:passeng];
        }
        
        par[@"passengers"] = passengers;
        NSArray * biaoxianArray = [_biaoXianString componentsSeparatedByString:@"¥"];
        par[@"insurance"] =@([biaoxianArray[1] floatValue] * 100);
        CGFloat moneryBiaoXian =[biaoxianArray[1] integerValue] * passengers.count;
        par[@"all_insurance"] = @([[NSString stringWithFormat:@"%f",moneryBiaoXian] floatValue] * 100);
        
    }
    
    [MBProgressHUD showHudWithString:@"加载中"];
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:postUrl showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj)
    {
         [MBProgressHUD hideHud];
        NSString * msg = obj[@"msg"];
            if ([obj[@"code"] integerValue] == 1) {
               
                NSString *orderid = obj[@"data"][@"orderid"];
                
                OrderDetailAndPay *vc = (OrderDetailAndPay *)[self getVCInBoard:nil ID:@"OrderDetailAndPay"];
                
                if (self.is12306dingpiao) {
                    vc.type = 1;
                }
                else{
                    vc.type = 0;
                }
                
                vc.orderid = orderid;
                vc.url = self.is12306dingpiao?@"Action/buyRowOnline/":@"Action/buyRowOffline/";
                if (self.type == 0) {
                    vc.url = @"Action/buyRowOnline/";
                }
                vc.tuipiaoUrl = self.is12306dingpiao?@"Action/buyOnlineReturn/":@"Action/buyOfflineReturn/";
                if (self.type == 0) {
                    vc.tuipiaoUrl = @"Action/buyOnlineReturn/";
                }
                PUSH(vc);
                
            }
            else{
                [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
            }
        
        sender.userInteractionEnabled = YES;
        } andError:^(id error) {
            NSLog(@"%@error",error);
             [MBProgressHUD hideHud];
           [MBProgressHUD showHudWithString:@"加载失败,请稍后重试!" model:MBProgressHUDModeCustomView];
            sender.userInteractionEnabled = YES;
        }];
}

-(NSString *)zuoweiCodeWithName:(NSString *)name{
    //        坐席类型CODE,9:商务座，P:特等座，M:一等座，O:二等座，6:高级软卧，4:软卧，3:硬卧，2:软座，1:硬座

        NSString *code = @"";
    if ([name isEqualToString:@"商务座"]) {
        code = @"9";
    }else if ([name isEqualToString:@"特等座"]) {
        code = @"P";
    }else if ([name isEqualToString:@"一等座"]) {
        code = @"M";
    }else if ([name isEqualToString:@"二等座"]) {
        code = @"O";
    }else if ([name isEqualToString:@"高级软卧"]) {
        code = @"6";
    }else if ([name isEqualToString:@"软卧"]) {
        code = @"4";
    }else if ([name isEqualToString:@"硬卧"]) {
        code = @"3";
    }else if ([name isEqualToString:@"软座"]) {
        code = @"2";
    }else if ([name isEqualToString:@"硬座"]) {
        code = @"1";
    }else if ([name isEqualToString:@"无座"]) {
        code = @"1";
    }
    return code;
}

#pragma mark 取票方式
- (IBAction)qupiao:(UIButton *)sender {
    NSArray *arr = @[@"快递到家",@"火车站配送"];
    CBAlertView *view = [[CBAlertView alloc]initWithTitle:@"请选取取票方式" actionsTitles:arr imgnames:nil showCancel:YES showSure:NO event:^(id value) {
        [sender setTitle:arr[[value integerValue]] forState:UIControlStateNormal];
//        NSString *sss = arr[[value integerValue]];
//
//        if ([sss isEqualToString:@"火车站配送"]) {
//            [self.shoujianxixi setTitle:res.from_station_name forState:UIControlStateNormal];
//            
//        }else{
//            
            
            [_shoujianxixi setTitle:[NSString stringWithFormat:@"%@ %@ %@",shouhuoInfo.take_uname,shouhuoInfo.take_pcc,shouhuoInfo.take_address] forState:UIControlStateNormal];
//        if (shouhuoInfo.take_phone.length==1&&[shouhuoInfo.take_phone isEqualToString:@"0"]) {
//            _shoujihao.text = @"";
//        }else{
//            _shoujihao.text = shouhuoInfo.take_phone;
//        }
//            _shoujihao.text = shouhuoInfo.take_phone;

//        }
        
    }];
}

#pragma mark 收件信息
- (IBAction)shoujianact:(UIButton *)sender {
    ChangyongPsvc *vc = (ChangyongPsvc *)[self getVCInBoard:@"Main" ID:@"ChangyongPsvc"];
    vc.isfromChoose = YES;
    
    vc.touchEvent = ^(UserInfo *info){
        shouhuoInfo = info;
        _shoujianxixi.titleLabel.numberOfLines = 0;
        [_shoujianxixi setTitle:[NSString stringWithFormat:@"%@ %@ %@",shouhuoInfo.take_uname,shouhuoInfo.take_pcc,shouhuoInfo.take_address] forState:UIControlStateNormal];
        if (shouhuoInfo.take_phone.length==1&&[shouhuoInfo.take_phone isEqualToString:@"0"]) {
            _shoujihao.text = @"";
        }else{
            _shoujihao.text = shouhuoInfo.take_phone;
        }
//        _shoujihao.text = shouhuoInfo.take_phone;

        
    };
    PUSH(vc);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.seatView.hidden = YES;
}

#pragma mark 去掉导航栏下面的黑线
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)clickXuZhi:(UIButton *)button{
    BookingDetailsViewController * bookingDetailsVC = [[BookingDetailsViewController alloc]init];
    [self.navigationController pushViewController:bookingDetailsVC animated:YES];
}

#pragma mark 返回按钮的事件
- (BOOL)navigationShouldPopOnBackButton{
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"" message:@"订单就要完成了,您确定要离开吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"继续填写" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:actionCancle];
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self back];
    }];
    [alertView addAction:actionOK];
    [self presentViewController:alertView animated:YES completion:nil];
    return NO;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
