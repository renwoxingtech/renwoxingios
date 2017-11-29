//
//  NetRequest.h
//  CommonProject
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^returnObject)(id obj);
typedef void (^returnError)(id error);


///使用系统的网络请求封装
@interface NetRequest : NSObject
+(id)shareRequest;
///使用系统的网络请求进行数据的请求,
//isJsonpar是否参数以json格式上传
-(void)requestWithUrl:(NSString *)string parameters:(id)parameter isJsonpar:(BOOL)isjson isPost:(BOOL)isPost andComplain:(returnObject)complain andError:(returnError)Error;
///请求一段数据，格式可能不是json，为text或者其他格式，以字符串形式返回
-(void)getNetObjectWithUrl:(NSString *)url complete:(returnObject)complete error:(returnError)error;


@end
