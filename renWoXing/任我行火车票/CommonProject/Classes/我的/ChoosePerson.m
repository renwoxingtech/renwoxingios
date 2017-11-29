//
//  ChoosePerson.m
//  CommonProject
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChoosePerson.h"
#import "AddPersonVc.h"
#import "NSBase64.h"
#import "SubmitOrderVc.h"
#import "LoginVc.h"
#import "GTMBase64.h"


#import "NSString+Encryption.h"

@implementation ChengCheren


@end

@interface ChoosePerson ()
{
    NSMutableArray *choosedCustomer;//选中的乘客的数组
    
}

@end

@implementation ChoosePerson
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.preObjvalue) {
        self.title = @"选择乘客";
    }else if(_is12306Lianxr){
         self.title = @"12306联系人";
    }else{
    self.title = @"常用乘车人";
    }
    
    //添加乘客按钮
    UIButton * add_Btn = [[UIButton alloc]initWithFrame:CGRectMake(0,  0 + 50 + 5, SWIDTH, 47)];
    add_Btn.backgroundColor = [UIColor whiteColor];
    [add_Btn setImage:[UIImage imageNamed:@"tianjia_blue_icon"] forState:UIControlStateNormal];
    [add_Btn setImage:[UIImage imageNamed:@"tianjia_blue_icon"] forState:UIControlStateHighlighted];
    [add_Btn setTitle:@"添加乘客" forState:UIControlStateNormal];
    [add_Btn setTitleColor:BlueColor forState:UIControlStateNormal];
    add_Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    add_Btn.titleLabel.font = Font(17);
    [add_Btn addTarget:self action:@selector(addconAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add_Btn];
    
    //添加线View
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, SWIDTH, 1)];
    lineView.backgroundColor = CCColor;
    [add_Btn addSubview:lineView];
    
    [self addPerson];
    choosedCustomer = [NSMutableArray array];
    NSString *zh = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
    if (!zh) {
        zh = @"未登录";
    }
    [self.zhanghaoBtn setTitle:zh forState:UIControlStateNormal];
    if (_is12306Lianxr) {
        self.bottomView.hidden = YES;
        
        add_Btn.frame = CGRectMake(0, 0, SWIDTH, 47);
        self.mainTableView.frame = CGRectMake(0, add_Btn.bottom, SWIDTH, SHEIGHT - add_Btn.height);
        
        self.mainTableView.height = SHEIGHT-self.mainTableView.top;
        
    }
    else{
        self.bottomView.hidden = NO;
        self.bottomView.frame = CGRectMake(0,64, SWIDTH, 50);
    }
    
}

#pragma mark 确定
- (void)addPerson{
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    addBtn.titleLabel.font = Font(14);
    [addBtn addTarget:self action:@selector(ppop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = item;
}


-(void)goDingdanSure{
    if (self.ischoose12306) {
        POP;
        return;
    }
    if (choosedCustomer.count<=0) {
        [MBProgressHUD showHudWithString:@"请选择乘客" model:MBProgressHUDModeCustomView];
        return;
    }else{
        if (!self.preObjvalue) {
             [MBProgressHUD showHudWithString:@"请返回重新选择车次" model:MBProgressHUDModeCustomView];
            return;
        }
        SubmitOrderVc *vc = (SubmitOrderVc *)[self getVCInBoard:nil ID:@"SubmitOrderVc"];
        vc.preObjvalue = self.preObjvalue;
        vc.is12306dingpiao = YES;
        vc.title = @"12306提交订单";
        PUSH(vc);
    }
}

//DES加密
#pragma mark 获取12306的乘客
-(void)get12306Customer{
    NSString *LoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
    NSString *LoginUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
    if (!LoginUserName) {
        LoginVc *vcv = (LoginVc *)[self getVCInBoard:nil ID:@"LoginVc"];
        vcv.is12306 = YES;
        vcv.preObjvalue = @"ChoosePerson";//
        vcv.title = @"登录";
        PUSH(vcv);

        
        return;
    }
    if (!LoginUserPassword) {
        [MBProgressHUD showHudWithString:@"需要登录12306账号" model:MBProgressHUDModeCustomView];
        return;
    }



    NSDictionary *account = @{@"trainAccount":LoginUserName,@"pass":LoginUserPassword};
    NSString *acountJsonStr = [account mj_JSONString];
    
    
    NSString *desSTr = [acountJsonStr desEncryptWithKey:HTDESKEY];

    if (!desSTr) {
        [MBProgressHUD showHudWithString:@"系统错误" model:MBProgressHUDModeCustomView];
        return;
    }
    [AppManager logJsonStr:account];
  
    NSString *posturl = [NSString stringWithFormat:@"http://trainorder.ws.hangtian123.com/cn_interface/trainAccount/contact/query"];
    NSString *postPar = [@{@"data":desSTr,@"accountversion":@"2"} mj_JSONString];

    NSString *filepath = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",LoginUserName]];
    NSLog(@"%@",filepath);
    NSArray *contactArr = [NSArray arrayWithContentsOfFile:filepath];
    if (contactArr) {
        [self formatData:[contactArr mutableCopy]];
        
    }else{
        [MBProgressHUD showHudWithString:@"加载中"];
//        [BHUD showLoading:@""];
    }
    
    if (_is12306Lianxr) {//获取 自己服务器上12306的常用联系人
    
        NSDictionary *dic = @{@"UToken":UToken,@"trainAccount":LoginUserName,@"pass":LoginUserPassword};
        NSString * posturl = [NSString stringWithFormat:@"Action/userlist/"];

        [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:dic] andUrl:posturl showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj)
        {
            [MBProgressHUD hideHud];
            NSLog(@"%@",obj);
            NSString * msg = obj[@"msg"];
            if ([obj[@"code"] integerValue] == 1) {
                [self.mainDataSource removeAllObjects];
                self.mainDataSource = [Customer mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]];
                NSArray *orgData= obj[@"data"][@"list"];
                [choosedCustomer removeAllObjects];
                [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Customer *cus = obj;
                    NSInteger tt =  cus.type;
                    @try {
                        cus.person_id = orgData[idx][@"id"];
                        cus.id_type = [orgData[idx][@"identytype"] integerValue];
                        cus.id_number = [NSString stringWithFormat:@"%@",orgData[idx][@"identy"]];
                        tt =[ orgData[idx][@"persontype"] integerValue];
                    } @catch (NSException *exception) {
                        cus.person_id = @"0";
                        cus.id_number = @"0";
                        cus.id_type = 1;

                    } @finally {

                    }

                    if ([cus.identyType isEqualToString:@"1"]) {
                        cus.id_name = @"身份证";
                        cus.id_type = 1;
                    }else  if ([cus.identyType isEqualToString:@"C"]) {
                        cus.id_name = @"港澳通行证";
                        cus.id_type = 2;

                    }else  if ([cus.identyType isEqualToString:@"G"]) {
                        cus.id_name = @"台湾通行证";
                        cus.id_type = 3;

                    }else  if ([cus.identyType isEqualToString:@"B"]) {
                        cus.id_name = @"护照";
                        cus.id_type = 4;

                    }

                    cus.isSelect = NO;
                    if (tt==0) {
                        cus.type_name = @"成人";
                    }else if (tt==1){
                        cus.type_name = @"儿童";
                    }else if (tt==2){
                        cus.type_name = @"学生";
                    }
                    //                    cus.type_name = tt==0?@"成人":@"儿童";
                    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:SelectCKKey];
                    NSArray *nnn = [str componentsSeparatedByString:@","];
                    for (NSString *strs in nnn) {
                        NSString *values = [strs stringByReplacingOccurrencesOfString:@"," withString:@""];
                        if ([values isEqualToString:cus.id_number]) {
                            cus.isSelect = YES;
                             [choosedCustomer addObject:cus];
                            continue;
                        }
                    }
                    
                }];
            }
            else{
                [MBProgressHUD showHudWithString:msg model:MBProgressHUDModeCustomView];
            }
            
             [self.mainTableView reloadData];
            
            
        } andError:^(id error) {
            [MBProgressHUD hideHud];
        }];
    }
    
    [[NetRequest shareRequest] requestWithUrl:posturl parameters:postPar isJsonpar:YES isPost:YES andComplain:^(id obj) {
//        [MBProgressHUD hideHud];
        if (!obj[@"data"]) {
//            [MBProgressHUD showHudWithString:@"加载失败" model:MBProgressHUDModeCustomView];
            return ;
        }
        NSString *orgData = obj[@"data"];
        if (!orgData) {
            return;
        }
        NSString *jsonStr = [self decryptUseDES:orgData key:HTDESKEY];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *errorMsg = obj[@"errorMsg"];
            if (errorMsg.length>0) {
//                [MBProgressHUD showHudWithString:errorMsg model:MBProgressHUDModeCustomView];
            }
        });
        NSRange range = [jsonStr rangeOfString:@"\"}]"];
        if (range.location<(jsonStr.length+10)) {
            jsonStr =[jsonStr substringToIndex:[jsonStr rangeOfString:@"\"}]"].location+3];
            if (jsonStr){
                NSArray *arrrData = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                if (arrrData) {
                    NSString *path = [[AppManager documentDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",LoginUserName]];
                    NSLog(@"%@",path);

                    [arrrData writeToFile:path atomically:YES];
                    if (!_is12306Lianxr){
                        [self formatData:arrrData];
                    }
                }
            }
        }
    } andError:^(id error) {
        
    }];

    
}

- (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    const Byte iv[] = {1,2,3,4,5,6,7,8};
//    +(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
//    {
        NSString *ciphertext = nil;
        NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [textData length];
        unsigned char buffer[1024];
        memset(buffer, 0, sizeof(char));
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding,
                                              [key UTF8String], kCCKeySizeDES,
                                              iv,
                                              [textData bytes], dataLength,
                                              buffer, 1024,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
            ciphertext = [GTMBase64 stringByWebSafeEncodingData:data padded:YES];
        }
        return ciphertext;
    }

#pragma mark - 解密1230乘客信息
- (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    
    NSData *cipherData = [GTMBase64 decodeString:cipherText];
    if (!cipherData) {
        return nil;
    }
    unsigned char buffer[30000];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          30000,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        
        
        plainText =   [NSString stringWithUTF8String:[data bytes]];
    }
    return plainText;
}

-(void)formatData:(NSArray *)arr{
    BOOL istest = NO;
    
        NSArray *person = @[@{@"birthday":@"1979-11-17",@"sex":@1,@"phone":@"",@"identy":@"230128197911173460",@"tel":@"",@"identyType":@"1",@"country":@"CN",@"id":@"986577322",@"checkStatus":@0,@"address":@"",@"email":@"",@"name":@"刘海霞",@"isUserSelf":@1,@"personType":@0}];
    if (istest) {
        
        arr = person;
    }
    self.mainDataSource = [Customer mj_objectArrayWithKeyValuesArray:arr];
    
    [choosedCustomer removeAllObjects];
    [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Customer *cus = obj;
        cus.person_id = arr[idx][@"id"];
        cus.passengerid = cus.person_id;

        if ([cus.identyType isEqualToString:@"1"]) {
            cus.id_name = @"身份证";
            cus.id_type = 1;
        }else  if ([cus.identyType isEqualToString:@"C"]) {
            cus.id_name = @"港澳通行证";
            cus.id_type = 2;
            
        }else  if ([cus.identyType isEqualToString:@"G"]) {
            cus.id_name = @"台湾通行证";
            cus.id_type = 3;
            
        }else  if ([cus.identyType isEqualToString:@"B"]) {
            cus.id_name = @"护照";
            cus.id_type = 4;
            
        }
        NSInteger tt =  [cus.personType integerValue];
        if (tt==0) {
            cus.type_name = @"成人";
        }
        if (tt==1) {
            cus.type_name = @"儿童";
        }
        if (tt==2) {
            cus.type_name = @"学生";
        }
        
        
        cus.id_number = cus.identy;

        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:SelectCKKey];
        NSArray *nnn = [str componentsSeparatedByString:@","];
        for (NSString *strs in nnn) {
            NSString *values = [strs stringByReplacingOccurrencesOfString:@"," withString:@""];
            if ([values isEqualToString:cus.id_number]) {
                cus.isSelect = YES;
                  [choosedCustomer addObject:cus];
                continue;
            }
        }

    }];
    [self.mainTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });

}
#pragma mark - 获取任行乘客
-(void)ppop{
    POP;
}


#pragma mark 获取任行账号的乘客
-(void)loadNetData{
    if (self.preObjvalue) {
        
//            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ppop)];
//            self.navItem.rightBarButtonItem = item;
    }
    if (self.ischoose12306) {
        _is12306Lianxr = YES;
        [self get12306Customer];
        
        return;
    }
  
    NSString *utk = UToken;
    if (!utk) {
        return;
    }
    [[Httprequest shareRequest] postObjectByParameters:[self getparametersWithDic:@{@"UToken":UToken}] andUrl:@"Action/userContacts/" showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        [self.mainDataSource removeAllObjects];
        self.mainDataSource = [Customer mj_objectArrayWithKeyValuesArray:obj[@"data"]];
        NSArray *orgData= obj[@"data"];
        [choosedCustomer removeAllObjects];
        [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Customer *cus = obj;
            NSInteger tt =  cus.type;
            @try {
                cus.person_id = orgData[idx][@"id"];
            } @catch (NSException *exception) {
                cus.person_id = @"0";
            } @finally {
                
            }
            cus.isSelect = NO;
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:SelectCKKey];
            NSArray *nnn = [str componentsSeparatedByString:@","];
            for (NSString *strs in nnn) {
               NSString *values = [strs stringByReplacingOccurrencesOfString:@"," withString:@""];
                if ([values isEqualToString:cus.id_number]) {
                    cus.isSelect = YES;
                     [choosedCustomer addObject:cus];
                    continue;
                }
            }

            cus.type_name = tt==1?@"成人":@"儿童";
            
        }];
        
        [self.mainTableView reloadData];
        
    } andError:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resue = @"person";
    ChengCheren *cell = [tableView dequeueReusableCellWithIdentifier:resue];
    if (!cell) {
        cell = [[ChengCheren alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resue];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    
    Customer *customer = self.mainDataSource[indexPath.row];
    
    cell.name.text = customer.name;

        cell.zjlx.text = customer.id_number;
        cell.cktype.text = customer.type_name;
  
    
    
    if (self.preObjvalue) {
        cell.choose.hidden = NO;
    }
    cell.choose.selected = customer.isSelect;
    [cell.choose addTarget:self action:@selector(choosePerson:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark 点击前面的方框
-(void)choosePerson:(UIButton *)btn{
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    
    Customer *cust = self.mainDataSource[indexPath.row];
    cust.isSelect = !cust.isSelect;
    if (cust.isSelect) {
        [choosedCustomer addObject:cust];
        if (choosedCustomer.count>5) {
            cust.isSelect = NO;
            [choosedCustomer removeObject:cust];
            [MBProgressHUD showHudWithString:@"最多只能选择5人" model:MBProgressHUDModeCustomView];
            return;
        }
    }

    btn.selected = !btn.selected;
    [choosedCustomer removeAllObjects];
    [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Customer *cus = obj;
        if (cus.isSelect) {
            [choosedCustomer addObject:cus];
        }
    } ];

    if (self.touchEvent) {
        
        self.touchEvent(choosedCustomer);

        
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Customer *cust = self.mainDataSource[indexPath.row];
    if (_is12306Lianxr) {
        AddPersonVc *vc = (AddPersonVc *)[self getVCInBoard:nil ID:@"AddPersonVc"];
        vc.isLook = YES;
        vc.is12306Edit = YES;
        vc.preObjvalue =cust;
        vc.touchEvent = ^(id value){
            [self loadNetData];

        };
        PUSH(vc);
        return;
    }
    if (self.ischoose12306 || self.ischooserx) {
//        cust.isSelect = !cust.isSelect;
//        [self.mainTableView reloadData];
//        [choosedCustomer removeAllObjects];
//        
//        for (Customer *ccc in self.mainDataSource) {
//            if (ccc.isSelect) {
//                [choosedCustomer addObject:ccc];
//            }
//        }
        return;
    }
    AddPersonVc *vc = (AddPersonVc *)[self getVCInBoard:nil ID:@"AddPersonVc"];
    vc.isLook = YES;
    vc.preObjvalue =cust;
    vc.touchEvent = ^(id value){
        [self loadNetData];
        
    };
    PUSH(vc);
    
}


#pragma mark 点击添加乘客按钮
- (void)addconAct:(UIButton *)sender {
    BOOL is12306Logined = [[NSUserDefaults standardUserDefaults] boolForKey:@"is12306login"];
    
     BOOL isLogined = [[NSUserDefaults standardUserDefaults] boolForKey:@"isrxlogin"];
    //_is12306Lianxr
    if (_is12306Lianxr) {
        if (!is12306Logined) {
            //去12306登陆；
            LoginVc *vcv = (LoginVc *)[self getVCInBoard:nil ID:@"LoginVc"];
            vcv.is12306 = YES;
            //        vcv.preObjvalue = @[res,@(sender.tag)];//tag :1   3   4
            vcv.title = @"登录";
            PUSH(vcv);
            return;
        }
    }
   if (!isLogined) {
        //去任行登陆；
        LoginVc *vcv = (LoginVc *)[self getVCInBoard:nil ID:@"LoginVc"];
//        vcv.preObjvalue = @[res,@(sender.tag)];//tag :1   3   4
        vcv.title = @"登录";
        PUSH(vcv);
       return;
    }
//   else{
    
       AddPersonVc *vc = (AddPersonVc *)[self getVCInBoard:nil ID:@"AddPersonVc"];
       vc.is12306Edit = _is12306Lianxr;
       vc.touchEvent = ^(id value){
           [self loadNetData];
           
       };
       PUSH(vc);
//   }
    
    
   
}
- (IBAction)zhact:(UIButton *)sender {
    [self denglu12306:sender];
    
}
- (IBAction)denglu12306:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is12306login"]){
        [self login123:sender];
        
        return;
        
    }
    if (_isWoTo12306L) {
        ChoosePerson *chh = (ChoosePerson *)[self getVCInBoard:@"Main" ID:@"ChoosePerson"];
        chh.ischoose12306 = YES;
        chh.is12306Lianxr = _isWoTo12306L;
        [self.navigationController pushViewController:chh animated:YES];
        return;
    }


    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"未登录" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zh12306"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mm12306"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is12306login"];
        
    }];
    [alert addAction:act1];
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"切换账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self login123:sender];
    }];
    [alert addAction:act2];
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:act3];
    [self presentViewController:alert animated:YES completion:nil];
     /* */
}
-(void)login123:(UIButton *)btn{
    LoginVc *vcv = (LoginVc *)[AppManager getVCInBoard:nil ID:@"LoginVc"];
    vcv.preObjvalue=@1;
    vcv.is12306 = YES;
    
    vcv.touchEvent = ^(id value){
        if ([value isKindOfClass:NSString.class]) {
            
            [btn setTitle:value forState:UIControlStateNormal] ;
        }  
    };
    PUSH(vcv);
}
@end
