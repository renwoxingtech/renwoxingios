//
//  NormalOrderVc.h
//  CommonProject
//
//  Created by mac on 2017/2/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface QPOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mudidi;
@property (weak, nonatomic) IBOutlet UIButton *chakan;

@property (weak, nonatomic) IBOutlet UILabel *chufariqi;
@property (weak, nonatomic) IBOutlet UILabel *checi;
@property (weak, nonatomic) IBOutlet UILabel *zuoxi;
@property (weak, nonatomic) IBOutlet UILabel *qpxinxi;

@property (weak, nonatomic) IBOutlet UILabel *qpjieguo;

@property (weak, nonatomic) IBOutlet UILabel *oriderid;
@end


@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *checi;
@property (weak, nonatomic) IBOutlet UILabel *shijian;
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mididdi;
@property (weak, nonatomic) IBOutlet UILabel *chengke;
@property (weak, nonatomic) IBOutlet UIButton *quxiaobtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuangtaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *zuoxi;
@property (weak, nonatomic) IBOutlet UILabel *dingdanID;

@property (weak, nonatomic) IBOutlet UIButton *zfbtn;
@end


@interface NormalOrderVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *taggbgView;
@property (weak, nonatomic) IBOutlet UILabel *tiplable;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *tagbggo;
@property (weak, nonatomic) IBOutlet UIView *titlebggo;
@property (weak, nonatomic) IBOutlet UIButton *renxingddbtn;
@property (weak, nonatomic) IBOutlet UIButton *ddbtn12306;
@property (weak, nonatomic) IBOutlet UIView *topbgv;
@property (weak, nonatomic) IBOutlet UIButton *qbdd;
@property (weak, nonatomic) IBOutlet UIButton *yzfdd;
@property (weak, nonatomic) IBOutlet UIButton *wzfdd;
- (IBAction)titlebtnclick:(UIButton *)sender;
@property (nonatomic,assign)BOOL isQpdd;
@end
