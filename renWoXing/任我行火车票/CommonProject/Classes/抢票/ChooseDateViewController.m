//
//  ChooseDateViewController.m
//  CommonProject
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChooseDateViewController.h"



@interface ChooseDateViewController ()
{
    NSMutableArray *dateArr;
}
@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择日期";
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font(14);
    [rightBtn addTarget:self action:@selector(ClickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    dateArr = [NSMutableArray array];
    self.selectDateArr = [NSMutableArray array];
    self.maxCount = 5;
    if (self.issingle) {
        self.maxCount = 1;
    }
    if (self.dateRange==0) {
        self.dateRange = 60;
    }

    NSDate *cur_date = [NSDate date];
    NSString *dateStr = [[NSUserDefaults standardUserDefaults]objectForKey:SelectRiqiKey];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@","];
    for (int i=0; i<self.dateRange; i++) {
        NSDate *newDate = [cur_date dateByAddingTimeInterval:24*60*60*i];
        NSString *datestr1 = [AppManager stringFromDate:newDate format:@"yyyy-MM-dd"];
        NSString *datestr2 = [AppManager stringFromDate:newDate format:@"MM-dd"];

        DateObject *md = [[DateObject alloc]init];
        md.originalStr = datestr1;
        md.isSelect = NO;
        if (dateArray.count>1) {

            for (int j=0; j<dateArray.count; j++) {
                NSString *str = dateArray[j];
                if ([datestr1 isEqualToString:[str stringByReplacingOccurrencesOfString:@"," withString:@""]]) {
                    md.isSelect = YES;
                    [self.selectDateArr addObject:md];
                    continue;
                }
            }
        }

        md.showStr = datestr2;
        if (i==0) {
            md.showStr = @"今天";
        }else  if (i==1) {
            md.showStr = @"明天";
        }
        [self.mainDataSource addObject:md];
        
    }
    [self.mainTableView reloadData];
}

- (void)ClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *re4use = @"datecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:re4use];
    if (!cell ) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:re4use];
    }
    DateObject *obj = self.mainDataSource[indexPath.row];
    
    UILabel *l = [cell.contentView viewWithTag:2];
    l.text = obj.showStr;
    
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
    if (self.issingle) {
        for (DateObject *onj in self.mainDataSource) {
            onj.isSelect = NO;
        }
    }else{
        if (obj.isSelect) {

        }else{
        if (self.selectDateArr.count>=self.maxCount) {
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"您最多可以选择%ld个日期",(long)self.maxCount]];
            return;
        }
        }
    }


    obj.isSelect = !obj.isSelect;
    [self.selectDateArr removeAllObjects];
    for (DateObject *onj in self.mainDataSource) {
        if (onj.isSelect) {
            
            [self.selectDateArr addObject:onj];
        }
    }
    if (self.touchEvent) {
        self.touchEvent(self.selectDateArr);
    }
    [self.mainTableView reloadData];
    if (self.issingle) {
        POP;
    }
}

@end
