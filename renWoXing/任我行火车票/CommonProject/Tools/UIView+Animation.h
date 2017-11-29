//
//  UIView+Animation.h
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger , AShowAnimationStyle) {
    ASAnimationDefault    = 0,
    ASAnimationLeftShake  ,
    ASAnimationTopShake   ,
    ASAnimationNO         ,
};



@interface UIView (Animation)

- (void)setShowAnimationWithStyle:(AShowAnimationStyle)animationStyle;

@end
