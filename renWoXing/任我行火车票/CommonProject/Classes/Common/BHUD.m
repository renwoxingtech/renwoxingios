//
//  BHUD.m
//  HUDD
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 hcb. All rights reserved.
//
#define SW [UIScreen mainScreen].bounds.size.width
#define SH [UIScreen mainScreen].bounds.size.height
#define SCENTER CGPointMake(SW*0.5, SH*0.5)
#define SRECT CGRectMake(0, 0, SW, SH)
#define RectWidth  100
//#define tttt 20 //延时隐藏
#import "BHUD.h"
 
static BHUD *hud;
NSString * const _recognizertheScale = @"_recognizertheScale";

@implementation BHUD
{
    
    UIView *contentVw;//背景view
    UILabel *contentLab;//文字lable
    UIImageView *contentImage;//中心的图片
    UIActivityIndicatorView *indicatorVw;//中心的风火轮
    UIWindow *window;
    BOOL showIndicator;
    NSString *mymessage;
    NSInteger timeFlag;
    BOOL isnetWork;
    BOOL nohide;
    CADisplayLink *linkP;
    CADisplayLink *linkP2;
    NSInteger chekcFlag;
    CGFloat tttt;
    UIVisualEffectView *v;
    BOOL isAnimating;
    BOOL _isAnimationing;
    
}
//-(void)setThescale:(CGFloat)thescale{
//    //objc_setAssociatedObject(self, (__bridge const void *)(_recognizertheScale), @(thescale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    self.transform = CGAffineTransformMakeScale(thescale, thescale);
//}
//
//-(CGFloat)thescale{
//    NSNumber *scaleValue = objc_getAssociatedObject(self, (__bridge const void *)(_recognizertheScale));
//    return scaleValue.floatValue;
//}

-(void)checkHidenLink{
    chekcFlag = 200;
    linkP2 = [CADisplayLink displayLinkWithTarget:self selector:@selector(hudIshiden)];
    linkP2.preferredFramesPerSecond = 6;
    [linkP2 addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

-(void)hideHudAni{
    [self hideLoadHudAnimation];
}

-(void)hudIshiden{
    
    if (contentVw.hidden==NO) {
        chekcFlag--;
        if (chekcFlag<1) {
            [self hideHudAni];
            linkP2.paused=YES;
            chekcFlag=200;
        }
    }else chekcFlag=200;
}
-(void)initLinkWithTime:(CGFloat)tmm{
    
    [contentVw.layer removeAllAnimations];
    
    linkP2.paused=NO;
    if (showIndicator==NO) {
        timeFlag=15;

    }
    linkP.paused = NO;
    timeFlag=tmm;
    if (linkP) {
        
    }else{
        linkP=[CADisplayLink displayLinkWithTarget:self selector:@selector(jiancount)];
        linkP.preferredFramesPerSecond=6;
        [linkP addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    
}
-(void)jiancount{

    timeFlag--;
    if (timeFlag==0) {
        timeFlag=tttt;
        nohide=NO;
        linkP.paused=YES;
        [self hideHudAni];
    }
}
+(void)dismissHud{
    [[self shareHud] dismissHud];
}
+(void)showLoading:(NSString *)message{

    [[self shareHud] createHud:message showInd:YES image:nil];
}
+(void)showSuccessMessage:(NSString *)messgae{
    
    [[self shareHud] initLinkWithTime:15];
    [[self shareHud] createHud:messgae showInd:NO image:SUCCESSIMAGE];

}

+(void)showErrorMessage:(NSString *)messgae{
    
    [[self shareHud] initLinkWithTime:30];
    [[self shareHud] createHud:messgae showInd:NO image:ERRORIMAGE];
    
}
+(BHUD *)shareHud{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        hud = [[self alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    });
    
    return hud;
}

+(BOOL)isWorking{
    return  [[self shareHud] isWork];
}

- (BOOL)isWork{
    if (!self.hidden) {
        return YES;
    }
    if (timeFlag>0) {
        return YES;
    }
    return NO;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 200);
        [self checkHidenLink];
        [self initView];

    }
    return self;
}
-(void)dismissHud{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initLinkWithTime:1];
    });
}
-(void)hidewithTime{
    [self initLinkWithTime:10];
}


-(void)initView{
    
    //背景
//    UIBlurEffect *blu=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

//    if (IOS7) {
        contentVw= [[UIView alloc]initWithFrame:CGRectMake(0, 0, RectWidth, RectWidth)];
        contentVw.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
//    }else{
//        contentVw= [[UIVisualEffectView alloc]initWithEffect:blu];
//    }
    contentVw.layer.cornerRadius=10;
    contentVw.frame=CGRectMake(0, 0, RectWidth, RectWidth);
    contentVw.clipsToBounds=YES;

    contentVw.alpha=1.0;
    
    //lable
    contentLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 70, RectWidth-10, 40)];
    contentLab.textAlignment=NSTextAlignmentCenter;
    contentLab.textColor=[UIColor whiteColor];
    contentLab.numberOfLines=0;
    contentLab.font=[UIFont systemFontOfSize:15];
    [contentVw addSubview:contentLab];

    
    //等待视图
    indicatorVw = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorVw.hidesWhenStopped = YES;
    indicatorVw.tintColor =[UIColor redColor];
    indicatorVw.center=CGPointMake(contentVw.bounds.size.width*0.5, contentVw.bounds.size.height*0.5-15) ;
    
    [contentVw addSubview:indicatorVw];

    //指示图片
    contentImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    contentImage.center=CGPointMake(contentVw.bounds.size.width*0.5, contentVw.bounds.size.height*0.5-15) ;
    [contentVw addSubview:contentImage];

    
}
#pragma mark - 创建hud 设置frame
-(void)createHud:(NSString *)messgae showInd:(BOOL)showInd image:(UIImage *)imagee{

    window=[[[UIApplication sharedApplication] delegate] window];;

    self.center = CGPointMake(window.frame.size.width*0.5, window.frame.size.height*0.5);
    [self addSubview:contentVw];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    [self bringSubviewToFront:contentVw];
    
    if (showInd==YES) {
        showIndicator=YES;
    }else showIndicator=NO;

    contentVw.frame=CGRectMake(0, 0, RectWidth, RectWidth);

    if ([messgae isEqualToString:@""] || messgae==nil) {
        messgae=@"加载中";
    }
    contentLab.text=messgae;
    
    
    CGSize ss=[contentLab.text sizeWithAttributes:@{NSFontAttributeName:contentLab.font}];
    if (ss.width<RectWidth-20) {
        
        contentVw.frame=CGRectMake(0, 0, RectWidth, RectWidth);
    }
    if (ss.width>RectWidth-20) {
        contentLab.frame=CGRectMake(0, 0, ss.width, 40);
        contentVw.frame=CGRectMake(0, 0, ss.width+20, RectWidth);
    }
   
    if (ss.width>=200) {

        contentLab.numberOfLines=ss.width/200+1;
        contentLab.frame=CGRectMake(10, 0, 180, 20*contentLab.numberOfLines);
        contentVw.frame=CGRectMake(0, 0, 200, RectWidth+20*(contentLab.numberOfLines-2));
        timeFlag=20;
    }
    //风火轮
    if (showInd) {
        isnetWork=YES;//网络请求调用的,根据此标志,延时隐藏;
        indicatorVw.hidden=NO;
        [indicatorVw startAnimating];
    }else indicatorVw.hidden=YES;
    
    

    //指示图片
    contentImage.hidden=YES;
    if (imagee!=nil) {
        contentImage.hidden=NO;
    }
    contentImage.image=imagee;
    
    //整体位置调整
    
    contentLab.center=CGPointMake(contentVw.bounds.size.width*0.5, contentVw.bounds.size.height-contentLab.bounds.size.height/2.0-7);
    contentImage.center=CGPointMake(contentVw.bounds.size.width*0.5, contentVw.bounds.size.height*0.5-15);
    indicatorVw.center=CGPointMake(contentVw.bounds.size.width*0.5, contentVw.bounds.size.height*0.5-15);

    
    [self addSubview:contentVw];
    contentVw.center = CGPointMake(100, 100);
    
    [self showLoadHudAnimation];
    

}


#pragma mark - loadHud 相关 
-(void)showLoadHudAnimation{

    if (_isAnimationing) {
        return;
    }
    if (!self.hidden) {
        return;
    }
    
    self.thescale = 0.01f;
    self.hidden = NO;
    _isAnimationing = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.thescale = 1.0f;
        
    } completion:^(BOOL finished) {
        _isAnimationing = NO;
    }];
}
-(void)hideLoadHudAnimation{
    if (!showIndicator ) {

    }
    if (_isAnimationing) {
        return;
    }
    if (self.hidden) {
        return;
    }
    _isAnimationing = YES;
    self.thescale = 1.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.thescale = 0.01f;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _isAnimationing = NO;
        
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenVew" object:nil];
}
@end
