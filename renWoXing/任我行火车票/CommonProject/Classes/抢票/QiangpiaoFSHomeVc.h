//
//  QiangpiaoFSHomeVc.h
//  CommonProject
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface QiangpiaoFSHomeVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *qp12306;
@property (weak, nonatomic) IBOutlet UIButton *qprengong;
@property (weak, nonatomic) IBOutlet IBView *view2;
@property (weak, nonatomic) IBOutlet IBView *view1;
- (IBAction)qp12306Act:(UIButton *)sender;
- (IBAction)rgact:(UIButton *)sender;
@property(nonatomic,copy)NSString * buyedZuowei;
/**
 *   票价
 */
@property(nonatomic,copy)NSString * buyedPrice;
/**
 *   坐席类型
 */
@property(nonatomic,copy)NSString * buyedZuoweiCode;
@end
