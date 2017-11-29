//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"


@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
//        [self setupButtonData];

    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self addSubview:imageView];
}
-(UIButton *)setupButtonViewWithBtnIndex:(NSInteger)index{
    CGFloat w = self.width/4;
 //修改为两个按钮了
    w = (self.width - 20)/2.0;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(w*index+5+(index==1?15:0), 0, w, self.height);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tintColor = [UIColor blackColor];
//    [btn addTarget:self action:@selector(goDetail:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index+1;
    if (self.isOnlyText) {
    
        [self addSubview:btn];
    }
    
    return btn;

}
-(void)setupButtonData{
    
    if (!_button1) {
       
        _button1 = [self setupButtonViewWithBtnIndex:0];
        _button2 = [self setupButtonViewWithBtnIndex:1];
        _button1.enabled = NO;
        _button2.enabled = NO;
        //_button3 = [self setupButtonViewWithBtnIndex:2];
        //_button4 = [self setupButtonViewWithBtnIndex:3];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.width*0.5, 15, 0.5, 20)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
    }
    
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
    CGFloat titleLabelW = self.sd_width;
    CGFloat titleLabelH = _titleLabelHeight;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.sd_height - titleLabelH;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden = !_titleLabel.text;
}

@end
