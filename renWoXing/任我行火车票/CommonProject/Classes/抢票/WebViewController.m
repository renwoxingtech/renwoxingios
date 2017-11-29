//
//  WebViewController.m
//  CommonProject
//
//  Created by mac on 2017/1/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.preObjvalue]];
    [self.webView loadRequest:req];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
}
@end
