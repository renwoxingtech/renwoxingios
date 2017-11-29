//
//  WXInsuranceCell.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceModel.h"

@interface WXInsuranceCell : UITableViewCell

@property(nonatomic,strong)InsuranceModel * insuranceModel;
@property(nonatomic,strong)UIButton       * clickBtn;

@end
