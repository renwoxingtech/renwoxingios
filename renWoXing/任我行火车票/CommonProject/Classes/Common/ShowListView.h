//
//  ShowListView.h
//  ProjectEducation
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 zrgg. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^selectBtnClick)(NSString *title , NSInteger index);

@interface ShowListView : UIView

@property (nonatomic , copy)NSMutableArray *dataSource;
@property (nonatomic , copy)NSString *flags;


@property (nonatomic , assign)BOOL noShowBackGround;

- (id)initWithFrame:(CGRect)frame dataSource1:(NSArray *)dataSource ClickEvent:(selectBtnClick)click andPostName:(NSString *)name;

@end
