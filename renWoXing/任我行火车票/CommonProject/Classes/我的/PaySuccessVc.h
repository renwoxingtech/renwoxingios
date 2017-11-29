//
//  PaySuccessVc.h
//  CommonProject
//
//  Created by mac on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//
#import "BaseViewController.h"


@interface PaySuccessVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *chakan;
@property (weak, nonatomic) IBOutlet UIButton *jixugp;
- (IBAction)chakanAction:(UIButton *)sender;

- (IBAction)jixuAction:(UIButton *)sender;
@property (nonatomic,assign)NSInteger isQp;
@property(nonatomic,copy)NSString * orderid;

@end
