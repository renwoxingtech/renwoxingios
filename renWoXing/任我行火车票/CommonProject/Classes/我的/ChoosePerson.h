//
//  ChoosePerson.h
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface ChoosePerson : BaseViewController
- (IBAction)addconAct:(UIButton *)sender;
@property (nonatomic,assign)BOOL ischoose12306;
@property (nonatomic,assign)BOOL ischooserx;
@property (nonatomic,assign)BOOL is12306Lianxr;
@property (nonatomic , assign) BOOL isWoTo12306L;
@property (weak, nonatomic) IBOutlet UIButton *zhanghaoBtn;
- (IBAction)zhact:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet IBView *bottomView;
@property(nonatomic,strong)NSMutableArray * customerArray;

@end
@interface ChengCheren : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cktype;
@property (weak, nonatomic) IBOutlet UILabel *zjlx;
@property (weak, nonatomic) IBOutlet UIButton *choose;



@end
