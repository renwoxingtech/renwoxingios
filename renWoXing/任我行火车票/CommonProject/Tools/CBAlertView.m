//
//  CBAlertView.m
//  CommonProject
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CBAlertView.h"

@interface CBAlertView ()
{
    BOOL isShowSure;
    
}
@end

@implementation CBAlertView

-(id)initWithTitle:(NSString *)title actionsTitles:(NSArray *)actArr imgnames:(NSArray *)imgnames showCancel:(BOOL)cancel showSure:(BOOL)showSure event:(TouchEvent)touchEvent{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SWIDTH, SHEIGHT);
        isShowSure = showSure;
        
        self.alpha = 0.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        self.actionsBtn = [NSMutableArray array];
        _clickevent = touchEvent;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAct)];
        [self addGestureRecognizer:tap];
        
        CGFloat space = 45;
        CGFloat ww = 270;
        CGFloat h = actArr.count*space+space;
        if (showSure || cancel) {
            h+=space;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ww, h)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        view.center = self.center;
        {
            //titlelable
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ww, space)];
            lable.textColor = BlueColor;
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = title;
            lable.font = [UIFont systemFontOfSize:18];
            [view addSubview:lable];
            self.titleLable = lable;
        }
        {
            //action Btn
            for (int i=0; i<actArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0,space+space*i, ww, space);
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                if (i == 0) {
                    btn.selected = YES;
                    [btn setTitleColor:BlueColor forState:UIControlStateNormal];
                     [btn setTitleColor:BlueColor forState:UIControlStateHighlighted];
                }
                else{
                   [btn setTitleColor:zhangColor forState:UIControlStateNormal];
                }
                if (imgnames.count==actArr.count) {
//                    [btn setImage:[UIImage imageNamed:imgnames[i]] forState:UIControlStateNormal];
                    UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(10,space+space*i+8, space-16, space-16)];
                    im.image = [UIImage imageNamed:imgnames[i]];
                    [view addSubview:im];
                }
                [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitle:actArr[i] forState:UIControlStateNormal];
                btn.tag = i;
                [view addSubview:btn];
                [self.actionsBtn addObject:btn];


                //line
                UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, space*i+space, ww, 0.5)];
                view2.backgroundColor = [UIColor lightGrayColor];
                [view addSubview:view2];
                if (i==actArr.count-1) {
                    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, space*i+space+space, ww, 0.5)];
                    view2.backgroundColor = [UIColor lightGrayColor];
                    [view addSubview:view2];
                }
            }
            
        }
        UIButton *cancelBtn;
        UIButton *sureBtn;
        if (cancel){
            //cancel  btn
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(0,space+space*actArr.count+0.5, ww, space);
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:qiColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancelAct) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            
            [view addSubview:btn];
            cancelBtn = btn;
            
        }
        if(showSure){
            //cancel  btn
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(0,space+space*actArr.count+0.5, ww, space);
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:BlueColor forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            
            [view addSubview:btn];
            sureBtn = btn;
            
        }
        if (cancel && showSure) {
            cancelBtn.width = ww*0.5;
            sureBtn.width = ww*0.5;
            sureBtn.left = ww*0.5;
            UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(ww*0.5, space*actArr.count+space, 0.5, space)];
            view2.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:view2];
            
            

        }
    }
    return self;
}
-(void)btnAct:(UIButton *)btn{
    if (_clickevent) {
        self.clickevent(@(btn.tag));
        NSLog(@"%d",btn.tag-1);
//        if (isShowSure) {
//            
//        }else{
            [self cancelAct];
            
//        }
    }
}
-(void)cancelAct{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
};
@end
