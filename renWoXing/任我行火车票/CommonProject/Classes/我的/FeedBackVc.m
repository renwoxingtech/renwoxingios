//
//  FeedBackVc.m
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FeedBackVc.h"

@interface FeedBackVc ()<UITextViewDelegate>

@end

@implementation FeedBackVc

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navBar.hidden = NO;
    self.title = @"意见反馈";
    
//    UIBarButtonItem *his = [[UIBarButtonItem alloc]initWithTitle:@"历史反馈" style:UIBarButtonItemStylePlain target:self action:@selector(gohis)];
//    self.navItem.rightBarButtonItem = his;
    [self.submitBtn addTarget:self action:@selector(submitAct) forControlEvents:UIControlEventTouchUpInside];
    _gongnengjianyi.selected = YES;
    _gongnengjianyi.backgroundColor = BlueColor;


}
- (IBAction)typeBtnAction:(UIButton *)sender {
   
    _gongnengjianyi.selected = NO;
    _bugfankui.selected = NO;
    _qita.selected = NO;
    
    _gongnengjianyi.backgroundColor = [UIColor lightGrayColor];
    _bugfankui.backgroundColor = [UIColor lightGrayColor];
    _qita.backgroundColor = [UIColor lightGrayColor];

    sender.backgroundColor = BlueColor;
    sender.selected = YES;
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text containsString:@"在这里输入您的意见或建议"]) {
        textView.text  = [textView.text stringByReplacingOccurrencesOfString:@"在这里输入您的意见或建议" withString:@""];
    }
}

-(void)gohis{
    UIViewController *cv = [self getVCInBoard:nil ID:@"FeedbackHistoryVc"];
    [self.navigationController pushViewController:cv  animated:YES];
    
    
}


-(void)submitAct{
    if (self.contentField.text.length<1 && [self.contentField.text isEqualToString:@"在这里输入您的意见或建议"]) {
        [MBProgressHUD showHudWithString:@"请填写反馈内容" model:MBProgressHUDModeCustomView];
        return;
    }
    if (self.lxfsfield.text.length<1) {
        [MBProgressHUD showHudWithString:@"请填写联系方式" model:MBProgressHUDModeCustomView];
        return;
    }
    NSInteger type = 2;
    if (self.gongnengjianyi.selected) {
        type = 1;
    }
    if (self.qita.selected) {
        type = 3;
        
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken,@"feedback_type":@(type),@"feedback_content":_contentField.text,@"phone":_lxfsfield.text}] andUrl:@"Action/addFeedback/" showLoading:NO showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
//            [LoadingView showAMessage:@"反馈成功"];
            POP;
        }
    } andError:nil];

}
@end
