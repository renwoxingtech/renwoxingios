//
//  VIPTableViewController.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface VIPTableViewController : BaseViewController

@property(nonatomic,copy)void(^vipBlock)(NSString * vipName,NSIndexPath * index_VipLast,NSString * money);
@property(nonatomic,strong)NSIndexPath * indexPath_Vip;

@end
