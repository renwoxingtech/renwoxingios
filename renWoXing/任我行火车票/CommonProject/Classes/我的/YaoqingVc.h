//
//  YaoqingVc.h
//  CommonProject
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface YaoqingVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *erweima;
@property (weak, nonatomic) IBOutlet UILabel *yaoqingma;
@property (weak, nonatomic) IBOutlet UIButton *tixian;
@property (weak, nonatomic) IBOutlet UILabel *yue;

@end

@interface YaoqingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zhanghao;
@property (weak, nonatomic) IBOutlet UILabel *fanlijine;
@property (weak, nonatomic) IBOutlet UILabel *shijian;

@end
