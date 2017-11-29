//
//  ChangyongPsvc.h
//  CommonProject
//
//  Created by mac on 2017/1/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangyongPsvc : BaseViewController
/**联系人*/
@property (weak, nonatomic) IBOutlet UITextField *lxr;
/**电话*/
@property (weak, nonatomic) IBOutlet UITextField *dh;
/**详细地址*/
@property (weak, nonatomic) IBOutlet UITextField *xxdz;
/**地址*/
@property (weak, nonatomic) IBOutlet UIButton *dz;
- (IBAction)dizhiact:(UIButton *)sender;
@property (nonatomic,assign)BOOL isfromChoose;

@end
