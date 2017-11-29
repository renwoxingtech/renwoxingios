//
//  DataModel.m
//  CommonProject
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
@implementation TrainStation

@end
@implementation CheCiRes



@end
@implementation UserInfo



@end

@implementation DateObject




@end

@implementation Customer

-(id)copyWithZone:(NSZone *)zone {
    
    Customer *newClass = [[Customer alloc]init];
    newClass.type_name = self.type_name;
    newClass.personType = self.personType;
    return newClass;
}


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"passengerid":@"id",@"passengersid":@"passengerid"};
}


+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"passengerid":@"id",@"passengersid":@"passengerid"};
    
}
-(NSString *)piaotype{
    NSString *tt = @"1";
    if ([self.piaotypename containsString:@"儿童"]) {
        tt = @"2";
    }
    if ([self.type_name containsString:@"儿童"] ) {
        tt=@"2";
    }
    return tt;
    
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"passengers":[Customer class]};
}

@end

@implementation SeatType



@end

@implementation OrderData



@end
