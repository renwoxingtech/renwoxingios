//
//  OrderDetailAndPay.h
//  CommonProject
//
//  Created by mac on 2017/2/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import "WXApi.h"
#import "NormalOrderVc.h"

@interface OrderDetailAndPay : BaseViewController<WXApiDelegate>

@property (nonatomic,retain)OrderData *orderData;
@property (nonatomic , copy)NSString *zhuangtai;
@property (nonatomic,copy)NSString *tuipiaoUrl;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *orderid;

@property (weak, nonatomic) IBOutlet UIImageView *indicatorView;

@property (weak, nonatomic) IBOutlet UILabel *shengyuLab;
@property (weak, nonatomic) IBOutlet UILabel *checi;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mudidi;
@property (weak, nonatomic) IBOutlet UILabel *chufashijian;
@property (weak, nonatomic) IBOutlet UILabel *daodashijian;
@property (weak, nonatomic) IBOutlet UILabel *facehtime;
@property (weak, nonatomic) IBOutlet UILabel *lishi;
@property (weak, nonatomic) IBOutlet UILabel *baoxianlable;
@property (weak, nonatomic) IBOutlet UIView *baoxianview;
@property (weak, nonatomic) IBOutlet UISwitch *baoxianSwitch;
@property (weak, nonatomic) IBOutlet UILabel *tiplable;
@property (retain, nonatomic) QPOrderCell  *orderCellView;
@property (weak, nonatomic) IBOutlet UILabel *shoujianren;
@property (weak, nonatomic) IBOutlet UILabel *shoujihao;
@property (weak, nonatomic) IBOutlet UILabel *peisongdizhi;
@property (weak, nonatomic) IBOutlet UILabel *tlyiwaixian;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, assign)  BOOL isGaiqian;
@property(nonatomic,assign) NSInteger type;


@end


@interface PersonOrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *numbern_id;
@property (weak, nonatomic) IBOutlet UILabel *zhengjianleixing;
@property (weak, nonatomic) IBOutlet UILabel *persontype;
@property (weak, nonatomic) IBOutlet UILabel *zauweixinxi;
@property (weak, nonatomic) IBOutlet UILabel *jiage;
@property (weak, nonatomic) IBOutlet UIButton *tuipiaobtn;
@property (weak, nonatomic) IBOutlet UILabel *zhaungtai;

@property (weak, nonatomic) IBOutlet UIButton *gaiqianBtn;
@property (weak, nonatomic) IBOutlet UILabel *yiwaixian;

@property (weak, nonatomic) IBOutlet UIButton *zhuangTaiBtn;



@end











