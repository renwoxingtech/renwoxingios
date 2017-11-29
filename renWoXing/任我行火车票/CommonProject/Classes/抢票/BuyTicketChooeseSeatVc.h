//
//  BuyTicketChooeseSeatVc.h
//  CommonProject
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BuyTicketChooeseSeatVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *shikebiao;
@property (weak, nonatomic) IBOutlet UILabel *chufadi;
@property (weak, nonatomic) IBOutlet UILabel *mudidi;
@property (weak, nonatomic) IBOutlet UILabel *chufashijian;
@property (weak, nonatomic) IBOutlet UILabel *daodashijian;
@property (weak, nonatomic) IBOutlet UILabel *lishi;
@property (weak, nonatomic) IBOutlet UILabel *checi;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *info1;
@property (weak, nonatomic) IBOutlet UIView *infobg1;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *info2;
@property (weak, nonatomic) IBOutlet UIView *infobg2;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *info3;
@property (weak, nonatomic) IBOutlet UIView *infobg3;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *info4;
@property (weak, nonatomic) IBOutlet UIView *infobg4;
@property (weak, nonatomic) IBOutlet UIButton *goumai4;
@property (weak, nonatomic) IBOutlet UIButton *goumai2;
@property (weak, nonatomic) IBOutlet UIButton *goumai3;
@property (weak, nonatomic) IBOutlet UIButton *goumai1;
- (IBAction)buysubact1:(UIButton *)sender;

@property (nonatomic,assign)BOOL isYuyue;
@property (nonatomic,assign)BOOL isGaiqian;

@end


