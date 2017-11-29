//
//  AddPersonVc.h
//  CommonProject
//
//  Created by mac on 2017/1/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface AddPersonVc : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *leixingBtn;
@property (weak, nonatomic) IBOutlet UITextField *namefield;
@property (weak, nonatomic) IBOutlet UIButton *zhengjianlxbtn;
@property (weak, nonatomic) IBOutlet UITextField *zhengjiannumfield;
@property (weak, nonatomic) IBOutlet UILabel *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *heyanlable;
@property (weak, nonatomic) IBOutlet UIView *addimgBgview;
@property (weak, nonatomic) IBOutlet UIButton *addimageBtn;
@property (weak, nonatomic) IBOutlet UILabel *infolable;

@property (weak, nonatomic) IBOutlet IBView *bgView;
/**说明*/
@property (weak, nonatomic) IBOutlet UILabel *shuoming;

@property (nonatomic,assign)BOOL isLook;

@property (nonatomic,assign)BOOL is12306Edit;

@end
