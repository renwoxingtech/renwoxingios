//
//  SubmitOrderVc.h
//  CommonProject
//
//  Created by gaoguangxiao on 2017/1/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface SubmitOrderVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorView;
- (IBAction)submitAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *zuoweijiageview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLab;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mudidi;
@property (weak, nonatomic) IBOutlet UILabel *chufashijian;
@property (weak, nonatomic) IBOutlet UILabel *daodashijian;
@property (weak, nonatomic) IBOutlet UILabel *facehtime;
@property (weak, nonatomic) IBOutlet UILabel *lishi;
@property (weak, nonatomic) IBOutlet UILabel *zuoxi;
@property (weak, nonatomic) IBOutlet UILabel *piaojia;
@property (weak, nonatomic) IBOutlet IBView *tjckbbjview;
@property (weak, nonatomic) IBOutlet IBView *cklistView;
- (IBAction)tjckAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *shijianView;
@property (weak, nonatomic) IBOutlet UIView *chengekexinxiView;//初始高度75
@property (weak, nonatomic) IBOutlet UIView *zuoweiView;
@property (weak, nonatomic) IBOutlet UIView *dibuView;
@property (weak, nonatomic) IBOutlet UILabel *checi;

- (IBAction)deleteck:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *zuowei1;
//- (IBAction)zuowei1act:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *zuowei2;
@property (weak, nonatomic) IBOutlet UIButton *zuowei2act;
@property (nonatomic,assign)BOOL is12306dingpiao;
@property (nonatomic,assign)BOOL issirendingzhi;
@property (nonatomic,assign)BOOL isspsm;///快递到家
- (IBAction)qupiao:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *shoujianxixi;
- (IBAction)shoujianact:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *qupiaofangshi;
@property (weak, nonatomic) IBOutlet UITextField *shoujihao;
@property (weak, nonatomic) IBOutlet UITextField *zxddField;
//baoxianlable
@property (weak, nonatomic) IBOutlet UIButton *baoxian_Btn;




@property(nonatomic,copy)NSString *buyedZuowei;
@property(nonatomic,copy)NSString *buyedZuoweiCode;//当前买的席位的字符标志，带_price
@property(nonatomic,copy)NSString *buyedPrice;
@property(nonatomic,retain)NSMutableArray <Customer *>*selectedCustomer;
@property(nonatomic,assign)BOOL isGaiqian;
@property(nonatomic,assign)NSInteger type;
@end
