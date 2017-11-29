//
//  PayView.m
//  CommonProject
//
//  Created by mac on 2017/1/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayView.h"

@implementation PayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"PayView"owner:self options:nil];
        UIView *backView = [nibView objectAtIndex:0];
        backView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:backView];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
