//
//  LoggerView.h
//  Petroleum
//
//  Created by mac on 16/7/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KLoggerViewWidth 50  //log的圆形点击视图大小
#define KLVWidth [UIScreen mainScreen].bounds.size.width
#define KLVHeight [UIScreen mainScreen].bounds.size.height
#define KLVLogMaxSize 5000 //log的内容长度，因内存原因，太长的文字会被截取，保留最近一部分的log内容
#define KShowLV [[NSUserDefaults standardUserDefaults] boolForKey:@"KShowLV"]  //是否显示log视图  0  or  1


//#define KShowLV 1  //是否显示log视图  0  or  1

@interface Logger : NSObject

@end

@interface LoggerView : UIView

+(instancetype)shareLoggerView;
@property (nonatomic,retain)Logger *logger ;
+(void)log:(id)obj;
//void LVLogger(NSString *format, ...);

@end
