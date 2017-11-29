//
//  InsuranceModel.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceModel : NSObject
/**
 *   VIP类型
 */
@property(nonatomic,copy)NSString * VIPName;
/**
 *   套餐的价格
 */
@property(nonatomic,copy)NSString * priceName;
/**
 *   套餐的图片
 */
@property(nonatomic,copy)NSString * expalinName;
/**
 *   套餐的解释
 */
@property(nonatomic,copy)NSString * messageName;

@end
