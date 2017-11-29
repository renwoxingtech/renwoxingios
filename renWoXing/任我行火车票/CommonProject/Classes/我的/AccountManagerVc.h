//
//  AccountManagerVc.h
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountManagerVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UIButton *jiebang;
- (IBAction)jiebangAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *gerenzil;
- (IBAction)grzlact:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *peisongxinxi;
- (IBAction)peisact:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *xiugaimima;
- (IBAction)changpwdAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *tuichu;

@end
