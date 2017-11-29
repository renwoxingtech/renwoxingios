//
//  ChoeseStationVC.m
//  CommonProject
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChoeseStationVC.h"
#import <Speech/Speech.h>

@interface ChoeseStationVC ()<UITextFieldDelegate>
{
    NSMutableArray <NSMutableArray *>*stationArr;
    NSMutableArray <NSMutableArray *>*orgstationArr;
    NSMutableArray *filterArr;
    
    NSMutableArray *titleArr;
    NSMutableArray <TrainStation *>*hotCity;
    BOOL isss;
    
    UIView *headerV;
    
}

@property (weak, nonatomic) IBOutlet UITextField *searchfield;


@end

@implementation ChoeseStationVC

-(void)search{
    self.mainTableView.tableHeaderView = nil;
    
    
    //   ||(self.code contains[cd] %@)
    
    //    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
    //
    //    self.searchfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.name BEGINSWITH[cd] %@",self.searchfield.text,self.searchfield.text];
    NSMutableArray *arr  = [NSMutableArray arrayWithArray:[filterArr filteredArrayUsingPredicate:pre]] ;//对数据进行过滤
    [stationArr removeAllObjects];
    [stationArr addObject:arr];
    [self.mainTableView reloadData];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.fd_prefersNavigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgWhiteColor;
    self.mainTableView.backgroundColor = BgWhiteColor;
    hotCity = [NSMutableArray array];
    self.searchfield.delegate = self;
    [self.searchfield addTarget:self action:@selector(searchfieldChange:) forControlEvents:UIControlEventEditingChanged];
    //    self.title = @"出发地";
    //    self.navBar.hidden = YES;
    //    [self creatNarBar];
    
    [self initStation];
    [self readHotCity];
    
    
    NSMutableArray *hottitleArr = [NSMutableArray array];
    for (TrainStation *st  in hotCity) {
        [hottitleArr addObject:st.name];
    }
    
    
    CGFloat space = 8;
    CGFloat ww = (SWIDTH-40-30-space*2)/3.0;
    CGFloat hh = 35;
    NSInteger count = hotCity.count/3;
    if (hotCity.count%3!=0) {
        count+=1;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, (hh+space)*count+30)];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = 1;
    view.layer.masksToBounds = YES;
    
    
    {
        NSInteger iindex = 0;
        for (int i=0; i<count; i++) {
            for (int j=0; j<3; j++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20+(ww+space)*j, 20+i*(hh+space), ww, hh)];
                
                [btn addTarget:self action:@selector(stbtnAct:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitle:hottitleArr[iindex] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
                btn.tag = iindex+1;
                [view addSubview:btn];
                iindex++;
            }
        }
    }
    headerV = view;
    
    self.mainTableView.tableHeaderView = headerV;
    
    
    
}

-(void)searchfieldChange:(UITextField *)textField{
    isss = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.searchfield.text.length==0) {
            
        }else{
            
            self.mainTableView.tableHeaderView = nil;
            [self search];
            
        }
    });
    
}

#pragma mark 设置新的导航栏
- (void)creatNarBar{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, 64)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = BlueColor;
    [self.searchfield bringSubviewToFront:bgView];
}

-(void)stbtnAct:(UIButton *)btnb{
    if (self.touchEvent) {
        self.touchEvent(hotCity[btnb.tag-1]);
        POP
    }
}
-(void)readHotCity{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hotcity" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    if (str) {
        NSArray *all = [str componentsSeparatedByString:@"\n"];
        
        for (NSString *str  in all) {
            NSArray *tmp = [str componentsSeparatedByString:@"|"];
            TrainStation *station = [[TrainStation alloc]init];
            station.code = tmp[0];
            station.name = tmp[1];
            station.szm = tmp[2];
            station.pinyin = tmp[3];
            //            station.pinyinStr = [self chineseToPinyin:station.name];
            [tmpArr addObject:station];
        }
        
    }
    [hotCity addObjectsFromArray:tmpArr];
    
}
-(void)initStation{
    stationArr = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"all_stations" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    if (str) {
        NSArray *all = [str componentsSeparatedByString:@"@"];
        
        for (NSString *str  in all) {
            NSArray *tmp = [str componentsSeparatedByString:@"|"];
            /*
             bjb,
             北京北,
             VAP,
             beijingbei,
             bjb,
             0
             */
            
            
            
            TrainStation *station = [[TrainStation alloc]init];
            station.code = tmp[0];
            station.name = tmp[1];
            station.szm = tmp[2];
            station.pinyin = tmp[3];
            //            station.pinyinStr = [self chineseToPinyin:station.name];
            [tmpArr addObject:station];
        }
        
    }
    
    filterArr = tmpArr;
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    [tmpArr sortUsingDescriptors:sortDescriptors];
    for (int i=0; i<26; i++) {
        [stationArr addObject:[NSMutableArray array]];
    }
    titleArr = [NSMutableArray array];
    NSString *shou = @"a";
    NSInteger index = 0;
    for (TrainStation *st  in tmpArr) {
        NSString *s = [st.pinyin substringToIndex:1];
        
        if ([s isEqualToString:shou]) {
            [stationArr[index] addObject:st];
        }else{
            index+=1;
            shou = s;
            [titleArr addObject:shou];
            [stationArr[index] addObject:st];
            
        }
        
    }
    [stationArr removeObject:[NSMutableArray array]];
    orgstationArr = [NSMutableArray arrayWithArray:stationArr];
    
    for (int i=0; i<titleArr.count; i++) {
        titleArr[i] = [self toUpper:titleArr[i] ];
        
    }
    [titleArr insertObject:@"A" atIndex:0];
    [self.mainTableView reloadData];
}
-(NSString *)toLower:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='A'&[str characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}
-(NSString *)toUpper:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='a'&[str characterAtIndex:i]<='z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]-32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}
-(NSString *)chineseToPinyin:(NSString *)chinese{
    //将汉字转化成拼音的代码：
    NSMutableString *mutableString = [NSMutableString stringWithString:chinese];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    mutableString =(NSMutableString *)[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mutableString;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return stationArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return stationArr[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resue = @"staion";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resue];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resue];
    }
    cell.backgroundColor = [UIColor clearColor];
    TrainStation *station = stationArr[indexPath.section][indexPath.row];
    cell.textLabel.text = station.name;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.touchEvent) {
        self.touchEvent(stationArr[indexPath.section][indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (isss) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 30)];
    //    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 1;
    view.layer.masksToBounds = YES;
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 35, 18)];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = titleArr[section];
    lable.layer.cornerRadius = 3;
    lable.layer.masksToBounds = YES;
    
    lable.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    lable.font = [UIFont systemFontOfSize:15];
    [view addSubview:lable];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return titleArr;
}

@end
