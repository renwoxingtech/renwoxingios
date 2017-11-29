//
//  NetRequest.m
//  CommonProject
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NetRequest.h"



static NetRequest *_request;





@implementation NetRequest
+(id)shareRequest{
    if (!_request) {
        _request = [[NetRequest alloc]init];
        
        
    }
    return _request;
}
-(void)requestWithUrl:(NSString *)string parameters:(id)parameter isJsonpar:(BOOL)isjson isPost:(BOOL)isPost andComplain:(returnObject)complain andError:(returnError)Error{
    NSURLSession *session = [NSURLSession sharedSession];

    NSString *urlStr = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = isPost?@"POST":@"GET";
     [request setValue:@"text/html;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString *par = parameter;
    if (isPost) {
        if (isjson && [parameter isKindOfClass:[NSDictionary class]]) {
            
            
            par = [parameter mj_JSONString];
        }else if([parameter isKindOfClass:[NSDictionary class]]){
            NSDictionary *diccc = parameter;
            par  = @"";
            for (NSString *key in diccc.allKeys) {
                par = [par stringByAppendingFormat:@"%@=%@&",key,diccc[key]];
            }
            if (par.length>2) {
                par = [par substringToIndex:par.length-1];
            }
        }
//        par = [par stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        request.HTTPBody = [par dataUsingEncoding:NSUTF8StringEncoding];
        
    }else{
        
    }
    
    NSLog(@"%@",par);
   

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            @try {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if ([dict isKindOfClass:[NSDictionary class]] && !error) {
                    complain(dict);
                }else{
                    Error(error);
                }
                NSLog(@"\nUrl:\n%@\n参数:\n%@\n返回:\n%@",string,[par mj_JSONString],[dict mj_JSONString]);
            } @catch (NSException *exception) {

            } @finally{
                
            }
        }

        
    }];
    [dataTask resume];
}
-(void)getNetObjectWithUrl:(NSString *)url complete:(returnObject)complete error:(returnError)error{
    
    
    url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSError *error2;
        
        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error2];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (string && string.length>0) {
                complete(string);
            }else{
                error(error2);
            }
        });
        
    });
    
}
- (void)uploadImageWithUrl:(NSString *)url parameters:(NSDictionary *)dict filepar:(NSString *)filepar{
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把file改成网站开发人员告知的字段名
     */
    
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image =[UIImage imageNamed:@"moon"];
        NSData *data = UIImagePNGRepresentation(image);
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统时间作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:filepar fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.progressView.progress = 1.0 *
            //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败 %@", error);
    }];
    
}
///解析json字符串为字典
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
@end
