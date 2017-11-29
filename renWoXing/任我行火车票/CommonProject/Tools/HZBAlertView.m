//
//  HZBAlertView.m
//  UIAlterViewDemo
//
//  Created by zhanbing han on 15/12/4.
//  Copyright © 2015年 北京与车行信息技术有限公司. All rights reserved.
//

#import "HZBAlertView.h"




@interface HZBAlertView ()
{
    UIView *bgView; //模糊背景视图
    UIView *shadowBgView;
    UIButton *cancelBtn;
    UIButton *doneBtn;
    UIView *colLine;//两个按钮中间的线条
    NSArray *_iconArray;
}
@end

@implementation HZBAlertView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
          iconArray:(NSArray *)iconArray{

    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];

        self.title = title;
        self.content = content;
        self.leftTitle = leftTitle;
        self.rigthTitle = rigthTitle;
        _iconArray = iconArray;

        UIWindow *ww = [UIApplication sharedApplication].keyWindow;

//        UIView *vv = ww
//        ww addSubview:<#(nonnull UIView *)#>
//        self.baseView = bView;

//        if ([ModelUtils isStringEmpty:self.leftTitle]) {
//            self.flag = NO; //只有确定按钮
//        } else {
            self.flag = YES; //取消和确定2个按钮
//        }


        [ww addSubview:self];



        [self initView]; //初始化视图\

        self.animationStyle = ASAnimationTopShake;

    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {

    UIWindow *ww = [UIApplication sharedApplication].keyWindow;

    shadowBgView = [[UIView alloc] initWithFrame:self.frame];
    shadowBgView.tintColor = [UIColor blackColor];
    [ww addSubview:shadowBgView];

    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/1.3, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    [bgView.layer setMasksToBounds:YES];
//    bgView.dynamic = YES;
//    bgView.blurRadius = 30;
    [ww addSubview:bgView];
    

    CGFloat titleH;
    titleH = self.title.length==0?0:20;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, bgView.width-30, titleH)];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = self.title;
    [bgView addSubview:titleLab];

    CGFloat contentOffY = titleLab.frame.size.height==0?20:45;
    CGFloat contentH = [self getTextHeight:self.content font:[UIFont systemFontOfSize:15] forWidth:titleLab.width] + 1;
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, contentOffY, titleLab.width, contentH)];
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:13];
    contentLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.text = self.content;
    [bgView addSubview:contentLab];

    CGFloat offY = CGRectGetMaxY(contentLab.frame) + 20;

    UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width, 0.6)];
    rowLine.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [bgView addSubview:rowLine];


    if (self.flag == YES) {
        colLine = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, 0.6, 45)];
        colLine.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [bgView addSubview:colLine];

        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width/2, 45)];
        cancelBtn.userInteractionEnabled = YES;
        [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0.0255 green:0.4156 blue:0.9934 alpha:1.0] forState:UIControlStateNormal];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];

        doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, bgView.frame.size.width/2, 45)];
        [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [doneBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.3647 blue:0.9216 alpha:1.0] forState:UIControlStateNormal];
        doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:doneBtn];
    } else {
        doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width, 45)];
        [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:doneBtn];
    }

    if (_iconArray.count>0) {
        colLine.hidden = YES;
        rowLine.top = contentLab.bottom+10;
        titleLab.textColor = [UIColor darkGrayColor];
        titleLab.font = [UIFont systemFontOfSize:14];
        [cancelBtn setImage:[UIImage imageNamed:_iconArray[0]] forState:0];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0.5507 green:0.5507 blue:0.5507 alpha:1.0] forState:0];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
         cancelBtn.height = 70;
        cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(cancelBtn.height-20, -(cancelBtn.width-cancelBtn.titleLabel.width)/2.0+2, 0, 0);
        cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(0,(cancelBtn.width-cancelBtn.imageView.width)/2.0, 20, 0);
        cancelBtn.titleLabel.centerX = cancelBtn.imageView.centerX;


        [doneBtn setImage:[UIImage imageNamed:_iconArray[1]] forState:0];
        [doneBtn setTitleColor:[UIColor colorWithRed:0.5507 green:0.5507 blue:0.5507 alpha:1.0] forState:0];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        doneBtn.height = 70;
        doneBtn.titleEdgeInsets = UIEdgeInsetsMake(doneBtn.height-20, -(doneBtn.width-doneBtn.titleLabel.width)/2.0, 0, 0);
        doneBtn.imageEdgeInsets = UIEdgeInsetsMake(0,(doneBtn.width-doneBtn.imageView.width)/2.0, 20, 0);
        doneBtn.titleLabel.centerX = doneBtn.imageView.centerX;

    }


    CGRect bgFrame = bgView.frame;
    bgFrame.size.height = contentOffY+contentH+20+doneBtn.height;
    bgView.frame = bgFrame;
    bgView.center = self.center;
}

#pragma mark - 取消点击
- (void)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }

    [self dismissAlert];
}

#pragma mark - 确定点击
- (void)doneAction:(id)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }

    [self dismissAlert];
}

#pragma mark - 页面消失
- (void)dismissAlert
{

    [bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [bgView removeFromSuperview];
    [shadowBgView removeFromSuperview];
    [self removeFromSuperview];



}

#pragma mark - 根据文字内容、字体大小、行宽返回文本高度
- (CGFloat)getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width {
    CGSize contentSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSFontAttributeName: font};

    contentSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    return contentSize.height;
}

#pragma mark - 设置弹框动画效果
-(void)setAnimationStyle:(AShowAnimationStyle)animationStyle{
    [bgView setShowAnimationWithStyle:animationStyle];
}


- (void)setIconArray:(NSArray *)iconArray{
    if (iconArray.count>0) {
        colLine.hidden = YES;
        _iconArray = iconArray;

        cancelBtn.height = 100;
        doneBtn.height = 100;



    }
}


@end
