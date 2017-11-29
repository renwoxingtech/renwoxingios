//
//  SearchResVc.h
//  CommonProject
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

//#define MIN(a,b) return a>b?b:a


@interface SearchResVc : BaseViewController
//- (IBAction)backAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mudidi;
@property (weak, nonatomic) IBOutlet UIView *topbgV;
@property (weak, nonatomic) IBOutlet UIButton *qiehuan;
@property (weak, nonatomic) IBOutlet UIButton *qiehuanAction;
- (IBAction)qiehuanClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *preday;
- (IBAction)predayAction:(UIButton *)sender;
- (IBAction)dateAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet IBView *bglightV;

@property (nonatomic,assign)BOOL isFromDZ;//来源于坐席定制
@property (nonatomic,assign)BOOL issingle;//是否是单选
@property (nonatomic,assign)BOOL isputong;//是否只看普通车
@property (nonatomic,assign)NSInteger from;//1 2 3 坐席定制的三个   为这三个时里面的为单选  4 12306的抢票  5人工的抢票 6改签
@property (nonatomic,assign)NSInteger xsp;

@end



@interface ResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mudidi;
@property (weak, nonatomic) IBOutlet UILabel *chufashijian;
@property (weak, nonatomic) IBOutlet UILabel *daodashijian;
@property (weak, nonatomic) IBOutlet UILabel *lishi;
@property (weak, nonatomic) IBOutlet UILabel *checi;
@property (weak, nonatomic) IBOutlet UILabel *jiage;
@property (weak, nonatomic) IBOutlet UILabel *shuoming;
@property (weak, nonatomic) IBOutlet UILabel *zuowei1;
@property (weak, nonatomic) IBOutlet UILabel *zuowei2;
@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@property (weak, nonatomic) IBOutlet UILabel *zuowei3;
@property (weak, nonatomic) IBOutlet UILabel *zuowei4;
@property (strong, nonatomic) IBOutlet UILabel *robLabel1;
@property (strong, nonatomic) IBOutlet UILabel *robLabel2;
@property (strong, nonatomic) IBOutlet UILabel *robLabel3;
@property (strong, nonatomic) IBOutlet UILabel *robLabel4;

@end
