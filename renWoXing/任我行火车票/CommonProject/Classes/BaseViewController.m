//
//  BaseViewController.m
//  CommonProject
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

#import "NSString+Hash.h"
#import "CocoaSecurity.h"
#import "NSString+Encryption.h"
#import "RSA.h"
#import "BHUD.h"


@interface BaseViewController ()<MBProgressHUDDelegate>
{
    UITapGestureRecognizer *tap ;
}
@property(nonatomic,strong)MBProgressHUD * HUD;
@end

@implementation BaseViewController

#pragma mark 获取星期
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六",nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.automatsicallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    __weak typeof(self) weakSelf = self;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshHeaderData];
        
    }]; 
    self.mainTableView.tableFooterView = [[UIView alloc]init];
    
    self.page = 1;

    _needTap = YES;


    self.mainDataSource  = [NSMutableArray array];
    
    [self loadNetData];
}
-(void)setNeedTap:(BOOL)needTap{
    _needTap  = needTap;
    if (!_needTap) {
        [self.view removeGestureRecognizer:tap];
    }
}
-(void)refreshHeaderData{
    self.page = 1;
    [self loadNetData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.mainTableView.mj_header isRefreshing]) {
            [self.mainTableView.mj_header endRefreshing];
            
        }
        if ([self.mainTableView.mj_footer isRefreshing]) {
            [self.mainTableView.mj_footer endRefreshing];
            
        }
    });
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}
-(void)endE:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
-(NSMutableArray *)mainDataSource{
    if (!_mainDataSource) {
        _mainDataSource = [NSMutableArray array];
    }
    return _mainDataSource;
    
}

-(BOOL)hidesBottomBarWhenPushed{
    
    if ([self isKindOfClass:NSClassFromString(@"HomeViewController")] || [self isKindOfClass:NSClassFromString(@"WodeViewController")] ||[self isKindOfClass:NSClassFromString(@"ZuoXiDZHome")] ||[self isKindOfClass:NSClassFromString(@"QiangpiaoFSHomeVc")] ) {
        return NO;
    }else{
        return YES;
    }
}
-(UIViewController *)getVCInBoard:(NSString *)bord ID:(NSString *)idd{
    @try {
        if (!bord) {
            bord = @"Main";
        }
        UIStoryboard *story = [UIStoryboard storyboardWithName:bord bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:idd];
        
        return vc;
        
    } @catch (NSException *exception) {
        NSLog(@"无对应的控制器board  %@ ,identify:%@",bord,idd);
        return [[UIViewController alloc]init];
    } @finally {
        
    }
    
}
-(void)loadNetData{
    
}


#pragma mark - 自定义方法

//返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.view endEditing:YES];
    if ([BHUD isWorking]) {
        [BHUD dismissHud];
    }
    [[LoadingView shareMsgHud] hideLoadHudAnimation];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSDictionary *)getparametersWithDic:(NSDictionary *)pardic{
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    for (NSString *key in pardic.allKeys) {
        par[key] = pardic[key];
    }

    NSString *lastStr = @"";

    NSArray *allK = par.allKeys;
    NSArray *resultArray = [allK sortedArrayUsingSelector:@selector(compare:)];

    for (NSString *key in resultArray) {
        if (![par[key] isKindOfClass:[NSArray class]]) {

            lastStr = [lastStr stringByAppendingFormat:@"%@=%@&",key,par[key]];
        }
    }
    if (lastStr.length>2) {
        lastStr = [lastStr substringToIndex:lastStr.length-1];
    }



    NSString *SN = [NSString stringWithFormat:@"%@&key=%@",lastStr,APIKEY];
    NSString *SNMD5 = SN.md5Hash;


    par[@"SN"]  = [AppManager md5To16:SNMD5];
    
    NSDictionary *postPar = @{@"data":[par mj_JSONString]};

    return postPar;
}

-(void)initStation{
    self.stationArr = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"all_stations" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        NSArray *all = [str componentsSeparatedByString:@"@"];
        
        for (NSString *str  in all) {
            NSArray *tmp = [str componentsSeparatedByString:@"|"];
            /*
             bjb,
             北京北,
             VAP,
             beijingbei,
             bjb,
             0
             */
            TrainStation *station = [[TrainStation alloc]init];
            station.code = tmp[0];
            station.name = tmp[1];
            station.szm = tmp[2];
            station.pinyin = tmp[3];
            //            station.pinyinStr = [self chineseToPinyin:station.name];
            [_stationArr addObject:station];
        }
        
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    [_stationArr sortUsingDescriptors:sortDescriptors];
    
    
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

- (void)textFieldDone{
    [self.view endEditing:YES];
}

#pragma mark 判断字符串是否为空,为空就走这个方法,不为空就不走
- (BOOL)isNoBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

#pragma mark 自定义动画
- (void)CustomButtonAction{
    
    //自定义view
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //取消背景框
    self.HUD.color = [UIColor whiteColor];
    [self.view addSubview:_HUD];
     UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 83)];
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for(int i = 1; i < 25 ; i++){
        NSString *imgName = [NSString stringWithFormat:@"loading%d",i];
        
        [imageArray addObject:[UIImage imageNamed:imgName]];
    }
    images.animationDuration = 0.7;
    
    images.animationImages = imageArray;
    // 开始播放
    [images startAnimating];
    
    //自定义
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.delegate = self;
    _HUD.customView = images;
    [_HUD show:YES];
    //延迟
    [_HUD hide:YES afterDelay:2];
    
}

- (void)creatLoadingView{
    
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    UIView * bgShowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    bgShowView.center = self.view.center;
    bgShowView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
    [window addSubview:bgShowView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 83,84)];
    [bgShowView addSubview:imageView];
    imageView.center = CGPointMake(50, 50);
    
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int i = 1; i < 25; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
        [imageArray addObject:image];
    }
    imageView.animationImages = imageArray;
    imageView.animationDuration = 6 * 0.15;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
}


@end
