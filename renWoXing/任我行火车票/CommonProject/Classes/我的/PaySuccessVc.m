//
//  PaySuccessVc.m
//  CommonProject
//
//  Created by mac on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PaySuccessVc.h"
#import "NormalOrderVc.h"
#import "OrderDetailAndPay.h"

@interface PaySuccessVc ()

@end

@implementation PaySuccessVc
-(void)awakeFromNib{
    [super awakeFromNib];
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.jixugp.layer.borderColor = BlueColor.CGColor;
    
    self.jixugp.layer.borderWidth = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)chakanAction:(UIButton *)sender {
    NormalOrderVc *vc = (NormalOrderVc *)[self getVCInBoard:@"Main" ID:@"NormalOrderVc"];
//    vc.orderid = self.orderid;
    vc.isQpdd = self.isQp;
    
    PUSH(vc);
}

- (IBAction)jixuAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
