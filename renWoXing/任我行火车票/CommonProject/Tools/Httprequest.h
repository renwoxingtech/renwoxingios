//
//  Httprequest.h
//  CommonProject
//
//  Created by mac on 16-12-21.
//  Copyright (c) 2016年 zrgg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>


//#define BaseUrlIp @"http://192.168.1.210"         //
//#define BaseUrlIp @"http://dygqp.test.yikeapp.cn"  
//#define BaseUrlIp @"http://dygqp.test.yikeapp.cn"//api.php?s=/
#define BaseUrlIp @"https://api.renxing12306.com"
#define BASE_URL(url) [NSString stringWithFormat:@"%@/%@",BaseUrlIp,url]


///使用AFNetworking的网络请求封装
@interface Httprequest : NSObject<UIAlertViewDelegate>{
    
    NSOperationQueue *myQueue;
    
}

typedef void (^returnObject)(id obj);
typedef void (^returnError)(id error);
+(id)shareRequest;

@property(nonatomic,retain) AFHTTPSessionManager * manager;


/**
 *  get请求
 *
 *  @param string   请求的url
 *  @param complain 请求完毕的回调block
 *  @param Error    错误返回
 */
-(void)getObjectByUrl:(NSString*)string  andComplain:(returnObject)complain andError:(returnError)Error;

/*!
 *  @author mac
 *  
 *  @brief 网络请求方法 ， 
 *
 *  @param parameters  请求的post参数
 *  @param urlString   post的url ，可以是部分，可以是全部的
 *  @param showLoading 是否显示等待视图
 *  @param showMsg     是否显示提示信息
 *  @param isFull      是否为完整url，如为完整则不再拼接
 *  @param complain    请求成功的回调
 *  @param Error       失败的回调
 */
-(void)postObjectByParameters:(id)parameters andUrl:(NSString *)urlString showLoading:(BOOL)showLoading showMsg:(BOOL)showMsg isFullUrk:(BOOL)isFull andComplain:(returnObject)complain andError:(returnError)Error;



//取消所有请求
-(void)cancelRequest;

//上传图片
-(void)postImageByUrl:(NSString*)url withParameters:(NSDictionary*)parameters andImageData:(NSData*)imageData imageKey:(NSString *)imageKey andComplain:(returnObject)complain andError:(returnError)Error;
/*!
 *  @author mac
 *  
 *  @brief 多张图片上传，图片的二进制数据直接放在对应的key里面，统一放在argvs内部
 *
 *  @param argvs 参数，包含图片的data数组
 *  @param url   请求链接
 *  @param block 回调block
 */
-(void)postMany:(NSDictionary *)argvs andUrl:(NSString *)url andComplain:(void (^)(id obj, NSError *error))block;


+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSString *)picFilePath  // IN
                     picFileName: (NSString *)picFileName;  // IN
@end


