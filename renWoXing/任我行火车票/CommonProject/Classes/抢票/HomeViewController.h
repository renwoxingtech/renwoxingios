//
//  HomeViewController.h
//  CommonProject
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//



@interface HomeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *bgScollView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet IBView *chbgView;
- (IBAction)searchAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *chufadiBtn;
@property (weak, nonatomic) IBOutlet UIButton *mudidiBtn;
@property (weak, nonatomic) IBOutlet UILabel *todayLable;
@property (weak, nonatomic) IBOutlet UIButton *qiehuanBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *lishiSc;

@property (weak, nonatomic) IBOutlet IBView *choosebgView;
@property (weak, nonatomic) IBOutlet UIButton *chooeseDate;
- (IBAction)dateAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *dtdc;
- (IBAction)gtdcswAction:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *xsp;
- (IBAction)xspAction:(UISwitch *)sender;
- (IBAction)qiehuanAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *rightIndi;

@end
