//
//  WodeViewController.h
//  CommonProject
//
//  Created by gaoguangxiao on 2017/1/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface WodeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIButton *putong;
@property (weak, nonatomic) IBOutlet UIButton *qiangpiao;
@property (weak, nonatomic) IBOutlet UIButton *shezhi;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *vieew2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIButton *name12306;
@property (nonatomic,strong)NSMutableArray *stationArr;
- (IBAction)qpdd:(UIButton *)sender;

@end
