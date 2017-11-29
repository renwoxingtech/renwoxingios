//
//  FeedbackHistoryVc.m
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FeedbackHistoryVc.h"

@interface FeedbackHistoryVc ()

@end

@implementation FeedbackHistoryVc

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navBar.hidden = NO;
    self.title = @"我的历史反馈";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resue = @"bughis";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resue];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resue];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    
    return cell;
}


@end
