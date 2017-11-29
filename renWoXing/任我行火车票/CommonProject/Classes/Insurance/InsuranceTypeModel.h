//
//  InsuranceTypeModel.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceTypeModel : NSObject
/**
 *   保险的类型
 */
@property(nonatomic,copy)NSString *insurance_type;
/**
 *   最好价格
 */
@property(nonatomic,copy)NSString *max_val;
/**
 *   最低价格
 */
@property(nonatomic,copy)NSString *min_val;
/**
 *   保险的钱
 */
@property(nonatomic,copy)NSString *money;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)typeModelWithDict:(NSDictionary *)dict;
@end
