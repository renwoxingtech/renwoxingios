//
//  HomeViewController.m
//  CommonProject
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "NSString+Hash.h"
#import "CocoaSecurity.h"
#import "NSString+Encryption.h"
#import "RSA.h"

#import "CBAlertView.h"
#import "SearchResVc.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import <UIButton+WebCache.h>
#import "HZQDatePickerView.h"
#import "CalenderView.h"

#import "RMCalendarController.h"
#import "MJExtension.h"
#import "TicketModel.h"

#define BannerScale 2
//SDCycleScrollViewDelegate
@interface HomeViewController ()<HZQDatePickerViewDelegate,SDCycleScrollViewDelegate>
{
    
    SDCycleScrollView *bannerScrollView;
    NSArray *bannerData;
    TrainStation *chufadiSt;
    TrainStation *mudidiSt;
    HZQDatePickerView *_pikerView;
    NSDictionary *peizhiPar;
    NSArray *adInfo;
    NSDictionary *baoxianInfo;
    NSDictionary *adressInfo;
    UIView *adView;
    CalenderView *calender;
    UIImageView *startImageView;
    NSString *linkurl;
    NSIndexPath * _indexPath;
    
}
@end

@implementation HomeViewController

#pragma mark 启动图的效果
-(void)hideStart:(UIButton *)btn{
    UIView *view = startImageView.superview;
    if (view) {
        [UIView animateWithDuration:0.24 animations:^{
            view.alpha = 0.0;
            view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            
        }];
    }
}

-(void)test{
    //    http://42.51.10.86:8087/MethodIn.asmx/CaseMethad
    NSDictionary *ss = @{@"user_name":@"会飞的鱼",@"user_pass":@"123456"} ;
    NSString *url = @"http://42.51.10.86:8087/MethodIn.asmx/CaseMethad" ;
    ss = @{@"parames":[ss mj_JSONString],@"methodName":@"user_login"} ;
    
    [[Httprequest shareRequest] postObjectByParameters:ss andUrl:url showLoading:YES showMsg:YES isFullUrk:YES andComplain:^(id obj) {
        NSDictionary *dict = (NSDictionary *)obj;
        if (dict) {
            
        }
    } andError:^(id error) {
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.searchBtn.layer.cornerRadius = 5;
    self.searchBtn.layer.masksToBounds = YES;
    
    //启动图 在路上
   /* {
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *startView = [[[NSBundle mainBundle] loadNibNamed:@"StartView" owner:nil options:nil] firstObject];
        startView.frame = self.view.frame;
        startImageView = [startView viewWithTag:1];
       //点击屏幕跳转到百度
       //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushPage)];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
        [startView addGestureRecognizer:tap];
        
        [app.window addSubview:startView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideStart:nil];
            
        });
        
    }*/
    
    [self.chooeseDate setTitle:[AppManager getCurrentTimeStrWithformat:@"yyyy年MM月dd日"] forState:UIControlStateNormal];
    [self setupBanner];
    
    
    [self getPar];
    [self getStart];
    [self getAd];
    [self getBaoxian];
    
    self.needTap = NO;
    
    [self initStation];
    [self adressInfo];
    
    NSArray *hisArr = [self searchHis];
    if (hisArr.count>0) {
        NSString *hisstr = hisArr[0];
        NSArray *h = [hisstr componentsSeparatedByString:@"-"];
        NSString *h1 = h.firstObject;
        NSString *h2 = h.lastObject;
        if (h1 && h2 && h1.length>0 && h2.length>0) {
            [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.name isEqualToString:h1]) {
                    chufadiSt = obj;
                } else
                    if ([obj.name isEqualToString:h2]) {
                        mudidiSt = obj;
                    }
            }];
        }else{
            [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.name isEqualToString:@"北京"]) {
                    chufadiSt = obj;
                }
                if ([obj.name isEqualToString:@"上海"]) {
                    mudidiSt = obj;
                }
            }];
        }
    }else{
        [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:@"北京"]) {
                chufadiSt = obj;
            }
            if ([obj.name isEqualToString:@"上海"]) {
                mudidiSt = obj;
            }
        }];
    }
    
    
    [_chufadiBtn setTitle:chufadiSt.name forState:UIControlStateNormal];
    [_mudidiBtn setTitle:mudidiSt.name forState:UIControlStateNormal];
    
    [_mudidiBtn addObserver:self  forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _rightIndi.left = _mudidiBtn.titleLabel.left-20;
    [_mudidiBtn addSubview:_rightIndi];
    _rightIndi.centerY = _mudidiBtn.titleLabel.centerY;
    
    [self setHis];
    
}

- (void)pushPage{
    [self hideStart:nil];
    if (linkurl.length>0) {
        BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"WebViewController"];
        vc.preObjvalue = linkurl;
        PUSH(vc);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadNetData];
    [self getAd];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [calender.superview removeFromSuperview];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%.2f",_mudidiBtn.titleLabel.left);
        _rightIndi.left = _mudidiBtn.titleLabel.left-20;
        [_mudidiBtn addSubview:_rightIndi];
        _rightIndi.centerY = _mudidiBtn.titleLabel.centerY;
        
    });
}
- (NSString *)encodeParameter:(NSString *)originalPara {
    
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalPara, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    CFRelease(encodeParaCf);
    return encodePara;
}
-(void)setAdView:(NSArray *)data{
    //和上次一样的，不加载
    [adView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    [adView removeFromSuperview];
//    NSInteger index = 0;
    CGFloat w = 45/320.0*SWIDTH;
    CGFloat h = w;
    if (adView==nil) {
        adView = [[UIView alloc]initWithFrame:CGRectMake(0, SHEIGHT-50-h*2-20, SWIDTH, h*2+40)];
//        adView.backgroundColor = [UIColor redColor];
        adView.top = self.choosebgView.bottom;
        //    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        adView.backgroundColor = [UIColor clearColor];
        adView.layer.cornerRadius = 1;
        adView.layer.masksToBounds = YES;
        [_bgScollView addSubview:adView];
    }
//    CGFloat space = (adView.width-40-w*4)/3.0;
    
    
    //    for (int i=0; i<2; i++) {
    //        for (int j=0; j<4; j++) {
    //            if (index<data.count) {
    //                NSDictionary *dic = data[index];
    //                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((w+space)*j+20, (20+h)*i+10, w, w)];
    //                NSString *u = dic[@"adimg"];
    //                u = [NSString stringWithFormat:@"%@%@",BaseUrlIp,u];
    //
    //                u = [u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////                u = [self encodeParameter:u];
    //
    //                NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    //                u = [u stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    //
    //
    //                NSURL *iu = [NSURL URLWithString:u];
    //
    //                [btn sd_setImageWithURL:iu forState:UIControlStateNormal];
    ////                [btn setImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
    //                btn.backgroundColor = [UIColor whiteColor];
    //
    //                btn.layer.cornerRadius = btn.height*0.5;
    //                btn.layer.masksToBounds = YES;
    //                [btn addTarget:self action:@selector(adAct:) forControlEvents:UIControlEventTouchUpInside];
    ////                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    ////                [btn setTitle:@"adimg" forState:UIControlStateNormal];
    //                btn.tag = index+1;
    //                [adView addSubview:btn];
    ////
    //                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake((w+space)*j+20, btn.bottom, w+15, 18)];
    //                lable.textColor = [UIColor darkGrayColor];
    //                lable.textAlignment = NSTextAlignmentCenter;
    //                lable.text = dic[@"adtitle"];
    //                lable.centerX = btn.centerX;
    //                lable.font = [UIFont systemFontOfSize:12];
    //                [adView addSubview:lable];
    //                adView.height = lable.bottom;
    //
    //            }
    //            index+=1;
    //    }
    //    }
    if (calender) {
        [self.view bringSubviewToFront:calender];
    }
    _bgScollView.contentSize = CGSizeMake(0, MAX(_bgScollView.height, adView.bottom+20));
    
}
-(void)adAct:(UIButton *)btn{
    
    if (btn.tag<=adInfo.count) {
        NSString *iil = adInfo[btn.tag-1][@"adurl"];
        BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"WebViewController"];
        vc.preObjvalue = iil;
        PUSH(vc);
        
    }
}

-(void)setHis{
    NSArray *hisArr = [self searchHis];
    [self.lishiSc removeAllSubviews];
    if (hisArr.count>0) {
        UIButton *lastBtn;
        for (int i=0; i<hisArr.count+1; i++) {
            NSString *hisstr = @"";
            if (i==hisArr.count) {
                hisstr = @"清除历史";
            }else
                hisstr = hisArr[i];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(lastBtn?(lastBtn.right+8):0, 0, 100,  self.lishiSc.height)];
            [btn addTarget:self action:@selector(lishiClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:hisstr forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn.titleLabel sizeToFit];
            btn.width = btn.titleLabel.width;
            btn.tag = 10;
            [self.lishiSc addSubview:btn];
            lastBtn = btn;
            if (i==hisArr.count) {
                self.lishiSc.contentSize = CGSizeMake(btn.right, self.lishiSc.height);
            }
        }
    }
}

-(void)saveSearchHis{
    NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"searchHis.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *data = [dic[@"data"] mutableCopy];
    while (data.count>=5) {
        [data removeObjectAtIndex:0];
    }
    if (!data) {
        data = [NSMutableArray array];
    }
    
    NSString *ss = [NSString stringWithFormat:@"%@-%@",chufadiSt.name,mudidiSt.name];
    NSString *first = data.lastObject;
    if (![ss isEqualToString:first]) {
        [data addObject:ss];
        
        if([@{@"data":data} writeToFile:path atomically:YES]){
            NSLog(@"保存历史成功");
        }else{
            
        }
        [self setHis];
    }
}

-(NSArray *)searchHis{
    NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"searchHis.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *his = dic[@"data"];
    his =  [[his reverseObjectEnumerator] allObjects];
    
    return his;
    
}

-(void)loadNetData{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/getBanner/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        NSDictionary *dict = (NSDictionary *)obj;
        if (dict) {
            bannerData = dict[@"data"];
            NSMutableArray *urls = [NSMutableArray array];
            for (NSDictionary *dic in bannerData) {
                [urls addObject:[NSString stringWithFormat:@"%@%@",BaseUrlIp,dic[@"imgurl"]]];
                
            }
            if ([[bannerScrollView.imageURLStringsGroup mj_JSONString] isEqualToString:[urls mj_JSONString]]) {
                return ;
            }
            bannerScrollView.imageURLStringsGroup = urls;
            
        }
    } andError:^(id error) {
        
    }];
}
-(void)setupBanner{
    
    NSArray *arr = @[@""];
    //UI元素的frame调整
    bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -20, SWIDTH,SWIDTH/BannerScale) imageURLStringsGroup:arr];
    bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    bannerScrollView.delegate = self;
    bannerScrollView.dotColor = [UIColor whiteColor]; //分页控件小圆标颜色
    bannerScrollView.pageControlDotSize = CGSizeMake(5, 5); //分页控件小圆标大小
    
    bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    bannerScrollView.autoScrollTimeInterval = 6;
    bannerScrollView.backgroundColor = [UIColor colorWithRed:0.9207 green:0.9158 blue:0.9255 alpha:1.0];
    bannerScrollView.placeholderImage = [UIImage imageNamed:@"placeH"];
    
    [_bgScollView addSubview:bannerScrollView];
    
}


#pragma mark 轮播图点击后界面进行跳转
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    NSMutableArray *urls = [NSMutableArray array];
//    for (NSDictionary *dic in bannerData) {
//        [urls addObject:dic[@"linkurl"]];
//
//    }
//    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"WebViewController"];
//    vc.navBar.hidden = NO;
//    if (index<urls.count) {
//
//
//    vc.preObjvalue = urls[index];
//
////    PUSH(vc);
//          }
//
//
//}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    CBAlertView *vv = [[CBAlertView alloc]initWithTitle:@"提示" actionsTitles:@[@"吃",@"阿萨德刚切割人工湖",@"收到",@"碍事"] imgnames:nil showCancel:YES showSure:YES event:^(id value) {
    //
    //    }];
}

-(NSString *)chineseToPinyin:(NSString *)chinese{
    //将汉字转化成拼音的代码：
    NSMutableString *mutableString = [NSMutableString stringWithString:chinese];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    mutableString =(NSMutableString *)[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mutableString;
}
-(void)yupiaoSearchst1:(TrainStation *)station1 st2:(TrainStation *)station2{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *key = @"AwCT4ccslMB3TFQ6M8H6qadrOT8ZCXVg";
    parameters[@"partnerid"] = @"bjrwx";
    parameters[@"reqtime"] = [AppManager getCurrentTimeStrWithformat:@"yyyyMMddHHmmss"];//yyyyMMddHHmmss
    NSString *md5Key = [key md5Hash];
    NSLog(@"md5Key   %@",md5Key);
    parameters[@"method"] = @"train_query";
    parameters[@"method"] = @"get_train_info";
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",parameters[@"partnerid"],parameters[@"method"],parameters[@"reqtime"],md5Key];
    NSLog(@"sign   %@",sign);
    parameters[@"sign"] = [sign md5Hash];//md5(partnerid+method+reqtime+md5(key))
    
    
    parameters[@"train_no"] = @"240000G1010C";
    parameters[@"train_code"] = @"G101";
    
    
    
    parameters[@"train_date"] = [AppManager getCurrentTimeStrWithformat:@"yyyy-MM-dd"];//yyyy-MM-dd
    parameters[@"from_station"] = @"VNP";
    parameters[@"to_station"] = @"AOH";
    NSLog(@"%@",[parameters mj_JSONString]);
    
    //    NSString *url = [NSString stringWithFormat:@"http://searchtrain.hangtian123.net/trainSearch?"];
    //    NSString *par = [NSString stringWithFormat:@"jsonStr=%@",[parameters mj_JSONString]];
    //    NSString *getUrl = [url stringByAppendingString:par];
    //get
    //    [[NetRequest shareRequest] requestWithUrl:getUrl parameters:nil isJsonpar:NO  isPost:NO andComplain:^(id obj) {
    //
    //    } andError:^(id error) {
    //
    //    }];
    
    //post
    NSString *posturl = [NSString stringWithFormat:@"http://searchtrain.hangtian123.net/trainSearch"];
    
    NSDictionary *postPar = @{@"jsonStr":[parameters mj_JSONString]};
    
    [[Httprequest shareRequest] postObjectByParameters:postPar andUrl:posturl showLoading:YES showMsg:YES isFullUrk:YES andComplain:^(id obj) {
        NSLog(@"");
    } andError:nil];
    
    
}
-(void)testLogin:(NSData *)par{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://trainorder.test.hangtian123.net/cn_interface/trainAccount/validate"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = par;
    
    NSString *endStr = @"{\"data\":{\"trainAccount\":\"18515065942\",\"pass\":\"123456\"},\"accountversion\":\"2\"}";
    
    request.HTTPBody = [endStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        @try {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([dict[@"items"] isKindOfClass:[NSArray class]]) {
                
            }
            NSLog(@"%@",dict);
        } @catch (NSException *exception) {
            
        } @finally{
            
        }
        
    }];
    [dataTask resume];
    
    
}

- (void)desTest {
    NSString *plainText = @"{\"trainAccount\":\"18515065942\",\"pass\":\"123456\"}";
    
    
    NSLog(@"加密源：%@",plainText);
    
    NSString *key = @"v66r9ogtcvtxv3v4xq3gog8fqdbhwmt0";
    NSString *desBase64 = [plainText desEncryptWithKey:key];
    NSData *keydata = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *desData = [plainText desEncryptWithDataKey:keydata];
    [desData writeToFile:@"/Users/mac/Desktop/desdata.txt" atomically:YES];
    NSLog(@"DES加密：%@ data:%@",desBase64,desData);
    
    NSString *parameters = [NSString stringWithFormat:@"{\"data\":\"%@\",\"accountversion\":\"2\"}",desBase64];
    NSLog(@"json:\n%@",parameters);
    
    [self testLogin:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //解密
    //    NSString *decryptStr = [desBase64 desDecryptWithKey:key];
    //    NSData *data = [NSString desDecryptWithData:desData dataKey:keydata];
    //    NSLog(@"解密后：%@  ---  %@",decryptStr,data);
    
    
    
}

#pragma mark - 点击查询
- (IBAction)searchAction:(UIButton *)sender {
    [self saveSearchHis];
    if (chufadiSt.szm.length<1||mudidiSt.szm.length<1||!chufadiSt||!mudidiSt) {
        return;
    }
    SearchResVc *vc = (SearchResVc *)[self getVCInBoard:nil ID:@"SearchResVc"];
    NSString *str = [_chooeseDate.currentTitle stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    vc.preObjvalue = @[chufadiSt,mudidiSt,str,@(_dtdc.isOn),@(_xsp.isOn)];
    vc.xsp = _xsp.on;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)chudfadi:(UIButton *)sender {
    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"ChoeseStationVC"];
    vc.touchEvent = ^(id value){
        TrainStation *st = value;
        chufadiSt = st;
        
        [sender setTitle:st.name forState:UIControlStateNormal];
        NSLog(@"选择了:%@",st.name);
    };
    PUSH(vc);
    
    
}


- (IBAction)mudidi:(UIButton *)sender
{
    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"ChoeseStationVC"];
    vc.touchEvent = ^(id value){
        TrainStation *st = value;
        mudidiSt = st;
        
        [sender setTitle:st.name forState:UIControlStateNormal];
        NSLog(@"选择了:%@",st.name);
    };
    PUSH(vc);
}

- (IBAction)dateAction:(UIButton *)sender
{
    [self calendaer];
    
}

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
        NSString * tit = [NSString stringWithFormat:@"%lu年%02lu月%02lu日",(unsigned long)model.year,(unsigned long)model.month,model.day];
        _indexPath = indexPath_calender;
        
        [weakSelf.chooeseDate setTitle:tit forState:UIControlStateNormal];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        NSString * date_String = [NSString stringWithFormat:@"%lu-%02lu-%02lu",(unsigned long)model.year,(unsigned long)model.month,model.day];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * lastDate = [dateFormatter dateFromString:date_String];
        NSString *weekday = [self weekdayStringFromDate:lastDate];
        NSLog(@"今天是%@",weekday);
        _todayLable.text = weekday;
    };
     c.indexPath_calender = _indexPath;
    
    [self.navigationController pushViewController:c animated:YES];
}



#pragma mark 日历
-(void)showCalendaer{
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    view.layer.cornerRadius = 1;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    
//    NSInteger oneDay = 24*60*60*1;  //1天的长度
    NSInteger userDay = [[peizhiPar objectForKey:@"advance"] integerValue];
    NSInteger stuDay = [[peizhiPar objectForKey:@"student_advance"] integerValue];
    if (userDay==0 || stuDay==0) {
        userDay = 60;
        stuDay = 75;
    }
    NSInteger day  = userDay;
    if (self.xsp.on) {
        day = stuDay;
    }
    
    
    
    calender = [[CalenderView alloc]initWithFrame:CGRectMake(30, 50, SWIDTH-60, 400)  andMaxDays:(int)day];
    calender.layer.cornerRadius = 5;
    calender.clipsToBounds = YES;
    calender.height = calender.viewHeight;
    calender.centerY = view.centerY;
    __weak typeof(self) weakSelf = self;
    
    calender.getDate = ^(NSString *str){
        NSLog(@"%@",str);
        [weakSelf getSelectDate:str type:1];
        NSMutableString *tit = [NSMutableString stringWithString:str];
        [tit replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
        [tit replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
        [tit appendString:@"日"];
        
        [weakSelf.chooeseDate setTitle:tit forState:UIControlStateNormal];
    };
    [view addSubview:calender];
    
    
}
- (IBAction)gtdcswAction:(UISwitch *)sender {
    
}

- (IBAction)xspAction:(UISwitch *)sender {
    
}

- (IBAction)qiehuanAction:(UIButton *)sender {
    //    TrainStation *st = chufadiSt;
    //    chufadiSt = mudidiSt;
    //    mudidiSt = st;
    [self setStaionTtile];
    
}
- (IBAction)lishiClick:(id)sender
{
    UIButton *btn  = (UIButton *)sender;
    NSString *str = btn.currentTitle;
    if ([str isEqualToString:@"清除历史"]) {
        NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"searchHis.plist"];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [self setHis];
        
        return;
    }
    
    NSString *s1 = [str componentsSeparatedByString:@"-"].firstObject;
    NSString *s2 = [str componentsSeparatedByString:@"-"].lastObject;
    
    __block TrainStation *st11;
    __block  TrainStation *st22;
    
    [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:s1]) {
            st11 = obj;
        }
        if ([obj.name isEqualToString:s2]) {
            st22 = obj;
        }
    }];
    if (st11 && st22) {
        chufadiSt = st11;
        mudidiSt = st22;
        [_chufadiBtn setTitle:chufadiSt.name forState:UIControlStateNormal];
        [_mudidiBtn setTitle:mudidiSt.name forState:UIControlStateNormal];
        
    }
}

-(void)setStaionTtile{
    TrainStation *st1 = chufadiSt;
    
    chufadiSt = mudidiSt;
    mudidiSt = st1;
    [_chufadiBtn setTitle:chufadiSt.name forState:UIControlStateNormal];
    [_mudidiBtn setTitle:mudidiSt.name forState:UIControlStateNormal];
    
    //    [UIView animateWithDuration:0.5 animations:^{
    //
    //        CGFloat left = _chufadiBtn.left;
    //        _chufadiBtn.left = _mudidiBtn.left;
    //        _mudidiBtn.left = left;
    //    }];
    
    
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
    NSInteger userDay = [[peizhiPar objectForKey:@"advance"] integerValue];
    NSInteger stuDay = [[peizhiPar objectForKey:@"student_advance"] integerValue];
    if (userDay==0 || stuDay==0) {
        userDay = 60;
        stuDay = 75;
    }
    NSDate *theDate = [[NSDate date] initWithTimeIntervalSinceNow: +oneDay*userDay];
    if (self.xsp.isOn) {
        theDate = [[NSDate date] initWithTimeIntervalSinceNow: +oneDay*stuDay];
    }
    // 在今天之前的日期
    [_pikerView.datePickerView setMaximumDate:theDate];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    [_chooeseDate setTitle:date forState:UIControlStateNormal];
    NSDate *date2 = [AppManager dateFromString:date format:@"yyyy-MM-dd"];
    NSString *today = [AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSString *tomorrow = [AppManager stringFromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24] format:@"yyyy-MM-dd"];
    NSString *afterTom = [AppManager stringFromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*2] format:@"yyyy-MM-dd"];
    
   
    
    if ([date isEqualToString:today]) {
        _todayLable.text = @"今天";
    }else
        if ([date isEqualToString:tomorrow]) {
            _todayLable.text = @"明天";
        }else
            if ([date isEqualToString:afterTom]) {
                _todayLable.text = @"后天";
            }else
                _todayLable.text = [HomeViewController getWeekDayFordate:[date2 timeIntervalSince1970]];
    
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

#pragma mark - 获取基本从参数
-(void)getPar{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/getBase/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        peizhiPar = obj[@"data"];
        if (peizhiPar) {
            
            [[NSUserDefaults standardUserDefaults] setObject:peizhiPar forKey:@"peizhiPar"];
        }
        
    } andError:nil];
}


-(void)getStart{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/getGuide/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        
        NSString *url = obj[@"data"][@"imgurl"];
        //        if (url.length>1) {
        //            url = [url substringFromIndex:1];
        //        }
        [startImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrlIp,url]] placeholderImage:nil];
        linkurl = obj[@"data"][@"linkurl"];
        
        
    } andError:nil];
}

#pragma mark 轮播图
-(void)getAd{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/getAdvert/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        adInfo = obj[@"data"];
        [self setAdView:adInfo];
    } andError:nil];
    
}
-(void)getBaoxian{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/Insurance/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        baoxianInfo = obj[@"data"];
        
    } andError:nil];
}
-(void)adressInfo{
    NSString *str = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:@"addressinfo.plist"];
    //    NSLog(@"%@",[self parseJSONStringToNSDictionary:str]);
    
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/getRegion/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        adressInfo = obj[@"data"];
        [adressInfo writeToFile:str atomically:YES];
    } andError:nil];
}
///解析json字符串为字典
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
@end
