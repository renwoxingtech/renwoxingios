//
//  VIPModel.m
//  CommonProject
//
//  Created by 任我行 on 2017/11/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "VIPModel.h"

@implementation VIPModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)vipModelWith:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
//- (instancetype)initWithDict:(NSDictionary *)dict{
//    self = [super init];
//    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
//    }
//    return self;
//}
//
//+ (instancetype)vipModelWith:(NSDictionary *)dict{
//    return [[self alloc]initWithDict:dict];
//}
//
//- (void)setValue:(id)value forKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        self.typeId = value;
//    }
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
