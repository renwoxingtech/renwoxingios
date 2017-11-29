//
//  ShowListView.m
//  ProjectEducation
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 zrgg. All rights reserved.
//

#import "ShowListView.h"

#define DivisionHeight 40

@interface ChooseBtn : UIButton

@property (nonatomic,copy) NSString *name;

@property (nonatomic , copy)NSString *idStr;

@end



@implementation ChooseBtn

{


}

@end



@interface ShowListView ()

{
    NSMutableArray *ListData;

    UIScrollView *ListScroll;

    NSInteger flag;
   selectBtnClick _MyClick;
    NSString *post;

}
@end

@implementation ShowListView

- (id)initWithFrame:(CGRect)frame dataSource1:(NSArray *)dataSource ClickEvent:(selectBtnClick)click andPostName:(NSString *)name{

    self = [super initWithFrame:frame];
    if (self) {
        _MyClick = click;
        post = name;
        ListData = [NSMutableArray arrayWithArray:dataSource];
        [self addSubview:[self addScrollView]];
        [self reloData];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.3;

    }
    return self;
}

- (UIScrollView *)addScrollView{

    ListScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    ListScroll.backgroundColor = [UIColor whiteColor];;
    ListScroll.layer.cornerRadius = 5;
    ListScroll.layer.masksToBounds = YES;
    return ListScroll;
}

- (void)reloData{
//    if (ListScroll.subviews.count>0) {
        [ListScroll removeAllSubviews];
//    }
    UILabel *ll = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, self.width-50, 30)];
    ll.text = @"请选择你所在企业";
    ll.font = [UIFont systemFontOfSize:13];
    ll.textColor = [UIColor darkGrayColor];
//    [ListScroll addSubview:ll];

    for (int i = 0; i < ListData.count; i ++) {
        ChooseBtn *leftBtn = (ChooseBtn *)[self viewWithTag:1000+i];
        if (leftBtn) {
            [leftBtn removeFromSuperview];
        }
//        ProjectModel *model = ListData[i];
        NSString *title = ListData[i];
        leftBtn=[[ChooseBtn alloc]initWithFrame:CGRectMake(0, DivisionHeight*i, self.frame.size.width, DivisionHeight)];
        [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        leftBtn.tag = i+1000;
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        [leftBtn setTitle:title forState:UIControlStateNormal];
//        leftBtn.idStr = ListData[i][@"id"];
//        leftBtn.name = ListData[i][@"name"];



        [leftBtn addTarget:self action:@selector(hidMoreView:) forControlEvents:UIControlEventTouchUpInside];
        [ListScroll addSubview:leftBtn];

        UILabel *line = (UILabel *)[self viewWithTag:5000+i];
        if (line) {
            [line removeFromSuperview];
        }
        line = [[UILabel alloc]initWithFrame:CGRectMake(0, leftBtn.top+0.5, self.frame.size.width, 0.5)];
        line.tag = 5000+i;
        line.backgroundColor = [UIColor colorWithRed:0.7047 green:0.7047 blue:0.7047 alpha:1.0];
        [ListScroll addSubview:line];
        if (_noShowBackGround) {
            leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        leftBtn.titleLabel.numberOfLines = 0;
    }

    ListScroll.contentSize = CGSizeMake(0, DivisionHeight*ListData.count);


}

#pragma mark - 按钮点击事件
- (void)hidMoreView:(UIButton *)sender{

    ChooseBtn *btn = (ChooseBtn *)sender;
    for (int i = 0; i < ListData.count; i ++) {
        ChooseBtn *leftBtn = (ChooseBtn *)[self viewWithTag:1000+i];
        leftBtn.selected = NO;
        if (btn==leftBtn) {
            flag = i;
        }
        leftBtn.backgroundColor = [UIColor whiteColor];
    }
    if (!_noShowBackGround) {
        sender.backgroundColor = BlueColor;
//        [UIColor colorWithRed:0.2863 green:0.702 blue:0.9882 alpha:1.0];
        [self hidCurrentView];
        sender.selected = YES;
    }else{
          sender.selected = NO;
    }

    if (_MyClick) {
        _MyClick(sender.currentTitle,flag);
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:post object:nil userInfo:@{@"name":sender.currentTitle,@"index":[NSString stringWithFormat:@"%ld",(long)flag]}];

}

#pragma mark - 隐藏当前视图
- (void)hidCurrentView{
    self.clipsToBounds = YES;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    ListData = dataSource;
    [self reloData];
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    ListScroll.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
