//
//  SKBView.m
//  CommonProject
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SKBView.h"

@interface SKBView ()
{
    UIVisualEffectView *effview;
}
@end

@implementation SKBView

-(instancetype)initWithTitles:(NSMutableArray *)titles chufadi:(NSString *)chufaStr{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        effview = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [self addSubview:effview];
        self.backgroundColor = [UIColor clearColor];
        effview.frame = self.bounds;
        
        {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 30)];
            lable.textColor = [UIColor whiteColor];
            lable.centerX = self.centerX;
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = @"时刻表";
            lable.font = [UIFont systemFontOfSize:19];
            [effview.contentView addSubview:lable];
        }
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SWIDTH, 30)];
            view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
            
            [effview.contentView addSubview:view];
            
            {
                NSArray *aa = @[@"站名",@"到达",@"发车",@"停留"];
                for (int i=0; i<4; i++) {
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(30+i*((SWIDTH-30)/4.0), 0, 80, 30)];
                    lable.textColor = [UIColor whiteColor];
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.text = aa[i];
                    lable.font = [UIFont systemFontOfSize:15];
                    [view addSubview:lable];
                }
                
            }
            
        }
        
        
        //车站内容
        {
            CGFloat h = SHEIGHT - 150-50;
            
            UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 150, SWIDTH, h)];
            [self addSubview:sc];
            sc.backgroundColor = [UIColor clearColor];
            CGFloat hj = titles.count*32;
            if (hj<sc.height) {
                hj = sc.height+1;
            }
            sc.contentSize = CGSizeMake(SWIDTH, hj);
            
            
            NSString *prestr = @"";
            for (int j=0;j<titles.count; j++) {
                NSArray *aa = titles[j];
                if ([aa[0] isEqualToString:chufaStr]) {
                    if (j-1>0) {
                        NSArray *bb = titles[j-1];
                        
                        prestr = bb[0];
                        
                    }
                }
            }
            for (int j=0;j<titles.count; j++) {
                NSArray *aa = titles[j];
                for (int i=0; i<4; i++) {
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(30+i*((SWIDTH-30)/4.0), 32*j, (SWIDTH-30)/4.0, 32)];
                    lable.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
                    if ([aa[0] isEqualToString:chufaStr]) {
                        lable.textColor = BlueColor;
                    }
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.text = aa[i];
                    lable.font = [UIFont systemFontOfSize:14];
                    [sc addSubview:lable];
                    
                    
                }
                
                UIImageView *iii = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5+16+32*j, 7, 32)];
                if (j<titles.count-1) {
                    
                    iii.image = [UIImage imageNamed:@"jingguo"];
                    [sc addSubview:iii];
                }
                if (j==0) {
                    UIImageView *iii = [[UIImageView alloc]initWithFrame:CGRectMake(14, 12, 9, 9)];
                    iii.image = [UIImage imageNamed:@"qishi"];
                    [sc addSubview:iii];
                }
                if (j==titles.count-2) {
                    iii.image = [UIImage imageNamed:@"zhongdian"];

                }
                if ([aa[0] isEqualToString:prestr]) {
                    iii.image = [UIImage imageNamed:@"jingguy"];

                }
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
            [self addGestureRecognizer:tap];

        }
    }
    return self;
}
-(void)hide{
    [self.superview removeFromSuperview];
}
@end
