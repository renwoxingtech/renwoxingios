//
//  ChooseSeatView.h
//  CommonProject
//
//  Created by 任我行 on 2017/10/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSeatView : UIView

@property(nonatomic,copy)NSString * seatType;
@property(nonatomic,strong)NSArray * customerArray;
@property(nonatomic,copy)void(^chooseSeatBlock)(NSArray * seatArray,NSArray * tagArray);
- (void)getCustomerArray:(NSArray *)customerArray seatString:(NSString *)seatString;

@end
