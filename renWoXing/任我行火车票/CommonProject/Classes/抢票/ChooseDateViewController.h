//
//  ChooseDateViewController.h
//  CommonProject
//
//  Created by mac on 2017/1/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseDateViewController : BaseViewController

@property (nonatomic,assign)NSInteger dateRange;
@property (nonatomic,assign)NSInteger maxCount;
@property (nonatomic,retain)NSMutableArray *selectDateArr;

@property (nonatomic,assign)BOOL issingle;//是否是单选

@end
