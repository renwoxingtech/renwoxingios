//
//  SelectTimeView.m
//  selectTime
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 zrgg. All rights reserved.
//

#import "SelectTimeView.h"

@interface SelectTimeView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *bgView;
    UIPickerView *pickHourView1;
    UIPickerView *pickHourView2;
    NSArray *dataSource;
    NSInteger minIndex;
    CGRect viewFrame;
}
@end

@implementation SelectTimeView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         minIndex = 0;
        viewFrame = frame;
        [self initTimeView];
    }
    return self;
}

- (void)initTimeView{
    dataSource = @[@[@"00:00",@"00:30",@"1:00",@"1:30",@"2:00",@"2:30",@"3:00",@"3:30",@"4:00",@"4:30",@"5:00",@"5:30",@"6:00",@"6:30",@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"],@[@"00:30",@"1:00",@"1:30",@"2:00",@"2:30",@"3:00",@"3:30",@"4:00",@"4:30",@"5:00",@"5:30",@"6:00",@"6:30",@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"]];
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewFrame),CGRectGetHeight(viewFrame))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];


    pickHourView1 = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 0, (bgView.frame.size.width-10*2-30)/2+15, bgView.frame.size.height)];
    pickHourView1.delegate = self;
    pickHourView1.dataSource = self;
    pickHourView1.tag = 1;
    [bgView addSubview:pickHourView1];



    pickHourView2 = [[UIPickerView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pickHourView1.frame), 0,  CGRectGetWidth(pickHourView1.frame), bgView.frame.size.height)];
    pickHourView2.delegate = self;
    pickHourView2.dataSource = self;
    pickHourView2.tag = 2;
    [bgView addSubview:pickHourView2];
    NSArray *arr = dataSource[1];
    [pickHourView2 selectRow:arr.count-1 inComponent:0 animated:YES];



    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(viewFrame)/2.0-15/2.0,  bgView.frame.size.height/2.0, 15, 1)];
    line1.backgroundColor = [UIColor blackColor];
    [bgView addSubview:line1];

}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *tempArr = dataSource[pickerView.tag-1];
    return tempArr.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *tempArr = dataSource[pickerView.tag-1];
    return tempArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag==1) {
        NSInteger otherRow=[pickHourView2 selectedRowInComponent:0];
        minIndex = row+1;
        if (otherRow<minIndex) {
            [pickHourView2 selectRow:minIndex inComponent:0 animated:YES];
        }
    }else{
        if (row<=minIndex) {
            
            [pickHourView2 selectRow:minIndex inComponent:0 animated:YES];
        }
    }
    if (_getSelectTimeStr) {
        NSInteger timeRow1=[pickHourView1 selectedRowInComponent:0];
        NSInteger timeRow2=[pickHourView2 selectedRowInComponent:0];
        _getSelectTimeStr(dataSource[0][timeRow1],dataSource[1][timeRow2]);
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
