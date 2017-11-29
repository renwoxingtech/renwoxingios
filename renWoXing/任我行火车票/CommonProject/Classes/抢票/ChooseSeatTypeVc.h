//
//  ChooseSeatTypeVc.h
//  CommonProject
//
//  Created by mac on 2017/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseSeatTypeVc : BaseViewController
@property (nonatomic,assign)NSInteger maxCount;
@property (nonatomic,retain)NSMutableArray *selectTypeArr;
@property (nonatomic,assign)BOOL issingle;//是否是单选
@property (nonatomic,retain)NSMutableArray *haveTypeArr;//所选车次的允许的坐席类型

@end
