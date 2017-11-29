//
//  InsuranceTypeModel.m
//  CommonProject
//
//  Created by 任我行 on 2017/10/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "InsuranceTypeModel.h"

@implementation InsuranceTypeModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)typeModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
