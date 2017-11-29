//
//  VIPTableViewController.m
//  CommonProject
//
//  Created by 任我行 on 2017/10/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "VIPTableViewController.h"
#import "WXInsuranceCell.h"
#import "VIPModel.h"

@interface VIPTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
//    NSIndexPath *_indexPathLast;
    NSString    *_sureName;
    NSString    *_money;
}

@property(nonatomic,strong)UITableView * vipTableView;

@property(nonatomic,strong)NSMutableArray * modelArrayM;
@property(nonatomic,strong)NSMutableArray <VIPModel*> * dataMArray;

@end

@implementation VIPTableViewController

#pragma mark 初始化数组


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"套餐选择";
    
    UIButton * sure_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [sure_Btn setTitle:@"确定" forState:UIControlStateNormal];
    sure_Btn.titleLabel.font = [UIFont mysystemFontOfSize:14];
    [sure_Btn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right_Item = [[UIBarButtonItem alloc]initWithCustomView:sure_Btn];
    self.navigationItem.rightBarButtonItem = right_Item;
    
    _modelArrayM = [NSMutableArray array];
   
    //网络加载失败
    [self getData];
}


#pragma mark 获取网络数据
- (void)getData{
    [[Httprequest shareRequest]postObjectByParameters:nil andUrl:@"Index/getFee/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        NSString * msg = obj[@"msg"];
        if ([obj[@"code"] integerValue] == 1) {
            NSArray * vipArray = obj[@"data"];
            NSMutableArray * vipMutable = [NSMutableArray array];
            for (NSDictionary * dict in vipArray) {
                VIPModel * vipModel = [VIPModel vipModelWith:dict];
                [vipMutable addObject:vipModel];
            }
            self.dataMArray = vipMutable.copy;
            //获取数据
            [self creatDate];
            
            //创建tableView
            [self CreatTableView];
        }
        else{
            [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
        }
        
    } andError:^(id error) {
         [MBProgressHUD showHudWithString:@"加载失败,请稍后重试!" model:MBProgressHUDModeCustomView];
    }];
}

#pragma mark 获取数据
- (void)creatDate{
    for (int i = 0; i <= self.dataMArray.count; i++) {
        InsuranceModel * model = [[InsuranceModel alloc]init];
        VIPModel * vipmodel = nil;
        if (i < self.dataMArray.count) {
            vipmodel = self.dataMArray[i];
        }
        switch (i) {
            case 0:
                model.VIPName = vipmodel.name;
                model.priceName = [NSString stringWithFormat:@"¥%@/份",vipmodel.money];
                model.expalinName =@"tishi_icon";
                model.messageName = @"VIP急速抢票,抢不到全额退款";
                break;
            case 1:
                model.VIPName = vipmodel.name;
                model.priceName = [NSString stringWithFormat:@"¥%@/份",vipmodel.money];
                model.expalinName =@"";
                model.messageName = @"VIP急速抢票,抢不到全额退款";
                break;
            case 2:
                model.VIPName = vipmodel.name;
                model.priceName = [NSString stringWithFormat:@"¥%@/份",vipmodel.money];
                model.expalinName =@"";
                model.messageName = @"VIP急速抢票,抢不到全额退款";
                break;
            case 3:
                model.VIPName = @"低速抢票";
                model.priceName = @"";
                model.expalinName =@"";
                model.messageName = @"抢票慢,周末节假日抢票人数多,很可能排队";
                break;
                
            default:
                break;
        }
        [_modelArrayM addObject:model];
    }
}

#pragma mark tableView
- (void)CreatTableView{
    self.vipTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT - 64) style:UITableViewStylePlain];
    self.vipTableView.delegate = self;
    self.vipTableView.dataSource = self;
    self.vipTableView.backgroundColor = BgWhiteColor;
    [self.vipTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.vipTableView];
    NSIndexPath * indexPath = nil;
    if (_indexPath_Vip == nil) {
         indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else{
        indexPath = _indexPath_Vip;
    }
    
   
    [self.vipTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    if ([self.vipTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.vipTableView.delegate tableView:self.vipTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellID = @"cellID";
    WXInsuranceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WXInsuranceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    InsuranceModel * model = _modelArrayM[indexPath.row];
    cell.insuranceModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_indexPath_Vip == nil) {
        
    }
    else{
        WXInsuranceCell * lastCell = [tableView cellForRowAtIndexPath:_indexPath_Vip];
        [lastCell.clickBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [lastCell.clickBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
    
    
    WXInsuranceCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.clickBtn setImage:[UIImage imageNamed:@"dui_icon"]  forState:UIControlStateNormal];
    [cell.clickBtn setImage:[UIImage imageNamed:@"dui_icon"] forState:UIControlStateHighlighted];
    
    InsuranceModel * model = _modelArrayM[indexPath.row];
    cell.insuranceModel = model;
    _sureName = model.VIPName;
    _money = model.priceName;
    _indexPath_Vip = indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

#pragma mark 懒加载
- (NSMutableArray<VIPModel *> *)dataMArray{
    if (!_dataMArray) {
        _dataMArray = [NSMutableArray array];
    }
    return _dataMArray;
}

- (void)disMiss{
    self.vipBlock(_sureName, _indexPath_Vip,_money);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
