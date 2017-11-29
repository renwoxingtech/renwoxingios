//
//  VIPModel.h
//  CommonProject
//
//  Created by 任我行 on 2017/11/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPModel : NSObject
/**
 *   类型的名字
 */
@property(nonatomic,copy)NSString * name;
/**
 *   钱
 */
@property(nonatomic,copy)NSString * money;
/**
 *   
 */
@property(nonatomic,copy)NSString * level;
/**
 *   类型
 */
@property(nonatomic,copy)NSString * status;
/**
 *   类型
 */
@property(nonatomic,copy)NSString * typeId;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)vipModelWith:(NSDictionary *)dict;
@end
