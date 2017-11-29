//
//  LoggerView.m
//  Petroleum
//
//  Created by mac on 16/7/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoggerView.h"

@protocol LoggerDelegate <NSObject>

-(void)loggerDidLogString:(NSString *)str;

@end


@interface Logger()
{
    NSDateFormatter *formater;
    
}

@property (nonatomic,weak)id <LoggerDelegate>delegate;

@end


@implementation Logger

-(instancetype)init{
    self = [super init];
    formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"HH:mm:ss.SSS";
    
    return self;
}
-(void)log:(id)obj{
    NSDate *date = [NSDate date];
    NSString *logStr = [NSString stringWithFormat:@"[%@]%@\n",[formater stringFromDate:date],obj];
    
    if (self.delegate) {
        
        [self.delegate loggerDidLogString:logStr];
    }
    
}

@end

static LoggerView *logView;


@interface LoggerView()<LoggerDelegate>
{
    CGPoint lastPoint;
    BOOL isShow;
    UITextView *logTxtView;
    UILabel *logLable;
    UIButton *clearBtn;
    
    
}
@property (nonatomic,retain)UIPanGestureRecognizer *panGes;

@end


@implementation LoggerView


+(instancetype)shareLoggerView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logView = [[LoggerView alloc]init];
        
    });
    return logView;
    
}
-(instancetype)init{
    self = [super init];
    
    self.layer.cornerRadius = KLoggerViewWidth*0.5;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.frame = CGRectMake(size.width-KLoggerViewWidth, 20, KLoggerViewWidth, KLoggerViewWidth);
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHide)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor whiteColor];
    _panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragSelf:)];
    [self addGestureRecognizer:_panGes];
    
    
    self.layer.shadowColor = [UIColor colorWithRed:0.1821 green:0.1811 blue:0.1831 alpha:1.0].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    lastPoint = self.center;
    
    
    logLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KLoggerViewWidth, KLoggerViewWidth-10)];
    logLable.font = [UIFont systemFontOfSize:18];
    logLable.text = @"Log";
    logLable.textColor = [UIColor darkGrayColor];
    logLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:logLable];
    
    
    logTxtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, KLVWidth, KLVHeight-20)];
    logTxtView.hidden = YES;
    logTxtView.backgroundColor = [UIColor whiteColor];
    logTxtView.font = [UIFont systemFontOfSize:14];
    logTxtView.editable = NO;
    [window addSubview:logTxtView];

    
    clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [window addSubview:clearBtn];
    
    clearBtn.frame = CGRectMake(KLVWidth-50, KLVHeight-50, 50, 30);
    clearBtn.hidden = YES;
//    clearBtn.layer.cornerRadius = 25;
//    clearBtn.layer.borderColor = clearBtn.tintColor.CGColor;
//    clearBtn.layer.borderWidth = 2.0;
//    clearBtn.layer.masksToBounds = YES;
    
    [clearBtn addTarget:self action:@selector(clearTxtView) forControlEvents:UIControlEventTouchUpInside];
    
    [window bringSubviewToFront:self];
    _logger = [[Logger alloc]init];
    _logger.delegate = self;
    return self;
}
-(void)clearTxtView{
    logTxtView.text = @"";
    
}
-(void)dragSelf:(UIPanGestureRecognizer *)pan{
    CGPoint point =  [pan translationInView:self];   
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint endPoint = CGPointMake(lastPoint.x+point.x, lastPoint.y+point.y);
        if (endPoint.x<0) {
            endPoint.x=0;
        }
        if (endPoint.y<0) {
            endPoint.y=0;
        }
        if (endPoint.x>KLVWidth) {
            endPoint.x = KLVWidth;
        }
        if (endPoint.y>KLVHeight) {
            endPoint.y = KLVHeight;
        }
        self.center = endPoint;
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        lastPoint = self.center;
        
    }
    
}
-(void)showOrHide{
    isShow = !isShow;
    if (isShow) {
        clearBtn.hidden = NO;
        
        logTxtView.hidden = NO;
        logTxtView.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            logTxtView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];

        
    }else{
        clearBtn.hidden = YES;

        logTxtView.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            logTxtView.alpha = 0.0;
        } completion:^(BOOL finished) {
            logTxtView.hidden = YES;
        }];
        
    }
}
-(void)loggerDidLogString:(NSString *)str{
    if (logTxtView.text.length<1) {
        logTxtView.text = str;
    }else{
        if (logTxtView.text.length>KLVLogMaxSize) {
            logTxtView.text = [logTxtView.text substringFromIndex:logTxtView.text .length-KLVLogMaxSize/2];
        }
        
        logTxtView.text = [logTxtView.text stringByAppendingString:str];
    }
    if (logTxtView.text.length>2) {
        
        [logTxtView scrollRangeToVisible:NSMakeRange(logTxtView.text.length-1, 1)];
    }
    
}
-(void)logSomething:(id)obj{
    //如果未开启log，就不打印log到视图
   
    [self.logger log:obj];
}
+(void)log:(id)obj{
    if (KShowLV) {
        
        
        [[self shareLoggerView] logSomething:obj];
    }
}

void LVLogger(NSString *format, ...){
//    NSString *str = [NSString stringWithFormat:format,...];
    
}

@end
