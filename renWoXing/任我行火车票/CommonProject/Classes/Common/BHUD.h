//
//  BHUD.h
//  HUDD
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 hcb. All rights reserved.
//
/*!
 *  @author cbh, 16-03-22 15:03:26
 *
 *  @brief 一个显示提示框的视图
 *
 *  @return return value description
 */
#import <UIKit/UIKit.h>
#define BackVwColor  [UIColor colorWithWhite:0.0 alpha:0.5]
#define SUCCESSIMAGE		[UIImage imageNamed:@"dui"]
#define ERRORIMAGE			[UIImage imageNamed:@"cuo"]
#define SHOWHUDTIME 3.0  //2秒后自动隐藏



@interface BHUD : UIView

@property (nonatomic) CGFloat  thescale;


/*!
 *  使hud消失
 */
+(void)dismissHud;
+(BHUD *)shareHud;

/*!
 *  显示一个转圈的视图,并显示一个加载信息  不传message则显示加载中
 *
 */

+(void)showLoading:(NSString *)message;
//显示一条提示消息
/*!
 *  显示一个hud 提示操作成功
 *
 *  @param messgae 需要显示的message
 */
+(void)showSuccessMessage:(NSString *)messgae;
+(void)showErrorMessage:(NSString *)messgae;

+(BOOL)isWorking;

-(void)hideLoadHudAnimation;

@property (nonatomic, strong)  UIView  *messageView;
@end
