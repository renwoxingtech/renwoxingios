//
//  RMCollectionCell.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCollectionCell.h"
#import "UIView+CustomFrame.h"
#import "RMCalendarModel.h"

#import "TicketModel.h"

#define kFont(x) [UIFont systemFontOfSize:x]
#define COLOR_HIGHLIGHT ([UIColor redColor])
#define COLOR_NOAML ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])

@interface RMCollectionCell()

/**
 *  显示日期
 */
@property (nonatomic, weak) UILabel *dayLabel;
/**
 *  显示农历
 */
@property (nonatomic, weak) UILabel *chineseCalendar;
/**
 *  选中的背景图片
 */
@property (nonatomic, weak) UIImageView *selectImageView;
/**
 *  票价   此处可根据项目需求自行修改
 */
@property (nonatomic, weak) UILabel *price;

@property(nonatomic,weak)UILabel * shakedown_Label;


@end

@implementation RMCollectionCell

+ (void)initialize{
  
}

- (int)getDate:(NSString *)betweenDateString{
    //获取日期格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //获取当前的日期
    NSDate * dateNow_Date = [NSDate date];
    
    NSCalendar * calender2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calender2 setFirstWeekday:2];
    //获取30天后的日期
    NSDateComponents * adcomps = [[NSDateComponents alloc]init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:29];
    NSDate * futureDate_Date = [calender2 dateByAddingComponents:adcomps toDate:dateNow_Date options:0];
    //获取60天后的日期
    NSDateComponents * twoMonth = [[NSDateComponents alloc]init];
    [twoMonth setYear:0];
    [twoMonth setMonth:0];
    [twoMonth setDay:59];
    NSDate * twoMonth_Date = [calender2 dateByAddingComponents:twoMonth toDate:dateNow_Date options:0];
    //获取30-60天之间的日期
    NSDate * between_Date = [formatter dateFromString:betweenDateString];
    NSComparisonResult result = [between_Date compare:futureDate_Date];
    
    
    NSComparisonResult result_between = [twoMonth_Date compare:between_Date];
    if (result == NSOrderedDescending && result_between == NSOrderedDescending)
    {
        return 1;
    }
    else{
        return 0;
    }
    
    
    //获取30天后的日期字符串
//    NSString * now = [formatter stringFromDate:futureDate_Date];
    
    //获取当前的日期字符串
//    NSString * newDay = [formatter stringFromDate:dateNow_Date];
    
    /* 我删除的
    if (result == NSOrderedDescending) {
        return 1 ;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
     */
 
}


- (nonnull instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initCellView];
    return self;
}

- (void)initCellView {
    
    //选中时显示的图片
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    selectImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue"]];
    self.selectImageView = selectImageView;
    [self addSubview:selectImageView];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.width, 20)];
    dayLabel.font = [UIFont mysystemFontOfSize:14];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel = dayLabel;
//    dayLabel.backgroundColor = [UIColor redColor];
    [self addSubview:dayLabel];
    
    UILabel *chineseCalendar = [[UILabel alloc] initWithFrame:CGRectMake(dayLabel.left, dayLabel.bottom, self.width, 10)];
    chineseCalendar.font = [UIFont mysystemFontOfSize:9];
    chineseCalendar.textAlignment = NSTextAlignmentCenter;
    self.chineseCalendar = chineseCalendar;
    [self addSubview:chineseCalendar];
    
    UILabel * shakedown_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, chineseCalendar.bottom, self.width, 20)];
    shakedown_Label.text = @"抢票";
    shakedown_Label.textColor = OrangeColor;
    shakedown_Label.font = [UIFont mysystemFontOfSize:10];
    shakedown_Label.textAlignment = NSTextAlignmentCenter;
    self.shakedown_Label = shakedown_Label;
    [self addSubview:shakedown_Label];
    
// 价格Label 可根据需求修改
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, dayLabel.height, self.bounds.size.width, dayLabel.height)];
    price.font = kFont(9);
    price.textAlignment = NSTextAlignmentCenter;
    self.price = price;
    [self addSubview:price];
}

- (void)setModel:(RMCalendarModel *)model {
    _model = model;
    //没有剩余票数
    if (!model.ticketModel.ticketCount || model.style == CellDayTypePast) {
        self.price.hidden = YES;
        model.isEnable ? model.style : model.style != CellDayTypeEmpty ? model.style = CellDayTypePast : model.style;
    } else {
        self.price.hidden = NO;
        self.price.textColor = [UIColor orangeColor];
        self.price.text = [NSString stringWithFormat:@"￥%.1f",model.ticketModel.ticketPrice];
    }
    self.chineseCalendar.text = model.Chinese_calendar;
    self.chineseCalendar.hidden = NO;
    /**
     *  如果不展示农历，则日期居中
     */
    if (!model.isChineseCalendar) {
//        self.dayLabel.x = 1;
//        self.dayLabel.width = self.width - 1;
//        self.dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    NSString * dateString = [NSString stringWithFormat:@"%lu-%02lu-%02lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day];
    
    switch (model.style) {
        case CellDayTypeEmpty:
            self.selectImageView.hidden = YES;
            self.dayLabel.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            self.chineseCalendar.hidden = YES;
            self.shakedown_Label.hidden = YES;
            break;
        case CellDayTypePast:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.shakedown_Label.hidden = YES;
            if (model.holiday) {
                self.chineseCalendar.text = model.holiday;
                self.dayLabel.width = self.bounds.size.width;
//                self.chineseCalendar.hidden = ;
            }
//            else {
                self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
//            }
            self.chineseCalendar.textColor = [UIColor lightGrayColor];
            self.dayLabel.textColor = [UIColor lightGrayColor];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarDisableDate"]];
            break;
            
        case CellDayTypeWeek:
            // 以下内容暂时无用  将来可以设置 周六 日 特殊颜色时 可用
//            self.dayLabel.hidden = NO;
//            self.selectImageView.hidden = YES;
//            if (model.holiday) {
//                self.dayLabel.text = model.holiday;
//                self.dayLabel.textColor = COLOR_HIGHLIGHT;
//            } else {
//                self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
//                self.dayLabel.textColor = COLOR_NOAML;
//            }
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
//            self.chineseCalendar.textColor = [UIColor blackColor];
//            break;
            
        case CellDayTypeFutur:{
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            
            int result = [self getDate:dateString];
            if (result == 1) {
                self.shakedown_Label.hidden = NO;
            }
            else{
                self.shakedown_Label.hidden = YES;
            }
            if (model.holiday) {
                self.chineseCalendar.text = model.holiday;
            }

            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = zhangColor;
            self.chineseCalendar.textColor = zhangColor;
            break;
        }
        case CellDayTypeClick:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = NO;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor whiteColor];
            self.price.textColor = [UIColor whiteColor];
            self.chineseCalendar.textColor = [UIColor whiteColor];
            int result = [self getDate:dateString];
            if (result == 1) {
                self.shakedown_Label.hidden = NO;
            }
            else{
                self.shakedown_Label.hidden = YES;
            }
            if (model.holiday) {
                self.chineseCalendar.text = model.holiday;
            }
            break;
        default:
            break;
    }
    
}

@end
