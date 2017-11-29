//
//  DZXZVc.m
//  CommonProject
//
//  Created by gaoguangxiao on 2017/1/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DZXZVc.h"
#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "SearchResVc.h"
#import "ChooseDateViewController.h"
#import "ChooseSeatTypeVc.h"
#import "PayView.h"
#import "SubmitOrderVc.h"
#import "ChoosePerson.h"
#import "CBAlertView.h"
#import "ChangyongPsvc.h"
#import "OrderDetailAndPay.h"

#import "VIPTableViewController.h"

#import "WXInsuranceController.h"

/**
 *   订票须知
 */
#import "BookingDetailsViewController.h"


@interface DZXZVc ()<UITextFieldDelegate>
{
    TrainStation *chufadiSt;
    TrainStation *mudidiSt;
NSArray *baoxianInfo;
    NSMutableArray <Customer *>*selectedCustomer;
    NSMutableArray <DateObject *>*selectedDate;
    NSMutableArray <SeatType *>*selectedType;

    NSMutableArray *selectedCheci;

    NSString *train_date;
    UIView *qpxinxi ;//抢票信息模块
    UIView *psxinxi;//配送信息模块
    PayView *payView ;
    
    
    UserInfo *shouhuoInfo;
    
    //人工
    UITextField *shoujihao;
    UILabel *zuigaopiaojia;
    
    //12306的
    UIButton *qupiaofangshi;
    UIButton *shoujianxinxi;
    UIButton *baoxianButton;
    CGFloat baoxianPrice;
    NSIndexPath *_indexPath;
    NSIndexPath *_indexPath_insurance;
    NSString    *_surePrice;
    NSString    *_moneyString;
    
    
}
@property (nonatomic,assign)BOOL issingle;//是否是单选

@property(nonatomic,strong)UIView * speed_12306;

@property(nonatomic,strong)UIButton * nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgScrollowTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgScrollowBottom;
@property(nonatomic,strong)UIButton * speed_Btn;

@property (strong, nonatomic) IBOutlet UIButton *addChildren_BTN;
@end


@implementation DZXZVc


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _surePrice = @"¥30";
    _moneyString = @"30";
    self.bgScView.frame = CGRectMake(0, 0, SWIDTH, SHEIGHT - 47 - 64 - 300);


    //立即下单按钮
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SHEIGHT - 47 - 64, SWIDTH, 47)];
    _nextBtn.backgroundColor = BlueColor;
    [_nextBtn setTitle:@"立即下单" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_nextBtn];
    [_nextBtn bringSubviewToFront:self.view];

    selectedCustomer = [NSMutableArray array];
    selectedDate = [NSMutableArray array];
    selectedCheci = [NSMutableArray array];
    selectedType = [NSMutableArray array];
    
    
    UIButton * right_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [right_Btn setTitle:@"订票须知" forState:UIControlStateNormal];
    right_Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right_Btn.titleLabel.font = [UIFont mysystemFontOfSize:14];
    [right_Btn addTarget:self action:@selector(clickXuZhi:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right_Btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.leixing setTitle:self.buyedZuowei forState:UIControlStateNormal];
    
    
    //点击添加儿童按钮
    [self.addChildren_BTN addTarget:self action:@selector(ClickWithaddChildren) forControlEvents:UIControlEventTouchUpInside];
     [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectCKKey];;
    
    if (self.from == 1 || self.from==2 || self.from==3) {
        self.title = self.preObjvalue;
        self.issingle = YES;
    }
    if (self.from==4) {
        self.title = @"12306抢票";
    }else if (self.from == 5){
        self.title = @"人工抢票";
        self.issingle = NO;
        
    }
  
    //初始化公用视图和数据
    [self initCommonData];
    
    //初始化上个界面所选择的车次信息
    //说明是从查询某一趟车的结果页面过来的，进入添加抢票页面时，需要把所选的车次信息填入
    if ([self.preObjvalue isKindOfClass:[CheCiRes class]]) {
        CheCiRes *result = self.preObjvalue;
        
        [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.szm isEqualToString:result.from_station_code]) {
                chufadiSt = obj;
            } 
            if ([obj.szm isEqualToString:result.to_station_code]) {
                mudidiSt = obj;
            } 
        }];
        [self setStaionTtile];
        DateObject *date = [[DateObject alloc]init];
//时间
        if (result.train_start_date.length == 8) {
            NSMutableString *s = [NSMutableString stringWithString:result.train_start_date];
            [s insertString:@"-" atIndex:4];
            [s insertString:@"-" atIndex:7];
            
            date.showStr = s;
            date.originalStr = s;
        }
        [selectedDate addObject:date];
        [selectedCheci addObject:result];
    }
    //座位类型
    if (self.buyedZuowei) {
        SeatType *yy = [[SeatType alloc]init];
        yy.name = self.buyedZuowei;
        yy.type_name = self.buyedZuoweiCode;
        [selectedType addObject:yy];
    }
    [self showSeattype];
    [self showDate];
    [self showCheci];
    //1 2 3 坐席定制的三个   为这三个时里面的为单选  4 12306的抢票  5人工的抢票
    //   6快递到家   7私人订制
    
    

    if (self.from==4) {
        [self creatSpeed];
        [self init12306QP];
    }else if (self.from ==  5){
        [self creatSpeed];
        [self initRGQP];
    }else if (self.from ==  6){
//        [self initRGQP];
        self.issingle = YES;

        self.navigationItem.title = @"快递到家";

    }else if (self.from ==  7){
//        [self initRGQP];
        self.issingle = YES;
        self.navigationItem.title = @"私人订制";
    }
   
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectRiqiKey];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectCheCiKey];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectZXKey];

    if (self.issingle) {
        self.riqiBtn.userInteractionEnabled = YES;
        if (![self.preObjvalue isKindOfClass:[CheCiRes class]]) {
            
            [self.riqiBtn setTitle:[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"] forState:UIControlStateNormal];
            NSString *title = [NSString stringWithFormat:@"%@,",[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"]];
             [[NSUserDefaults standardUserDefaults]setObject:title forKey:SelectRiqiKey];

             DateObject *date = [[DateObject alloc]init];
            date.originalStr = title;
            [selectedDate addObject:date];
        }
        
        [self.duoxuanBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            btn.hidden = YES;     
        }];
    }else{
    }

    [self getBaoxian];
    [self getShouhuo];
    _chengkeView.hidden = YES;
    
     [self updateChengkeView];


}

- (void)creatSpeed{
    UIView * speed_12306 = [[UIView alloc]initWithFrame:CGRectMake(0, self.chengkeView.bottom, SWIDTH, 47)];
    [self.bgScView addSubview:speed_12306];
    UIView *line_View = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SWIDTH - 15, 1)];
    line_View.backgroundColor = E5Color;
    [speed_12306 addSubview:line_View];
    
    speed_12306.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3.5, 36, 40)];
    //    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"jiasu_icon"];
    imageView.contentMode = UIViewContentModeRight;
    [speed_12306 addSubview:imageView];
    
    UILabel * speed_Label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, 0, 80, 47)];
    speed_Label.text = @"抢票速度";
    speed_Label.font = [UIFont mysystemFontOfSize:13];
    speed_Label.textAlignment = NSTextAlignmentLeft;
    speed_Label.textColor = qiColor;
    [speed_12306 addSubview:speed_Label];
    
    UIButton * speed_Btn = [[UIButton alloc]initWithFrame:CGRectMake(speed_Label.right + 15, 0, SWIDTH - (speed_Label.right + 15) - 8 - 15 , 47)];
    //    speed_Btn.backgroundColor = [UIColor redColor];
    [speed_Btn setTitle:@"急速抢票" forState:UIControlStateNormal];
    [speed_Btn setTitleColor:zhangColor forState:UIControlStateNormal];
    speed_Btn.titleLabel.font = [UIFont mysystemFontOfSize:15];
    [speed_Btn addTarget:self action:@selector(clickVip) forControlEvents:UIControlEventTouchUpInside];
    self.speed_Btn = speed_Btn;
    [speed_12306 addSubview:speed_Btn];
    
    UIImageView * more_ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(speed_Btn.right, 16, 8, 15)];
    more_ImageView.image = [UIImage imageNamed:@"more_icon"];
    [speed_12306 addSubview:more_ImageView];
    
    
    
    UIImageView * arrow_ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH - 42, 0, 27, 47)];
    imageView.contentMode = UIViewContentModeRight;
    [speed_12306 addSubview:arrow_ImageView];
    
    self.speed_12306 = speed_12306;
}

-(void)getBaoxian{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/Insurance/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        baoxianInfo = obj[@"data"];
    } andError:nil];
}
-(void)getShouhuo{
    if (!UToken) {
        
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userInfo/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            NSDictionary *infoDic = obj[@"data"];
           
            shouhuoInfo = [UserInfo mj_objectWithKeyValues:infoDic];
            if (!shouhuoInfo) {
                [shoujianxinxi setTitle:@"请点击设置收货信息" forState:UIControlStateNormal];
            }
            if (shouhuoInfo.take_province) {
               
                    NSString *str = [NSString stringWithFormat:@"%@ %@ %@",shouhuoInfo.take_uname,shouhuoInfo.take_pcc,shouhuoInfo.take_address];
                    [shoujianxinxi setTitle:str forState:UIControlStateNormal];
                if (!shouhuoInfo) {
                    [shoujianxinxi setTitle:@"请点击设置收货信息" forState:UIControlStateNormal];
                }else{
                    if (shouhuoInfo.take_phone.length==1&&[shouhuoInfo.take_phone isEqualToString:@"0"]) {
                        shoujihao.text = @"";
                    }else{
                  shoujihao.text = shouhuoInfo.take_phone;
                    }

                }
                
            } 
        }else{
            if (!shouhuoInfo) {
                [shoujianxinxi setTitle:@"请点击设置收货信息" forState:UIControlStateNormal];
            }
        }
    } andError:nil];
}
-(void)initCommonData{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initStation];
    
    [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"北京"]) {
            chufadiSt = obj;
        } 
        if ([obj.name isEqualToString:@"上海"]) {
            mudidiSt = obj;
        } 
    }];
    [_nextBtn setTitle:@"下一步(选座)" forState:UIControlStateNormal];
    
    [self setStaionTtile];
    self.chengkeView.height = 0;
    [self updateChengkeView];
    //添加12306抢票任务 == 4 || 添加人工抢票任务 == 5
    if (self.from == 4 || self.from == 5) {
        
//        [self initPayView];
        [_nextBtn setTitle:@"立即下单" forState:UIControlStateNormal];
        
        [_nextBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];

    }
}
#pragma mark - 12306抢票
-(void)init12306QP{
    qpxinxi = [[NSBundle mainBundle] loadNibNamed:@"qiangpiaoxinxi" owner:self options:nil].firstObject;
    qpxinxi.frame = CGRectMake(0, self.speed_12306.bottom, SWIDTH, 180);

    [self.bgScView addSubview:qpxinxi];
    shoujihao = [qpxinxi viewWithTag:1];
    shoujihao.delegate = self;
    shoujihao.returnKeyType = UIReturnKeyDone;
    shoujihao.placeholder = @"请输入手机号";

    shoujihao.keyboardType = UIKeyboardTypeNumberPad;

    zuigaopiaojia = [qpxinxi viewWithTag:2];
    baoxianButton = [[qpxinxi viewWithTag:109] viewWithTag:103];
    [baoxianButton addTarget:self action:@selector(clickBaoXian) forControlEvents:UIControlEventTouchUpInside];
    zuigaopiaojia.text = [NSString stringWithFormat:@"¥%.1f",[self.buyedPrice floatValue]];
    zuigaopiaojia.textColor = [UIColor redColor];
    
    //右边的箭头
    [self creatArrowtag:105 withView:qpxinxi];
    [self creatArrowtag:106 withView:qpxinxi];
    [self creatArrowtag:109 withView:qpxinxi];

    NSDictionary *dicc =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    UserInfo *info = [UserInfo mj_objectWithKeyValues:dicc];
    if (info.phone.length==1&&[info.phone isEqualToString:@"0"]) {
        shoujihao.text = @"";
    }else{
        shoujihao.text = info.phone;
    }
}

#pragma mark 右边的箭头
- (void)creatArrowtag:(NSInteger)number withView:(UIView *)viewTotal{
    UIView * viewBg = [viewTotal viewWithTag:number];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH - 15 - 8, (viewBg.height - 15) / 2, 8 , 15)];
    imageView.image = [UIImage imageNamed:@"more_icon"];
    [viewBg addSubview:imageView];
}

#pragma mark 点击保险
- (void)clickBaoXian {
    WXInsuranceController * insuranceVC = [[WXInsuranceController alloc]init];
    
    //快递到家 选择座位
    if ([self.title isEqualToString:@"人工抢票"] ) {
        insuranceVC.insurance_type = 4;
        
    }
    else if ([self.title isEqualToString:@"12306抢票"] ||[self.title isEqualToString:@"12306订票"]){
        insuranceVC.insurance_type = 2;
    }
    else{
       
    }
    
    [insuranceVC setInsurance_block:^(NSString *price, NSIndexPath *index_last) {
        if ([price isEqualToString:@""]) {
            [baoxianButton setTitle:@"不购买保险" forState:UIControlStateNormal];
            _surePrice = @"¥0";
            
        }
        else{
            [baoxianButton setTitle:[NSString stringWithFormat:@"%@.0/份",price] forState:UIControlStateNormal];
            _surePrice = price;
        }
        _indexPath_insurance = index_last;
    }];
    insuranceVC.indexPath_new = _indexPath_insurance;
    [self.navigationController pushViewController:insuranceVC animated:YES];
}

#pragma mark 点击VIP
- (void)clickVip{
    VIPTableViewController * vipVC = [[VIPTableViewController alloc]init];
    NSCharacterSet * nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    vipVC.vipBlock = ^(NSString *vipName, NSIndexPath *index_VipLast, NSString *money) {
        [_speed_Btn setTitle:vipName forState:UIControlStateNormal];
       _indexPath = index_VipLast;
        if (![money isEqualToString:@""]) {
            _moneyString = [money stringByTrimmingCharactersInSet:nonDigits];
        }
        else{
            _moneyString = @"0";
        }
        
    };
    vipVC.indexPath_Vip = _indexPath;
    [self.navigationController pushViewController:vipVC animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}
#pragma mark - 人工抢票
-(void)initRGQP{
    
    qpxinxi = [[NSBundle mainBundle] loadNibNamed:@"qiangpiaoxinxi" owner:self options:nil].firstObject ;
    qpxinxi.frame = CGRectMake(0, self.tjck.bottom, SWIDTH, 190);
    [self.bgScView addSubview:qpxinxi];
    shoujihao = [qpxinxi viewWithTag:1];
    shoujihao.delegate = self;
    shoujihao.returnKeyType = UIReturnKeyDone;
    shoujihao.placeholder = @"请输入手机号";
    shoujihao.keyboardType = UIKeyboardTypeNumberPad;

    zuigaopiaojia = [qpxinxi viewWithTag:2];
    baoxianButton = [[qpxinxi viewWithTag:109] viewWithTag:103];
    
    //右边的箭头
    [self creatArrowtag:105 withView:qpxinxi];
    [self creatArrowtag:106 withView:qpxinxi];
    [self creatArrowtag:109 withView:qpxinxi];
    
    [baoxianButton addTarget:self action:@selector(clickBaoXian) forControlEvents:UIControlEventTouchUpInside];

    psxinxi = [[NSBundle mainBundle] loadNibNamed:@"qiangpiaoxinxi" owner:self options:nil].lastObject;
    psxinxi.frame = CGRectMake(0, qpxinxi.bottom, SWIDTH, 120);
    [self.bgScView addSubview:psxinxi];
    
    [self creatArrowtag:110 withView:psxinxi];
    [self creatArrowtag:111 withView:psxinxi];
    
    zuigaopiaojia.text = [NSString stringWithFormat:@"¥%.1f",[self.buyedPrice floatValue]];
    zuigaopiaojia.textColor = [UIColor redColor];
    
    qupiaofangshi = [psxinxi viewWithTag:101];
    shoujianxinxi = [psxinxi viewWithTag:202];
    UILabel * addressLabel = [psxinxi viewWithTag:301];
    shoujianxinxi.size = CGSizeMake(SWIDTH - addressLabel.right - 15 - 20, shoujianxinxi.height);
    [shoujianxinxi addTarget:self action:@selector(shoujianxinxiAct:) forControlEvents:UIControlEventTouchUpInside];
    [qupiaofangshi addTarget:self action:@selector(qupiaoAct:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)qupiaoAct:(UIButton *)btn{

    NSArray *arr = @[@"快递到家",@"火车站配送"];
    CBAlertView *view = [[CBAlertView alloc]initWithTitle:@"请选取取票方式" actionsTitles:arr imgnames:nil showCancel:YES showSure:NO event:^(id value) {
        [self.view endEditing:YES];
        [btn setTitle:arr[[value integerValue]] forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",shouhuoInfo.take_uname,shouhuoInfo.take_pcc,shouhuoInfo.take_address];
        if (!shouhuoInfo) {
             [shoujianxinxi setTitle:@"请点击设置收货信息" forState:UIControlStateNormal];
        }else
            [shoujianxinxi setTitle:str forState:UIControlStateNormal];
    }];

}

#pragma mark 配送信息点击
-(void)shoujianxinxiAct:(UIButton *)btn{
    
    ChangyongPsvc *vc = (ChangyongPsvc *)[self getVCInBoard:@"Main" ID:@"ChangyongPsvc"];
    vc.isfromChoose = YES;
    
    vc.touchEvent = ^(UserInfo *info){
        shouhuoInfo = info;
        
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",shouhuoInfo.take_uname,shouhuoInfo.take_pcc,shouhuoInfo.take_address];
        if (!shouhuoInfo) {
            [shoujianxinxi setTitle:@"请点击设置收货信息" forState:UIControlStateNormal];
        }else
        [shoujianxinxi setTitle:str forState:UIControlStateNormal];
        if (shouhuoInfo.take_phone.length==1&&[shouhuoInfo.take_phone isEqualToString:@"0"]) {
            shoujihao.text = @"";
        }else{
            shoujihao.text = shouhuoInfo.take_phone;
        }
        
    };
    PUSH(vc);
}

-(void)initPayView{
   
    payView = [[PayView alloc]initWithFrame:CGRectMake(0, SHEIGHT - 45 - 64, SWIDTH, 45)];
    payView.clipsToBounds = YES;
    [payView.moneyBtn addTarget:self action:@selector(changeHeight) forControlEvents:UIControlEventTouchUpInside];
    [payView.payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:payView];
    
    NSLog(@"");
}
-(void)changeHeight{
//    126  214
    [UIView animateWithDuration:0.5 animations:^{
        
    if (payView.height==45) {
        payView.height = 45*3;
        payView.top = SHEIGHT - payView.height;
    }else{
        payView.height = 45;
        payView.top = SHEIGHT - payView.height;

    }
    }];
}

#pragma mark 添加联系人刷新界面
-(void)updateChengkeView{
//联系人判断为空
    if (selectedCustomer.count != 0) {
        _chengkeView.hidden = NO;
        CGFloat height = selectedCustomer.count * 50;
        self.chengkeView.height = height;
        NSInteger index= 100 ;
        for (Customer * cus in selectedCustomer) {
            UIView *view = [self.chengkeView viewWithTag:index];
            
            UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH - 15 - 8, (view.height - 15) / 2, 8, 15)];
            arrowImageView.image = [UIImage imageNamed:@"more_icon"];
            [view addSubview:arrowImageView];
            
            view.hidden = NO;
            UILabel *l1 = [view viewWithTag:10];
            l1.text = cus.name;
            UILabel *l2 = [view viewWithTag:11];
            l2.text = cus.type_name;
            UILabel *l3 = [view viewWithTag:12];
            l3.text = cus.id_number;
            index+=1;
        }
        
        for (NSInteger i = index ; i <= 104; i++) {
            UIView *view = [self.chengkeView viewWithTag:i];
            view.hidden = YES;
        }

    }
    else{
        _chengkeView.height = 0;
    }
    CGFloat hh = 0;

    //抢票信息
    if (self.from==4) {
        if (qpxinxi) {
            self.speed_12306.top = self.chengkeView.bottom;
//            qpxinxi.size = CGSizeMake(SWIDTH, 180);
            qpxinxi.top = self.speed_12306.bottom;
            hh = qpxinxi.bottom;
        }
    }
    
    if (self.from == 5) {
        if (qpxinxi && psxinxi) {
            self.speed_12306.top = self.chengkeView.bottom;
            qpxinxi.size = CGSizeMake(SWIDTH, 185);
            qpxinxi.top = self.speed_12306.bottom;
            psxinxi.top = qpxinxi.bottom;
            psxinxi.size = CGSizeMake(SWIDTH, 135);
            hh = psxinxi.bottom;
        }
    }
    
        self.bgScView.contentSize = CGSizeMake(SWIDTH, hh);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.view endEditing:YES];
}

- (void)showDate {
    NSMutableString *str = [NSMutableString string];
    DateObject *oobj = selectedDate.firstObject;
    train_date = oobj.originalStr;
    
    
   
        for (int i = 0; i < selectedDate.count; i++) {
            
            DateObject * date = selectedDate[i];
            
            if (selectedDate.count == 1) {
                
                [str appendFormat:@"%@",date.originalStr];
            }
            else{
            
            if (i == selectedDate.count - 1) {
                [str appendFormat:@"%@",date.originalStr];
            }
            else{
                 [str appendFormat:@"%@,",date.originalStr];
            }
            }
            
        }
    
    [self.riqiBtn setTitle:str forState:UIControlStateNormal];
     [[NSUserDefaults standardUserDefaults]setObject:str forKey:SelectRiqiKey];
   
}

#pragma mark 计算票钱
-(void)showSeattype{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < selectedType.count; i++) {
        
        SeatType * date = selectedType[i];
        
        if (selectedType.count == 1) {
            
            [str appendFormat:@"%@",date.name];
        }
        else{
            
            if (i == selectedType.count - 1) {
                [str appendFormat:@"%@",date.name];
            }
            else{
                [str appendFormat:@"%@,",date.name];
            }
        }
        
    }
    
    [self.leixing setTitle:str forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:SelectZXKey];

    
    CGFloat maxP = [self getMaxPrice];
    zuigaopiaojia.text = [NSString stringWithFormat:@"¥%.1f",maxP];
    zuigaopiaojia.textColor = [UIColor redColor];
    
    
    
    CGFloat buyedPrice = [self getMaxPrice]*100;
    CGFloat singleIns = 0.0;
    
    if (baoxianInfo) {
        for (NSDictionary *ins in baoxianInfo) {
            if (ins[@"insurance_type"] && [ins[@"insurance_type"] integerValue]==4) {
                CGFloat min = [ins[@"min_val"] floatValue];
                CGFloat max = [ins[@"max_val"] floatValue];
                if (buyedPrice<max && buyedPrice>min) {
                    singleIns = [ins[@"money"] floatValue];
                    break;
                }
            }
        }
    }
    if (singleIns<50) {
        singleIns = singleIns*100;
    }
    NSInteger count = selectedCustomer.count;
    if (count==0) {
        count = 1;
    }
//    [baoxianButton setTitle:[NSString stringWithFormat:@"%@.0/份",_surePrice] forState:UIControlStateNormal];
//    baoxianLable.text = [NSString stringWithFormat:@"%.1f元/份",singleIns/100.0];
    
    NSMutableArray * childrenArrayMu = [NSMutableArray array];
    for (Customer * cus in selectedCustomer) {
        if ( [cus.personType isEqualToString:@"1"]) {
            [childrenArrayMu addObject:cus];
        }
    }
    
    NSArray * biaoxianArray = [_surePrice componentsSeparatedByString:@"¥"];
    baoxianPrice = [biaoxianArray[1] floatValue];
    payView.baoxianPrice.text =  [NSString stringWithFormat:@"¥%.1f元x%ld",baoxianPrice,(long)count];
    payView.chepiaoPrice.text = [NSString stringWithFormat:@"¥%.1f元x%ld",buyedPrice/100.0,(long)count];
    CGFloat totalprice = baoxianPrice * count + buyedPrice/100.0*count;
    [payView.moneyBtn setTitle:[NSString stringWithFormat:@"实付款:¥%.1f元",totalprice] forState:UIControlStateNormal];
    
}
-(void)showCheci{
    NSMutableString *str = [NSMutableString string];
    
    
    for (int i = 0; i < selectedCheci.count; i++) {
        
        CheCiRes * date = selectedCheci[i];
        
        if (selectedCheci.count == 1) {
            
            [str appendFormat:@"%@",date.train_code];
        }
        else{
            
            if (i == selectedCheci.count - 1) {
                [str appendFormat:@"%@",date.train_code];
            }
            else{
                [str appendFormat:@"%@,",date.train_code];
            }
        }
        
    }
    
//    for (CheCiRes *checi in selectedCheci) {
//        
//        [str appendFormat:@"%@,",checi.train_code];
//    }
    [self.checiBtn setTitle:str forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:SelectCheCiKey];
}
- (IBAction)mudidi:(UIButton *)sender {
    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"ChoeseStationVC"];
    vc.touchEvent = ^(id value){
        TrainStation *st = value;
        mudidiSt = st;
        
        [sender setTitle:st.name forState:UIControlStateNormal];
        NSLog(@"选择了:%@",st.name);
      [self clearData];
//        if (self.issingle) {
//            if (![self.preObjvalue isKindOfClass:[CheCiRes class]]) {
//                [self.riqiBtn setTitle:[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"] forState:UIControlStateNormal];
//                NSString *title = [NSString stringWithFormat:@"%@,",[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"]];
//                [[NSUserDefaults standardUserDefaults]setObject:title forKey:SelectRiqiKey];
//            }
//        }

    };
    PUSH(vc);
}
- (IBAction)chufaact:(UIButton *)sender {
    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"ChoeseStationVC"];
    vc.touchEvent = ^(id value){
        TrainStation *st = value;
        chufadiSt = st;
        [sender setTitle:st.name forState:UIControlStateNormal];
        NSLog(@"选择了:%@",st.name);
         [self clearData];
//        if (self.issingle) {
//            if (![self.preObjvalue isKindOfClass:[CheCiRes class]]) {
//
//                [self.riqiBtn setTitle:[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"] forState:UIControlStateNormal];
//                NSString *title = [NSString stringWithFormat:@"%@,",[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"]];
//                [[NSUserDefaults standardUserDefaults]setObject:title forKey:SelectRiqiKey];
//            }
//        }



    };
    PUSH(vc);
}
-(void)setStaionTtile{
    [_chufadi setTitle:chufadiSt.name forState:UIControlStateNormal];
    [_mudidi setTitle:mudidiSt.name forState:UIControlStateNormal];
}
- (IBAction)qiehuan:(UIButton *)sender {
    TrainStation *st = chufadiSt;
    chufadiSt = mudidiSt;
    mudidiSt = st;
    [self setStaionTtile];
    [self clearData];
//    if (self.issingle) {
//        if (![self.preObjvalue isKindOfClass:[CheCiRes class]]) {
//            [self.riqiBtn setTitle:[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"] forState:UIControlStateNormal];
//             NSString *title = [NSString stringWithFormat:@"%@,",[AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd'"]];
//            [[NSUserDefaults standardUserDefaults]setObject:title forKey:SelectRiqiKey];
//        }
//    }

}

- (void)clearData{
    [selectedCheci removeAllObjects];
    [selectedType removeAllObjects];

    [self.checiBtn setTitle:@"" forState:UIControlStateNormal];
    [self.leixing setTitle:@"" forState:UIControlStateNormal];

    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectCheCiKey];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectZXKey];
//    if (!_issingle) {
        [selectedDate removeAllObjects];
        [self.riqiBtn setTitle:@"" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectRiqiKey];
//    }

}

- (IBAction)riqi:(UIButton *)sender {
    ChooseDateViewController *vc = (ChooseDateViewController *)[self getVCInBoard:nil ID:@"ChooseDateViewController"];
    vc.preObjvalue = selectedDate; 
    vc.issingle = self.issingle;
    
    __weak typeof(self) weakSelf = self;
    vc.touchEvent = ^(id value){
        if ([value isKindOfClass:[NSArray class]]) {

#pragma mark - 选择日期清空 车次信息和坐席信息
//            [self clearData];
            selectedDate = value;
            [weakSelf showDate];
            [self.checiBtn setTitle:@"" forState:UIControlStateNormal];
            [self.leixing setTitle:@"" forState:UIControlStateNormal];
            [selectedCheci removeAllObjects];
            [selectedType removeAllObjects];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectZXKey];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectCheCiKey];

        }  
    };

    PUSH(vc);
}
- (IBAction)xuanriqi:(UITapGestureRecognizer *)sender {
    [self riqi:nil];
}
- (IBAction)xuanzuoxi:(UITapGestureRecognizer *)sender {
    [self leixing:nil];
}
- (IBAction)xuanche:(UITapGestureRecognizer *)sender {
    [self checi:nil];
}
#pragma mark - 选择车次
- (IBAction)checi:(UIButton *)sender {
    if (selectedDate.count<1 && !_issingle) {
        [MBProgressHUD showHudWithString:@"请选择乘车时间" model:MBProgressHUDModeCustomView];
        return;
    }


    SearchResVc *vc = (SearchResVc *)[self getVCInBoard:nil ID:@"SearchResVc"];
    __weak typeof(self) weakSelf = self;
    vc.isFromDZ = YES;
    if (!train_date) {
        train_date = [AppManager getCurrentTimeStrWithformat:@"yyyy-MM-dd"];
    }

    BOOL isgtdc = [self.title isEqualToString:@"高铁动车选座"]?1:0;
    vc.preObjvalue = @[chufadiSt,mudidiSt,train_date,@(isgtdc),@0];
    vc.issingle = self.issingle;
    vc.from = _from;
    if (self.from == 1 || self.from == 2 || self.from == 3) {
        
        if (!isgtdc) {
            vc.isputong = YES;
        }
    }
    if (self.from==4) {
        vc.issingle = NO;
        vc.isputong = NO;
        
    }
    if (self.from==5) {
        vc.isputong = NO;
        
        vc.issingle = NO;
    }
    vc.touchEvent = ^(id value){
        if ([value isKindOfClass:[NSArray class]]) {
            selectedCheci = value;
#pragma mark - 选择车次 清空坐席类型
            [selectedType removeAllObjects];
            [self.leixing setTitle:@"" forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectZXKey];
            zuigaopiaojia.text = [NSString stringWithFormat:@"¥"];
            zuigaopiaojia.textColor = [UIColor redColor];

            if (self.issingle) {
                CheCiRes *che = selectedCheci.firstObject;
                DateObject *dateObj = [[DateObject alloc]init];
                NSMutableString *ss = [NSMutableString stringWithString:che.train_start_date];
                [ss insertString:@"-" atIndex:4];
                [ss insertString:@"-" atIndex:7];
                dateObj.showStr = ss;
                dateObj.originalStr = ss;
                [selectedDate removeAllObjects];
                [selectedDate addObject:dateObj];
                train_date = selectedDate.firstObject.originalStr;
                
                [weakSelf showDate];
                
            }
            [weakSelf showCheci];
        }  
    };
    vc.stationInfo = ^(TrainStation *value1, TrainStation *value2) {
        chufadiSt = value1;
        mudidiSt = value2;
        [self setStaionTtile];
    };
    
    PUSH(vc);
}
- (IBAction)leixing:(UIButton *)sender {
    if (selectedDate.count<1) {
        [MBProgressHUD showHudWithString:@"请选择乘车时间" model:MBProgressHUDModeCustomView];
        return;
    }
    if (selectedCheci.count<1) {
        [MBProgressHUD showHudWithString:@"请选择车次" model:MBProgressHUDModeCustomView];
        return;
    }
    ChooseSeatTypeVc *vc = (ChooseSeatTypeVc *)[self getVCInBoard:nil ID:@"ChooseSeatTypeVc"];
    vc.preObjvalue = selectedType;
    vc.issingle = self.issingle;
    if (self.from==5) {
        vc.issingle = NO;
    }
    NSMutableArray *allhaveTypeArr = [NSMutableArray array];
    for (CheCiRes *res  in selectedCheci) {
        for (NSString *strr in res.seatTypeArr) {
            if (![allhaveTypeArr containsObject:strr]) {
                [allhaveTypeArr addObject:strr];
            }
        }
    }
    vc.haveTypeArr = allhaveTypeArr;
    __weak typeof(self) weakSelf = self;
    vc.touchEvent = ^(id value){
        if ([value isKindOfClass:[NSArray class]]) {
            selectedType = value;
            [weakSelf showSeattype];
        }  
    };
    PUSH(vc);
}

#pragma mark 添加儿童乘客
- (void)ClickWithaddChildren{
    if (selectedCustomer.count >=5) {
        [MBProgressHUD showHudWithString:@"最多只能添加5位乘客" model:MBProgressHUDModeCustomView];
        return;
    }
    if (selectedCustomer.count == 0) {
        [MBProgressHUD showHudWithString:@"请您先选择成人的信息!" model:MBProgressHUDModeCustomView];
    }
    else{
        Customer * cus = selectedCustomer[0];
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
        [selectedCustomer addObject:customerArray[0]];
       
       
        [self updateChengkeView];
    }
    
}

#pragma mark 添加联系人
- (IBAction)tianjiack:(UIButton *)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isrxlogin"];
    if (!isLogin) {
        
        BaseViewController *vcv = (BaseViewController *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
        
        vcv.preObjvalue = @"DZXZVc";
        PUSH(vcv);
        return;
    }
    
    NSString *value = @"";
    for (Customer *cus in selectedCustomer) {
        value = [value stringByAppendingString:[NSString stringWithFormat:@",%@",cus.id_number]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:SelectCKKey];;

    ChoosePerson *vc = (ChoosePerson *)[self getVCInBoard:nil ID:@"ChoosePerson"];
    vc.preObjvalue = selectedCustomer;
    if ([self.title containsString:@"12306"]) {
        vc.ischoose12306 = YES;
    }else{
        vc.ischooserx = YES;
    }
    __weak typeof(self) weakSelf = self;
    vc.touchEvent = ^(id value){
        if ([value isKindOfClass:[NSArray class]]) {
            
            [selectedCustomer removeAllObjects];
            [selectedCustomer addObjectsFromArray:value];
            
            [self showSeattype];
            
            [weakSelf updateChengkeView];

        }  
    };
    PUSH(vc);
}


#pragma mark 删除联系人
- (IBAction)delete:(UIButton *)sender {
    NSInteger index = sender.superview.tag - 100;
    if (index<selectedCustomer.count) {
        [selectedCustomer removeObjectAtIndex:index];
        [self updateChengkeView];
    }
}

#pragma mark 点击下一步的按钮
-(void)nextStep:(UIButton *)btn{

    if (!chufadiSt) {
        return;
    }
    if (!mudidiSt) {
        return;
    }
    if (selectedDate.count<1) {
        [MBProgressHUD showHudWithString:@"请选择乘车时间" model:MBProgressHUDModeCustomView];
        return;
    }
    if (selectedCheci.count<1) {
         [MBProgressHUD showHudWithString:@"请选择车次" model:MBProgressHUDModeCustomView];
        return;
    }
    if (selectedType.count<1) {
         [MBProgressHUD showHudWithString:@"请选择坐席类型" model:MBProgressHUDModeCustomView];
        return;
    }
    if (selectedCustomer.count<1) {
         [MBProgressHUD showHudWithString:@"请选择乘客" model:MBProgressHUDModeCustomView];
        return;
    }
    
    if ([btn.currentTitle isEqualToString:@"下一步(选座)"]) {
       
        SubmitOrderVc *vc = (SubmitOrderVc *)[self getVCInBoard:nil ID:@"SubmitOrderVc"];
        vc.type = 1;
        vc.title = @"选择座位";
        
        vc.issirendingzhi = YES;
        
        if (![self.preObjvalue isKindOfClass:[CheCiRes class]]) {
            self.preObjvalue = selectedCheci.firstObject;
        }
        vc.preObjvalue = selectedCheci.firstObject;
        vc.selectedCustomer = selectedCustomer;
        if (self.from==6) {
            vc.isspsm = YES;
        }else if(self.from==7){
            vc.issirendingzhi = YES;
        }
        
            CheCiRes *ress1 = selectedCheci.firstObject;
            NSString *proname = selectedType.firstObject.type_name;
        if (![proname containsString:@"_price"]) {
            
            proname = [proname stringByAppendingString:@"_price"];
        }
            vc.buyedZuowei = selectedType.firstObject.name;
            vc.buyedZuoweiCode = proname;
            vc.buyedPrice = [[ress1 mj_keyValues] objectForKey:proname];

        PUSH(vc);
    }
    
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
    }else if ([code containsString:@"rw"]) {
        name = @"软卧";
        index = 6;
    }else if ([code containsString:@"rz"]) {
        name = @"软座";
        index = 7;
    }else if ([code containsString:@"yw"]) {
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

#pragma mark 获取最高票价
-(CGFloat)getMaxPrice{

    CGFloat maxP = 0;
    for (CheCiRes *resche in selectedCheci) {
        NSString *maxStr = @"";
        for (SeatType *seat in selectedType) {
            if ([seat.name containsString:@"硬卧"]) {
                maxStr = @"ywx_price";
            }else if ([seat.name containsString:@"高级软卧"]) {
                maxStr = @"gjrw_price";
                
            }else if ([seat.name containsString:@"软卧"]) {
                maxStr = @"rwx_price";
            }else{
                if ([seat.type_name containsString:@"_price"]) {
                    maxStr = seat.type_name;
                }
                else{
                    maxStr = [seat.type_name stringByAppendingString:@"_price"];
                }
            }
            
            
            NSString *price = [[resche mj_keyValues] objectForKey:maxStr];
            if (price && price.length>0) {
                CGFloat p = [price floatValue];
                if (p>maxP) {
                    maxP = p;
                }
            }
        }
        
    }
    return maxP;
    
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

#pragma mark 点击下一步按钮  添加12306抢票任务  || 添加人工抢票任务 == 5
-(void)pay{
    CheCiRes *checi = selectedCheci.firstObject;

    if (!checi) {
        [MBProgressHUD showHudWithString:@"请选择车次" model:MBProgressHUDModeCustomView];
        return;
    }
    if (selectedType.count < 1) {
         [MBProgressHUD showHudWithString:@"请选择坐席类型" model:MBProgressHUDModeCustomView];
        return;
    }
    
    if (selectedCustomer.count<1) {
         [MBProgressHUD showHudWithString:@"请选择乘客" model:MBProgressHUDModeCustomView];
        return;
    }
    if (self.from ==5 && !shouhuoInfo) {
         [MBProgressHUD showHudWithString:@"请填写收件信息" model:MBProgressHUDModeCustomView];
        return;
    }
    
    NSMutableArray * piaoTypeLineArray = [NSMutableArray array];
    for (Customer *cus in selectedCustomer){
        if ([cus.piaotype intValue] == 2) {
            [piaoTypeLineArray addObject:cus.piaotype];
        }
    }
    if (piaoTypeLineArray.count == selectedCustomer.count) {
         [MBProgressHUD showHudWithString:@"儿童票不能单独购买" model:MBProgressHUDModeCustomView];
        return;
    }
    
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[@"UToken"] = UToken;
    
    par[@"from_station_code"] = checi.from_station_code;
    par[@"from_station_name"] = checi.from_station_name;
    par[@"to_station_code"] = checi.to_station_code;
    par[@"to_station_name"] = checi.to_station_name;
    

    NSString *postUrl = @"Action/createGrabTicketOnline/";
    //添加12306抢票任务
    if (self.from==4) {
        
        NSString *LoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
        NSString *LoginUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
        
        par[@"LoginUserName"] = LoginUserName;
        par[@"LoginUserPassword"] = LoginUserPassword;
        
        NSString *trainType = [checi.train_code substringToIndex:1];
        //    	G,D,Z,T,K,C,Q	
        if ([trainType isEqualToString:@"G"] || [trainType isEqualToString:@"D"] || [trainType isEqualToString:@"Z"]|| [trainType isEqualToString:@"T"]|| [trainType isEqualToString:@"K"]|| [trainType isEqualToString:@"C"]) {
            
            par[@"train_type"] = trainType; 
        }else{
            par[@"train_type"] = @"Q"; 
        }
        NSString *start_date = @"";
        
        for (int i=0; i<selectedDate.count; i++) {
            NSString *dd = selectedDate[i].originalStr;
            dd = [dd stringByReplacingOccurrencesOfString:@"-" withString:@""];
            dd = [dd stringByReplacingOccurrencesOfString:@"-" withString:@""];
            dd = [dd stringByAppendingString:@","];
            start_date = [start_date stringByAppendingString:dd];            
        }
        par[@"start_date"] = start_date;

        par[@"start_begin_time"] = @"00:00";
        par[@"start_end_time"] = @"24:00";
        
        NSString *train_codes = @"";
        NSInteger startMinte = 0;
        
        for (int i =0; i < selectedCheci.count; i++) {
            
            CheCiRes * re = selectedCheci[i];
            
            if (i == selectedCheci.count - 1) {
                train_codes = [train_codes stringByAppendingString:re.train_code];
            }
            else{
                NSString *tt = [re.train_code stringByAppendingString:@","];
                train_codes = [train_codes stringByAppendingString:tt];
            }
            
             NSInteger new = [self solveMinuteWithTime:re.start_time];
            if (new>startMinte) {
                startMinte = new;
            }
            
        }
//        zwcodearr	 							array(P,M)		坐席类型CODE,9:商务座，P:特等座，M:一等座，O:二等座，6:高级软卧，4:软卧，3:硬卧，2:软座，1:硬座        
        par[@"train_codes"] = train_codes;
        par[@"seat_type"] = [_leixing.currentTitle stringByReplacingOccurrencesOfString:@"无座" withString:@"其他"];
        par[@"qorder_start_time"] = [AppManager getCurrentTimeStrWithformat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *end = [NSDate dateWithTimeIntervalSinceNow:3600*24*60];
        NSString *endstr = [selectedDate.lastObject.originalStr stringByAppendingString:@"00:00:00"];
        startMinte-= 4*60;
        if (startMinte>0) {
            NSInteger hh = startMinte/60;
            NSInteger min = startMinte%60;
            
            endstr = [NSString stringWithFormat:@"%@ %02ld:%02ld:00",selectedDate.lastObject.originalStr,(long)hh,min];

        }
        par[@"qorder_start_time"] = [AppManager getCurrentTimeStrWithformat:@"yyyy-MM-dd HH:mm:ss"];
        par[@"qorder_end_time"] = endstr;
        
        
        par[@"take_phone"] = shoujihao.text;

        
        CGFloat buyedPrice = [self getMaxPrice]*100;
        par[@"max_price"] = @(buyedPrice/100.0);
        
        NSMutableArray *passengers = [NSMutableArray array];
        
        //        票类型;1:成人票，2:儿童票，3:学生票，4:残军票

        for (Customer *cus in selectedCustomer) {
            NSDictionary *passeng = @{@"passengersename":cus.name,@"passportseno":cus.id_number?cus.id_number:@"",@"passporttypeseidname":cus.id_name?cus.id_name:@"身份证",@"passporttypeseid":@(cus.id_type),@"passengerid":cus.passengerid,@"piaotype":cus.piaotype};
            NSMutableDictionary *dicc = [NSMutableDictionary dictionaryWithDictionary:passeng];
            //当是学生时需要更多信息
            if (cus.isXs) {
                
            }
            [passengers addObject:dicc];
        }
        NSArray * biaoxianArray = [_surePrice componentsSeparatedByString:@"¥"];
        
        par[@"insurance"] = @([biaoxianArray[1] floatValue] * 100);
        CGFloat moneryBiaoxian = [biaoxianArray[1] integerValue] * passengers.count;
        par[@"all_insurance"] = @([[NSString stringWithFormat:@"%f",moneryBiaoxian] integerValue] * 100);
        
        
        
        par[@"passengers"] = passengers;
        
    }else {
        //人工抢票 createGrabTicketOffline_test
        postUrl = @"Action/createGrabTicketOffline_test/";
        NSString *train_codes = @"";
        NSInteger startMinte = 0;
        for (int i =0; i < selectedCheci.count; i++) {
            
            CheCiRes * re = selectedCheci[i];
            
            if (i == selectedCheci.count - 1) {
                train_codes = [train_codes stringByAppendingString:re.train_code];
            }
            else{
                NSString *tt = [re.train_code stringByAppendingString:@","];
                train_codes = [train_codes stringByAppendingString:tt];
            }
            
            NSInteger new = [self solveMinuteWithTime:re.start_time];
            if (new>startMinte) {
                startMinte = new;
            }
            
        }
        
        par[@"checi"] = train_codes;
        par[@"runtime"] = checi.run_time;
        NSMutableString *ss = [NSMutableString stringWithString:checi.train_start_date];
        [ss insertString:@"-" atIndex:4];
        [ss insertString:@"-" atIndex:7];
        NSString *start_date = @"";
        for (int i=0; i<selectedDate.count; i++) {
            NSString *dd = selectedDate[i].originalStr;
            dd = [dd stringByAppendingString:@","];
            start_date = [start_date stringByAppendingString:dd];
           
        }
        NSMutableString * date_mutable = [NSMutableString stringWithFormat:@"%@",start_date];
        [date_mutable deleteCharactersInRange:NSMakeRange(date_mutable.length - 1, 1)];
        par[@"train_date"] = date_mutable;
        par[@"start_time"] = [NSString stringWithFormat:@"%@ %@:00" ,ss,checi.start_time];
        
        par[@"arrive_time"] = [NSString stringWithFormat:@"%@ %@:00" ,ss,checi.arrive_time];
        
        par[@"is_accept_standing"] = @"0";

        NSMutableArray *zwcodearr = [NSMutableArray array];
        for (SeatType *seat in selectedType) {
            NSString *code = [self zuoweiCodeWithName:seat.name];
            [zwcodearr addObject:code];
            if ([seat.name containsString:@"无座"]) {
                par[@"is_accept_standing"] = @"1";
            }
        }
        
        //如果选择了无座，则只传硬座的code，选了无座则is_accept_standing为1
        if ([zwcodearr containsObject:@"1"]) {
            [zwcodearr removeObject:@"1"];
            [zwcodearr addObject:@"1"];
        }
        par[@"zwcodearr"] = zwcodearr;
        par[@"take_phone"] = shoujihao.text;
        
        par[@"sendtype"] = @"2";
        NSInteger sendtype = 2;
        if ([qupiaofangshi.currentTitle isEqualToString:@"快递到家"]) {
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
        
        CGFloat buyedPrice = [self getMaxPrice]*100.0;
        
        par[@"max_price"] = @(buyedPrice/100.0);
        
        //乘客信息
        NSMutableArray *passengers = [NSMutableArray array];
        for (Customer *cus in selectedCustomer) {

            cus.passengerid = cus.person_id;
            
            NSDictionary *passeng = @{@"passengersename":cus.name,@"passportseno":cus.id_number?cus.id_number:@"",@"passporttypeseidname":cus.id_name?cus.id_name:@"身份证",@"passporttypeseid":@(cus.id_type),@"passengerid":cus.passengerid,@"piaotype":cus.piaotype,@"cxin":@""};
            
//            NSDictionary *passeng = @{@"passengerid":cus.passengerid,@"piaotype":cus.piaotype,@"passengersename":cus.name,@"passportseno":cus.id_number,@"passporttypeseidname":cus.id_name};
            
            [passengers addObject:passeng];
        }
        
        par[@"passengers"] = passengers;

        CGFloat singleIns = 0.0;
        
        if (baoxianInfo) {
            for (NSDictionary *ins in baoxianInfo) {
                if (ins[@"insurance_type"] && [ins[@"insurance_type"] integerValue]==4) {
                    CGFloat min = [ins[@"min_val"] floatValue];
                    CGFloat max = [ins[@"max_val"] floatValue];
                    if (buyedPrice<max && buyedPrice>min) {
                        singleIns = [ins[@"money"] floatValue];
                        break;
                    }
                }
            }
        }
        if (singleIns<50) {
            singleIns = singleIns*100;
        }
        
        NSArray * biaoxianArray = [_surePrice componentsSeparatedByString:@"¥"];
        par[@"insurance"] = @([biaoxianArray[1] floatValue] * 100);
        CGFloat moneryBiaoxian = [biaoxianArray[1] integerValue] * passengers.count;
        par[@"all_insurance"] = @([[NSString stringWithFormat:@"%f",moneryBiaoxian] integerValue] * 100);
    }
    if (self.from == 4 || self.from == 5) {
        par[@"q_fee"] = @([_moneyString intValue]);
        par[@"all_q_fee"] = @([[NSString stringWithFormat:@"%f",[_moneyString floatValue] * selectedCustomer.count] intValue]);
    }
    
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:par] andUrl:postUrl showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        
        if ([obj[@"code"] integerValue] == 1) {
            NSString *orderid = obj[@"data"][@"orderid"];
            if (!orderid) {
                [MBProgressHUD showHudWithString:obj[@"data"][@"result"] model:MBProgressHUDModeCustomView];
                return ;
            }
            OrderDetailAndPay *vc = (OrderDetailAndPay *)[self getVCInBoard:nil ID:@"OrderDetailAndPay"];
            
            vc.orderid = orderid;
            vc.url = self.from==4?@"Action/grabRowOnline/":@"Action/grabRowOffline/";
            vc.tuipiaoUrl = self.from==4?@"Action/grabOnlineReturn/":@"Action/grabOfflineReturn/";
     
            
            PUSH(vc);
        }
        else{
             [MBProgressHUD showHudWithString:obj[@"msg"] model:MBProgressHUDModeCustomView];
        }
    } andError:^(id error) {
          [MBProgressHUD showHudWithString:@"加载失败,请稍后重试" model:MBProgressHUDModeCustomView];
        NSLog(@"error==%@",error);
    }];
    
    
}
- (void)clickXuZhi:(UIButton *)button{
    BookingDetailsViewController * bookingDetailVC = [[BookingDetailsViewController alloc]init];
    [self.navigationController pushViewController:bookingDetailVC animated:YES];
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
