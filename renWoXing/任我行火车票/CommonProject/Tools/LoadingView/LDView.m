//
//  LDView.m
//  Petroleum
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LDView.h"

@interface LDView ()

@property (nonatomic,retain)CAReplicatorLayer *replicatorLayer;
@property (nonatomic,retain)UIImageView *imageV;
@end

@implementation LDView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width);
        
        [self ani2];
        
    }
    return self;
}

-(void)ani2{
    
    if (!_imageV) {
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageV.image = [UIImage imageNamed:@"rotate1"];
        [self addSubview:_imageV];
    }
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    scale.fromValue = @0;
    scale.toValue = @(M_PI*2);
    scale.duration = 1.0;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] ;
    
    scale.repeatCount = INFINITY;
    [_imageV.layer addAnimation:scale forKey:nil];
    
    
    
}
- (CAReplicatorLayer *)activityIndicatorAnimation
{
    float kW = self.frame.size.width;
    NSInteger kc = 20;
    float kdur = 1.0;
    float kdotsizeW = kW/6.0;
    
    self.replicatorLayer = [[CAReplicatorLayer alloc]init];
    self.replicatorLayer.frame = CGRectMake(0, 0, kW, kW);
    
    CALayer *subLayer = [[CALayer alloc]init];
    subLayer.bounds = CGRectMake(0, 0,kdotsizeW, kdotsizeW);
    subLayer.position = CGPointMake(kW*0.5, 0);
    subLayer.backgroundColor = [UIColor colorWithRed:0.3977 green:0.656 blue:1.0 alpha:1.0].CGColor;
    
    subLayer.cornerRadius = kdotsizeW*0.5;
    [self.replicatorLayer addSublayer:subLayer];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @1.0;
    scale.toValue = @0.1;
    scale.duration = kdur;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ;
    
    scale.repeatCount = INFINITY;
    //    scale.autoreverses = YES;
    [subLayer addAnimation:scale forKey:nil];
    
    
    self.replicatorLayer.instanceCount = kc;
    CGFloat angle = (2 * M_PI)/kc;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
    self.replicatorLayer.instanceDelay = kdur/kc;
    
    return self.replicatorLayer;
    
}

-(void)stopAnimating{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.alpha = 1.0;
        self.hidden = YES;
//    }];
 
    
}
-(void)startAnimating{

    self.hidden = NO;
    self.alpha = 1.0;
    [self ani2];
}
@end
