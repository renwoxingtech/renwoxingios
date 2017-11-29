//
//  WXInsuranceController.m
//  CommonProject
//
//  Created by 任我行 on 2017/10/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "WXInsuranceController.h"
#import "WXInsuranceCell.h"
#import "InsuranceModel.h"
#import "InsuranceTypeModel.h"

@interface WXInsuranceController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * _styleArrayM;
    BOOL             _isSelect;
//    NSIndexPath    *_indexPath_last;
    NSString       *_surePrice;
    
}

@property(nonatomic,strong)NSArray * baoxianInfo;

@property(nonatomic,strong)UITableView * insuranceTableView;

@end

@implementation WXInsuranceController

- (instancetype)init{
    self = [super init];
    if (self) {
        _styleArrayM = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgWhiteColor;
    self.title = @"保险套餐";
    
    _isSelect = NO;
    _baoxianInfo = [NSArray array];
    
    //保险接口
    [self getBaoxian];
   
    //右侧的确定按钮
    UIButton * sure_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [sure_Btn setTitle:@"确定" forState:UIControlStateNormal];
    [sure_Btn setTitleColor:TitleColor forState:UIControlStateNormal];
    sure_Btn.titleLabel.font = Font(14);
    [sure_Btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right_Item = [[UIBarButtonItem alloc]initWithCustomView:sure_Btn];
    self.navigationItem.rightBarButtonItem = right_Item;
}

#pragma mark 保险接口
-(void)getBaoxian{
    [[Httprequest shareRequest] postObjectByParameters:nil andUrl:@"Index/Insurance/" showLoading:NO showMsg:NO isFullUrk:NO andComplain:^(id obj) {
        NSArray * array = obj[@"data"];
        NSMutableArray * typeArray_M = [NSMutableArray array];
        for (NSDictionary * dict in array) {
            if ([dict[@"insurance_type"] integerValue] == self.insurance_type){
                InsuranceTypeModel * typeModel = [InsuranceTypeModel typeModelWithDict:dict];
                [typeArray_M addObject:typeModel];
            }
        }
         _baoxianInfo = typeArray_M.copy;
        //初始化保险套餐数据
        [self creatDate];
       
        //创建tableView
        [self creatTableView];
        
        [self.insuranceTableView reloadData];
    } andError:nil];
}

- (void)creatDate{
    for (int i = 0; i < 4; i++) {
        InsuranceModel * model = [[InsuranceModel alloc]init];
        InsuranceTypeModel * model_type = [[InsuranceTypeModel alloc]init];
        switch (i) {
            case 0:
                model.VIPName = @"交通意外险";
                model_type = _baoxianInfo[2];
                model.priceName = [NSString stringWithFormat:@"¥%ld",[model_type.money integerValue] / 100];
                model.expalinName = @"";
                model.messageName = @"最高130万保额,无票全额退款";
                break;
            case 1:
                model.VIPName = @"交通意外险";
                model_type = _baoxianInfo[1];
                model.priceName = [NSString stringWithFormat:@"¥%ld",[model_type.money integerValue] / 100];
                model.expalinName = @"";
                model.messageName = @"最高81万保额,无票全额退款";
                break;
            case 2:
                model.VIPName = @"交通意外险";
                model_type = _baoxianInfo[0];
                model.priceName = [NSString stringWithFormat:@"¥%ld",[model_type.money integerValue] / 100];
                model.expalinName = @"";
                model.messageName = @"最高55万保额,无票全额退款";
                break;
            case 3:
                model.VIPName = @"不购买保险";
                model.priceName = @"";
                model.expalinName = @"";
                model.messageName = @"无保障,不享受意外保障";
                break;
                
            default:
                break;
        }
        [_styleArrayM addObject:model];
    }
}

- (void)dismiss{
    if (self.insurance_block) {
        self.insurance_block(_surePrice, _indexPath_new);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTableView{
   self.insuranceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH,SHEIGHT - 64 ) style:UITableViewStylePlain];
    self.insuranceTableView.backgroundColor = BgWhiteColor;
    self.insuranceTableView.delegate = self;
    self.insuranceTableView.dataSource = self;
    //tableView的分割线
    [self.insuranceTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.insuranceTableView];
    
    NSIndexPath * index = nil;
    if (_indexPath_new == nil) {
        index = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else{
        index = [NSIndexPath indexPathForRow:_indexPath_new.row inSection:0];
    }
    [self.insuranceTableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
    if ([self.insuranceTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.insuranceTableView.delegate tableView:self.insuranceTableView didSelectRowAtIndexPath:index];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellInsuranceId";
    WXInsuranceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WXInsuranceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    InsuranceModel * model = _styleArrayM[indexPath.row];
    cell.insuranceModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_indexPath_new == nil) {
        
    }
    else{
        WXInsuranceCell * lastCell = [tableView cellForRowAtIndexPath:_indexPath_new];
        [lastCell.clickBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [lastCell.clickBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }

    WXInsuranceCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.clickBtn setImage:[UIImage imageNamed:@"dui_icon"] forState:UIControlStateNormal];
    [cell.clickBtn setImage:[UIImage imageNamed:@"dui_icon"] forState:UIControlStateHighlighted];
    InsuranceModel * Model_insurnace = _styleArrayM[indexPath.row];
    _surePrice = Model_insurnace.priceName;
    _indexPath_new = indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
