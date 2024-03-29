//
//  CBAlertView.h
//  CommonProject
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchEvent)(id value);


@interface CBAlertView : UIView
@property (nonatomic,retain)UILabel *titleLable;
@property (nonatomic,retain)UIView *bgLightView;
@property (nonatomic,retain)NSMutableArray *actionsBtn;
@property (nonatomic,retain)UIButton *cancelBtn;
@property (nonatomic,retain)UILabel *sureBtn;

@property(nonatomic,strong)UIButton *zhiFubtn;
@property(nonatomic,strong)UIImageView * imageView;
@property (nonatomic,copy)TouchEvent clickevent;//回传的为点击的index，从0开始

-(id)initWithTitle:(NSString *)title actionsTitles:(NSArray *)actArr imgnames:(NSArray *)imgnames showCancel:(BOOL)cancel showSure:(BOOL)showSure event:(TouchEvent)touchEvent;
-(void)cancelAct;
@end
