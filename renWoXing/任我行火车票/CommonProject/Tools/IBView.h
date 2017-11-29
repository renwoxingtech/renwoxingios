//
//  IBView.h
//  OCIBanimatable
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface IBView : UIView
@property (nonatomic, assign)IBInspectable CGFloat height;
@property (nonatomic, assign)IBInspectable CGFloat width;

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat bwidth;
@property (nonatomic, retain)IBInspectable UIColor *bcolor;
//@property (nonatomic, assign)IBInspectable CGFloat rotate;
//
//@property (nonatomic, assign)IBInspectable CGPoint gstartPoint;
//@property (nonatomic, assign)IBInspectable CGPoint gendPoint;
//
//@property (nonatomic, retain)IBInspectable UIColor *topGradientColor;
//@property (nonatomic, retain)IBInspectable UIColor *bottomGradienColor;
//@property (nonatomic, assign)IBInspectable BOOL gradient;
//@property (nonatomic, retain)CAGradientLayer *gradientLayer;

//若需圆角和阴影共存，可以底部放一个背景透明的视图为其设置阴影，将主视图设置圆角放在背景上
@property (nonatomic, assign)IBInspectable BOOL shadow;//若设置了圆角则阴影无法显示
@property (nonatomic, assign)IBInspectable CGSize shadowOffset;
@property (nonatomic, retain)IBInspectable UIColor *shadowColor;
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;
@property (nonatomic, assign)IBInspectable CGFloat shadowRadius;



@end
