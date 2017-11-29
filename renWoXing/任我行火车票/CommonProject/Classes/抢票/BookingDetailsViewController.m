//
//  BookingDetailsViewController.m
//  CommonProject
//
//  Created by 任我行 on 2017/11/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BookingDetailsViewController.h"

@interface BookingDetailsViewController ()
@property(nonatomic,weak)UIScrollView * scrollView;

@end

@implementation BookingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = E5Color;
    self.title = @"订票须知";
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((SWIDTH - 343)/2, 5, 343, SHEIGHT - (NavHeight) - 15)];
    scrollView.contentSize = CGSizeMake(343, 1470);
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIImageView * bookingDetailsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.scrollView.top, self.scrollView.width, 1467)];
    bookingDetailsView.image = [UIImage imageNamed:@"xuzhi"];
    [self.scrollView addSubview:bookingDetailsView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
