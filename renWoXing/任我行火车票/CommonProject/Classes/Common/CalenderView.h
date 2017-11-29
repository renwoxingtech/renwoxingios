//
//  CalenderView.h
//  XWDC
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 hcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderView : UIView<UIScrollViewDelegate>

-(instancetype)initWithFrame:(CGRect)frame andMaxDays:(int)days;

@property (nonatomic,retain)UILabel *currentLabel;//toolbar上的label

@property (nonatomic , copy)void (^getDate)(NSString *dateTime);
@property (nonatomic,retain)UIButton *sureBtn;
@property (nonatomic ,assign)BOOL isShowLunar;//是否显示农历
@property (nonatomic , assign)CGFloat viewHeight;
@property (nonatomic , assign)int maxDays;
@end
