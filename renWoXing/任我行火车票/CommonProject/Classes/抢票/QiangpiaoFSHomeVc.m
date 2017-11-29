//
//  QiangpiaoFSHomeVc.m
//  CommonProject
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "QiangpiaoFSHomeVc.h"
#import "DZXZVc.h"

@interface QiangpiaoFSHomeVc ()

@end

@implementation QiangpiaoFSHomeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"抢票";
    
    
    //使scrollview可以上下滑动
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]] && ![obj isKindOfClass:[UITableView class]]) {
            UIScrollView *sc = obj;
            UIView *v = sc.subviews.lastObject;
            CGFloat h = v.bottom+90;
            if (h<sc.height) {
                h = sc.height+1;
            }
            sc.contentSize = CGSizeMake(sc.width, h);
        }
    }];

}


#pragma mark 点击12306抢票
- (IBAction)qp12306Act:(UIButton *)sender {
    DZXZVc *vc = (DZXZVc *)[self getVCInBoard:nil ID:@"DZXZVc"];
    vc.from = 4;
    vc.preObjvalue = self.preObjvalue;
    vc.buyedZuowei = self.buyedZuowei;
    vc.buyedPrice = self.buyedPrice;
    vc.buyedZuoweiCode = self.buyedZuoweiCode;
    vc.title = @"添加12306抢票任务";
    PUSH(vc);
}

#pragma mark 点击添加人工抢票任务
- (IBAction)rgact:(UIButton *)sender {
    DZXZVc *vc = (DZXZVc *)[self getVCInBoard:nil ID:@"DZXZVc"];
    vc.from = 5;
    vc.buyedZuowei = self.buyedZuowei;
    vc.preObjvalue = self.preObjvalue;
    vc.buyedPrice = self.buyedPrice;
    vc.buyedZuoweiCode = self.buyedZuoweiCode;
    vc.title = @"添加人工抢票任务";
    PUSH(vc);
    
}
@end
