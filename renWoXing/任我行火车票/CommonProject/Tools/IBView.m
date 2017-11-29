//
//  IBView.m
//  OCIBanimatable
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "IBView.h"

IB_DESIGNABLE

@implementation IBView


//-(void)awakeFromNib{
//    [super awakeFromNib];
//    _gstartPoint = CGPointMake(0, 0.5);
//    _gendPoint = CGPointMake(1, 0.5);
//    
//    _topGradientColor = [UIColor yellowColor];
//    _bottomGradienColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
//
//}
- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius  = _cornerRadius;
    self.layer.masksToBounds = YES;
    
    
}

- (void)setBcolor:(UIColor *)bcolor{
    _bcolor = bcolor;
    self.layer.borderColor = _bcolor.CGColor;
}

- (void)setBwidth:(CGFloat)bwidth {
    _bwidth = bwidth;
    self.layer.borderWidth = _bwidth;
}
- (CGFloat)height {
    return self.frame.size.height;
}
-(CGFloat)width{
    return self.frame.size.width;

}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height {
    
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
//-(void)setGradient:(BOOL)gradient{
//    _gradient = gradient;
//    if (gradient) {
//        
//                
//        self.gradientLayer = [[CAGradientLayer alloc] init];
//        _gradientLayer.colors = @[(__bridge id)self.topGradientColor.CGColor,(__bridge id)self.bottomGradienColor.CGColor];
//        _gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//        _gradientLayer.startPoint = _gstartPoint;
//        _gradientLayer.endPoint = _gendPoint;
//        
//        [self.layer insertSublayer:_gradientLayer atIndex:0];
//        
//        
//    }
//}
//-(void)setGstartPoint:(CGPoint)gstartPoint{
//    _gstartPoint = gstartPoint;
//    _gradientLayer.startPoint = _gstartPoint;
//    
//}
//-(void)setGendPoint:(CGPoint)gendPoint{
//    _gendPoint = gendPoint;
//    _gradientLayer.endPoint = _gendPoint;
//    
//}
//-(void)setRotate:(CGFloat)rotate{
//    self.transform = CGAffineTransformMakeRotation(-rotate*(M_PI/180.0));
//    _rotate = rotate;
//}

-(void)setShadow:(BOOL)shadow{
    if (shadow) {
        self.layer.shadowColor = (self.shadowColor).CGColor;
        self.layer.shadowOffset = self.shadowOffset;
        self.layer.shadowOpacity = self.shadowOpacity;
        self.layer.shadowRadius = self.shadowRadius;
        
    }
}

-(void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    self.layer.shadowColor = (self.shadowColor).CGColor;
}
-(void)setShadowOffset:(CGSize)shadowOffset{
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = self.shadowOffset;

}
-(void)setShadowRadius:(CGFloat)shadowRadius{
    _shadowRadius = shadowRadius;
    self.layer.shadowRadius = self.shadowRadius;

}
-(void)setShadowOpacity:(CGFloat)shadowOpacity{
    _shadowOpacity = shadowOpacity;
    self.layer.shadowOpacity = self.shadowOpacity;

}
@end
