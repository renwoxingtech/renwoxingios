//
//  BaseViewController.h
//  CommonProject
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#define GaiQianKey @"GaiQianPerson"
#define SelectCheCiKey @"SelectCheCi"
#define SelectRiqiKey @"SelectRiqi"
#define SelectZXKey @"SelectZuoXi"
#define SelectCKKey @"SelectChengKe"


@interface BaseViewController : UIViewController

@property (nonatomic,retain)UIScrollView *bgScrollView;
@property (nonatomic,retain)NSMutableArray *mainDataSource;
-(UIViewController *)getVCInBoard:(NSString *)bord ID:(NSString *)idd;
@property (nonatomic,assign)NSInteger page;//主数据加载时的分页
typedef void(^TouchEvent)(id value);

@property (nonatomic,copy)TouchEvent touchEvent;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
typedef void(^Info)(TrainStation *value1,TrainStation *value2 );
@property (nonatomic,copy)Info stationInfo;

- (void)CustomButtonAction;
- (void)creatLoadingView;

/**
 *   获取星期几
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

//拿到任行接口的参数
-(NSDictionary *)getparametersWithDic:(NSDictionary *)pardic;
//
//self.navBar.hidden = YES; //隐藏导航条,在子类viewWillAppear里面调用
//@property (nonatomic,retain) UINavigationBar *navBar;
//@property (nonatomic,retain) UINavigationItem *navItem;

//self.isPanForbid = YES; //禁用iOS自带侧滑返回手势(1、手势冲突，比如地图；2、不是继承基类的VC，比如继承UIViewController/UITableViewController/UISearchController),在子类viewDidLoad方法里面调用
@property (nonatomic,assign) BOOL isPanForbid;
- (IBAction)backAction:(UIButton *)sender ;
@property (nonatomic , copy)NSString *orderID;
@property (nonatomic , copy)NSString *orderURL;
-(void)loadNetData;
@property (nonatomic,retain)id preObjvalue;
@property (nonatomic,assign)BOOL needTap;
@property (nonatomic,retain)NSMutableArray <TrainStation *>*stationArr;
-(void)initStation;
-(NSString *)zuoweiCodeWithName:(NSString *)name;

@end
