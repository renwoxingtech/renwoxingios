//
//  PayView.h
//  CommonProject
//
//  Created by mac on 2017/1/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayView : UIView
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topBiew;
@property (weak, nonatomic) IBOutlet UILabel *chepiaoL;
@property (weak, nonatomic) IBOutlet UILabel *baoxiaonL;
@property (weak, nonatomic) IBOutlet UILabel *chepiaoPrice;
@property (weak, nonatomic) IBOutlet UILabel *baoxianPrice;
@property (weak, nonatomic) IBOutlet UILabel *peisongfei;
@property (weak, nonatomic) IBOutlet UILabel *shouxufei;
@property (strong, nonatomic) IBOutlet UILabel *vipLable;
@property (strong, nonatomic) IBOutlet UIImageView *jianTou_ImageView;

@end
