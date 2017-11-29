//
//  ChooseSeatTypeVc.m
//  CommonProject
//
//  Created by mac on 2017/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChooseSeatTypeVc.h"

@interface ChooseSeatTypeVc ()
{
    
    
}
@end

@implementation ChooseSeatTypeVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择坐席";
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font(14);
    [rightBtn addTarget:self action:@selector(ClickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.selectTypeArr = [NSMutableArray array];
    self.maxCount = 5;
    if (self.issingle) {
        self.maxCount = 1;
    }
    NSArray *nameArr= @[@"商务座",@"一等座",@"二等座",@"软卧",@"软座",@"硬卧",@"硬座"];
    NSArray *codeArr= @[@"swz",@"ydz",@"edz",@"rw",@"rz",@"yw",@"yz"];
    NSString *type = [[NSUserDefaults standardUserDefaults]objectForKey:SelectZXKey];
    NSArray *arr = [type componentsSeparatedByString:@","];
    if (self.haveTypeArr.count>0) {
        nameArr = self.haveTypeArr;
        for (int i=0; i<nameArr.count; i++) {
            SeatType *type = [[SeatType alloc]init];
            type.name = nameArr[i];
            type.isSelect = NO;
            for (int j=0; j<arr.count; j++) {
                NSString *typ = arr[j];
                if ([type.name isEqualToString:[typ stringByReplacingOccurrencesOfString:@"," withString:@""]]) {
                    type.isSelect = YES;
                    continue;
                }
            }
            type.type_name = [self pinyincodeWithName:nameArr[i]];
            [self.mainDataSource addObject:type];
            
            
            
        }
    }else{
        for (int i=0; i<nameArr.count; i++) {
            SeatType *type = [[SeatType alloc]init];
            type.name = nameArr[i];
            type.isSelect = NO;
            for (int j=0; j<arr.count; j++) {
                NSString *typ = arr[j];
                if ([type.name isEqualToString:[typ stringByReplacingOccurrencesOfString:@"," withString:@""]]) {
                    type.isSelect = YES;
                    continue;
                }
            }
            type.type_name = codeArr[i];
            [self.mainDataSource addObject:type];
        }
        
    }
    [self.mainTableView reloadData];
}

- (void)ClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)pinyincodeWithName:(NSString *)name{
    NSString *pinyin = @"";

    if ([name isEqualToString:@"商务座"]) {
        pinyin = @"swz";
    }else if ([name isEqualToString:@"一等座"]) {
        pinyin = @"ydz";
    }else if ([name isEqualToString:@"二等座"]) {
        pinyin = @"edz";
    }else if ([name isEqualToString:@"特等座"]) {
        pinyin = @"tdz";
    }else if ([name isEqualToString:@"高级软卧"]) {
        pinyin = @"gjrw";
    }else if ([name isEqualToString:@"软卧"]) {
        pinyin = @"rw";
    }else if ([name isEqualToString:@"软座"]) {
        pinyin = @"rz";
    }else if ([name isEqualToString:@"硬卧"]) {
        pinyin = @"yw";
    }else if ([name isEqualToString:@"硬座"]) {
        pinyin = @"yz";
    }else if ([name isEqualToString:@"无座"]) {
        pinyin = @"wz";
    }
    return pinyin;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *re4use = @"seattype";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:re4use];
    if (!cell ) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:re4use];
    }
    SeatType *obj = self.mainDataSource[indexPath.row];
    
    UILabel *l = [cell.contentView viewWithTag:2];
    l.text = obj.name;
    
    UIButton *btn = [cell.contentView viewWithTag:1];
    btn.userInteractionEnabled = NO;
    if (obj.isSelect) {
        
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DateObject *obj = self.mainDataSource[indexPath.row];
    if (_issingle) {
         [self.selectTypeArr addObject:obj];
        if (self.touchEvent) {
            self.touchEvent(self.selectTypeArr);
        }
        POP;
        return;
    }else{
        
    }
    if (obj.isSelect) {
        
    }else
    if (self.selectTypeArr.count>=self.maxCount) {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"您最多可以选择%ld个座位类型",(long)self.maxCount]];
            return;
    }
    
    
    obj.isSelect = !obj.isSelect;
    [self.selectTypeArr removeAllObjects];
    for (SeatType *onj in self.mainDataSource) {
        if (onj.isSelect) {
            
            [self.selectTypeArr addObject:onj];
        }
    }
    if (self.touchEvent) {
        self.touchEvent(self.selectTypeArr);
    }
    
    [self.mainTableView reloadData];
    
}

//seattype

@end
