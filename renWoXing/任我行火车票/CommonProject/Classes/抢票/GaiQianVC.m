//
//  GaiQianVC.m
//  CommonProject
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GaiQianVC.h"
#import "CalenderView.h"
#import "SearchResVc.h"
#import "RMCalendarController.h"//日历

@interface GaiQianVC ()
{
    CalenderView *calender;
    NSString *dayStr;
  NSString *dayday;
    TrainStation *chufadiSt;
    TrainStation *mudidiSt;
    NSIndexPath * _indexPath;
    
}
@end

@implementation GaiQianVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [calender.superview removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"改签/变更到站";
    [_stateInfoBtn setTitle:_daodaStr forState:0];
   [self initStation];
    [self.stationArr enumerateObjectsUsingBlock:^(TrainStation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.szm isEqualToString:_chufaStrCode]) {
            chufadiSt = obj;
        }
        if ([obj.szm isEqualToString:_daodaStrCode]) {
            mudidiSt = obj;
        }
    }];
    
    NSLog(@"%@   %@",chufadiSt.name,mudidiSt.name);
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    dayday = [fmt stringFromDate:date];
    NSMutableString *tit = [NSMutableString stringWithString:dayday];
    [tit replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [tit replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    [tit appendString:@"日"];

    [_dateBtn setTitle:[NSString stringWithFormat:@"%@ 今天",tit] forState:UIControlStateNormal];
}

- (void)getSelectDate:(NSString *)date type:(NSInteger)type {
    NSString *today = [AppManager stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSString *tomorrow = [AppManager stringFromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24] format:@"yyyy-MM-dd"];
    NSString *afterTom = [AppManager stringFromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*2] format:@"yyyy-MM-dd"];
     dayStr = @"";
    if ([date isEqualToString:today]) {
        dayStr = @"今天";
    }else
        if ([date isEqualToString:tomorrow]) {
            dayStr = @"明天";
        }else
            if ([date isEqualToString:afterTom]) {
                dayStr = @"后天";
            };
            NSMutableString *tit = [NSMutableString stringWithString:date];
            [tit replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
            [tit replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
            [tit appendString:@"日"];

    [_dateBtn setTitle:[NSString stringWithFormat:@"%@ %@",tit,dayStr] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeStateInfoAction:(UIButton *)sender {
    BaseViewController *vc = (BaseViewController *)[self getVCInBoard:nil ID:@"ChoeseStationVC"];
    vc.touchEvent = ^(id value){
        TrainStation *st = value;
        mudidiSt = st;
        [sender setTitle:st.name forState:UIControlStateNormal];
        NSLog(@"选择了:%@",st.name);
    };
    PUSH(vc);
}

- (IBAction)changeDateAction:(UIButton *)sender {
    [self calendaer];
    /*UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
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
    calender = [[CalenderView alloc]initWithFrame:CGRectMake(30, 50, SWIDTH-60, 400)  andMaxDays:(int)day];
    calender.layer.cornerRadius = 5;
    calender.clipsToBounds = YES;
    calender.height = calender.viewHeight;
    calender.centerY = view.centerY;
    __weak typeof(self) weakSelf = self;

    calender.getDate = ^(NSString *str){
        NSLog(@"%@",str);
        dayday = str;
        [weakSelf getSelectDate:str type:1];
    };
    [view addSubview:calender];*/
}

- (IBAction)gaiqianAction:(UIButton *)sender {
     [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:SelectCheCiKey];
    NSString *str = [dayday stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    SearchResVc *vc = (SearchResVc *)[self getVCInBoard:nil ID:@"SearchResVc"];
    vc.preObjvalue = @[chufadiSt,mudidiSt,str,@(0),@(1)];
    vc.xsp = 1;
    vc.from =  6;
    vc.orderID = self.orderID;
    vc.orderURL = self.orderURL;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 日历
- (void)calendaer{
    // CalendarShowTypeMultiple 显示多月
    // CalendarShowTypeSingle   显示单月
    RMCalendarController *c = [RMCalendarController calendarWithDays:60 showType:CalendarShowTypeMultiple];
//    __weak typeof(self) weakSelf = self;
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
        NSString * tit = [NSString stringWithFormat:@"%lu年%02lu月%02lu日",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day];
        _indexPath = indexPath_calender;
        dayday = tit;
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        NSString * date_String = [NSString stringWithFormat:@"%lu-%02lu-%02lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * lastDate = [dateFormatter dateFromString:date_String];
        NSString *weekday = [self weekdayStringFromDate:lastDate];
        NSLog(@"今天是%@",weekday);
         [_dateBtn setTitle:[NSString stringWithFormat:@"%@ %@",tit,weekday] forState:UIControlStateNormal];
    };
    c.indexPath_calender = _indexPath;
    
    [self.navigationController pushViewController:c animated:YES];
}




@end
