//
//  DZXZVc.h
//  CommonProject
//
//  Created by gaoguangxiao on 2017/1/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface DZXZVc : BaseViewController
@property (weak, nonatomic) IBOutlet IBView *chengkeView;
@property (weak, nonatomic) IBOutlet UIButton *chufadi;
@property (weak, nonatomic) IBOutlet UIButton *mudidi;
@property (weak, nonatomic) IBOutlet UIButton *qiehuan;
@property (weak, nonatomic) IBOutlet UIButton *riqiBtn;
@property (weak, nonatomic) IBOutlet UIButton *checiBtn;
@property (weak, nonatomic) IBOutlet UIButton *leixing;
@property (weak, nonatomic) IBOutlet UIButton *tjck;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScView;
@property (weak, nonatomic) IBOutlet UIButton *xiayibu;
- (IBAction)delete:(UIButton *)sender;
@property (nonatomic,assign)NSInteger from;//1 2 3 坐席定制的三个   为这三个时里面的为单选  4 12306的抢票  5人工的抢票
//   6快递到家   7私人订制  
@property(nonatomic,copy)NSString *buyedZuowei;
@property(nonatomic,copy)NSString *buyedZuoweiCode;
@property(nonatomic,copy)NSString *buyedPrice;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *duoxuanBtns;

@end
