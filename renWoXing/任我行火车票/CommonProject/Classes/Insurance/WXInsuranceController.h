//
//  WXInsuranceController.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface WXInsuranceController : BaseViewController

@property(nonatomic,assign)NSInteger insurance_type;

@property(nonatomic,copy) void(^insurance_block)(NSString * price,NSIndexPath *index_last);
@property(nonatomic,strong)NSIndexPath * indexPath_new;

@end
