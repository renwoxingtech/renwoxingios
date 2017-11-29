//
//  WXInsuranceCell.m
//  CommonProject
//
//  Created by 任我行 on 2017/10/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WXInsuranceCell.h"

#define Margin 10
#define ViewHeight 20

@interface WXInsuranceCell()
{
    UILabel           * _VIPLabel;
    UILabel           * _priceLabel;
    UIImageView       * _explainimageView;
    UILabel           * _messageLable;
    UIView            * _lineView;
    
}
@end

@implementation WXInsuranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView{
    _VIPLabel = [self creatView:14 textColor:zhangColor];
    
    _priceLabel = [self creatView:14 textColor:huangTiColor];
    
    _explainimageView = [[UIImageView alloc]init];
    [self addSubview:_explainimageView];
    
    _messageLable = [self creatView:12 textColor:qiColor];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = CCColor;
    [self addSubview:_lineView];
    
    self.clickBtn = [[UIButton alloc]init];
    [self.clickBtn addTarget:self action:@selector(clickMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clickBtn];
    
}

- (void)clickMessage{
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _VIPLabel.frame = CGRectMake(15, Margin, 100, ViewHeight);
    _priceLabel.frame = CGRectMake(_VIPLabel.right + Margin, _VIPLabel.top, 60,ViewHeight);
    _messageLable.frame = CGRectMake(15, _VIPLabel.bottom + 10, 300, ViewHeight);
    _explainimageView.frame = CGRectMake(_priceLabel.right + 8, 15, 58, 14);
    _lineView.frame = CGRectMake(15, 61, SWIDTH - Margin, 1);
    _clickBtn.frame = CGRectMake(SWIDTH - 45, 24, 20, 14);
    
}

- (UILabel *)creatView:(CGFloat)font textColor:(UIColor *)textColor{
    UILabel * label = [[UILabel alloc]init];
    label.textColor = textColor;
    label.font = [UIFont mysystemFontOfSize:font];
    [self addSubview:label];
    return label;
}

- (void)setInsuranceModel:(InsuranceModel *)insuranceModel{
    _insuranceModel = insuranceModel;
    _VIPLabel.text = [NSString stringWithFormat:@"%@",insuranceModel.VIPName];
    _priceLabel.text = [NSString stringWithFormat:@"%@",insuranceModel.priceName];
    _messageLable.text = [NSString stringWithFormat:@"%@",insuranceModel.messageName];
    _explainimageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",insuranceModel.expalinName]];

   
}

@end
