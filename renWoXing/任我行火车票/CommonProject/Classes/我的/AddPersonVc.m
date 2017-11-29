//
//  AddPersonVc.m
//  CommonProject
//
//  Created by mac on 2017/1/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AddPersonVc.h"
#import "CBAlertView.h"
#import <UIButton+WebCache.h>
#import "NSString+Encryption.h"
#import "NetRequest.h"

@interface AddPersonVc ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSData *choosedData;
    UIImage *choosedImage;
    NSString *card_url;
    
}
@property (weak, nonatomic) IBOutlet UITextView *btmlab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(strong,nonatomic) UIButton * deleteBtn;
/**审核状态*/
@property(strong,nonatomic)UIView * checkstatusView;
/**审核的status*/
@property(strong,nonatomic)UILabel * statusLabel;

@end

@implementation AddPersonVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"乘客信息";
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    //删除
    UIButton * deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    deleteBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [deleteBtn addTarget:self action:@selector(shanchuAct:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = deleteBtn;
    UIBarButtonItem * item =[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    //确定
    [self.sureBtn addTarget:self action:@selector(sureChange) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    //身份审核
    _checkstatusView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView.bottom, SWIDTH, 50)];
    _checkstatusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_checkstatusView];
    
    UILabel * shenFenLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 7, 74, 35)];
    shenFenLabel.text = @"身份核验";
    shenFenLabel.textColor = qiColor;
    shenFenLabel.font = [UIFont systemFontOfSize:13];
    shenFenLabel.textAlignment = NSTextAlignmentLeft;
    [_checkstatusView addSubview:shenFenLabel];
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 0, SWIDTH - 102 - 10, 50)];
    _statusLabel.text = @"通过审核";
    _statusLabel.textColor = OrangeColor;
    _statusLabel.font = [UIFont systemFontOfSize:15];
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    [_checkstatusView addSubview:_statusLabel];
    
    [self.addimageBtn addTarget:self action:@selector(changeHeadIM:) forControlEvents:UIControlEventTouchUpInside];
    self.addimageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addimageBtn.clipsToBounds = YES;

    for (UIView *v  in self.view.subviews) {
        [self.bgScrollView addSubview:v];
    }
    [self.view addSubview:self.bgScrollView];
    
     Customer *cust = self.preObjvalue;
    
    if (!self.isLook) {
       
        self.heyanlable.hidden = YES;
        self.stateBtn.hidden = YES;
        self.infolable.top = self.bgView.bottom;
        self.addimgBgview.top = self.bgView.bottom+15;
        self.deleteBtn.hidden = YES;
        self.sureBtn.top  = self.infolable.bottom + 5;
         self.shuoming.top = self.sureBtn.bottom + 5;
        _checkstatusView.hidden = YES;
        
    }else{
         self.title = @"编辑乘客";
        if (_is12306Edit) {
            self.infolable.top = self.checkstatusView.bottom + 5;
            
            if ([cust.checkstatus isEqualToString:@"0"]) {
                _statusLabel.text = @"通过审核";
            }
            else if ([cust.checkstatus isEqualToString:@"1"]){
                _statusLabel.text = @"待审核";
            }
            else{
                
            }
        }
        else{
            self.infolable.top = self.bgView.bottom;
            _checkstatusView.hidden = YES;
        }
        self.sureBtn.top  = self.infolable.bottom + 5;
        
        self.shuoming.top = self.sureBtn.bottom + 5;
        
        if ([cust isKindOfClass:[Customer class]]) {
            card_url = cust.id_imgurl;
            if ([card_url hasPrefix:@"/"]) {
                
                card_url = [card_url substringFromIndex:1]; 
            }
            
            NSString *uulStr = BASE_URL(card_url);
            
            [self.addimageBtn sd_setImageWithURL:[NSURL URLWithString:uulStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shenfenzheng"]];
            
        self.namefield.text = cust.name; 
        self.zhengjiannumfield.text = cust.id_number;         
        [self.leixingBtn setTitle:cust.type_name forState:UIControlStateNormal] ;
            
            NSArray *arr = @[@"身份证",@"港澳通行证",@"台湾通行证",@"护照"];
            NSInteger zjlx =cust.id_type-1;
            
            if (zjlx>arr.count-1) {
                zjlx = arr.count-1;
                
            }
            [self.zhengjianlxbtn setTitle:arr[zjlx] forState:UIControlStateNormal];

        }
    }
    
    if (!_isLook) {
        
    }
    else{
        if (_is12306Edit) {
            
            
        }
    }
    self.addimgBgview.hidden = YES;
}

#pragma mark 点击确定
-(void)sureChange{
    
    if (_namefield.text.length<1) {
        
        return;
    }
    if (_zhengjiannumfield.text.length<1) {
        return;
    }
    NSString *utk = UToken;
    if (!utk) {
        return;
    }
//    UToken				*******			登录获取到的utoken
//    name				张三   			乘车人姓名
//    type				1/2  			1为成人；2为儿童
//    ID_type				1/2/3/4			证件类型；1：身份证；2：港澳通信证；3：台湾通行证；4：护照
//    ID_number			***  			证件号码；最长30位		
//    ID_imgurl
    NSString *type = [_leixingBtn.currentTitle isEqualToString:@"成人"]?@"1":@"2";
    NSString *zjtype = @"1";
    if ([_zhengjianlxbtn.currentTitle containsString:@"身份证"]) {
        zjtype = @"1";
    }else if ([_zhengjianlxbtn.currentTitle containsString:@"港澳通行证"]) {
        zjtype = @"2";
    }else if ([_zhengjianlxbtn.currentTitle containsString:@"台湾通行证"]) {
        zjtype = @"3";
    }else if ([_zhengjianlxbtn.currentTitle containsString:@"护照"]) {
        zjtype = @"4";
    }
    NSString *personid = @"0";
    if (self.preObjvalue) {
        Customer *obj = self.preObjvalue;
        personid = obj.person_id;
    }
    if (!card_url) {
        card_url = @"";
    }
    
    NSString *LoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
    NSString *LoginUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
    NSDictionary * dic = [NSDictionary dictionary];
    NSDictionary * account = [NSDictionary dictionary];
    NSString *url = @"";
    
    if (!_is12306Edit) {
        //修改本地联系人
        if (self.preObjvalue) {
             dic = [self getparametersWithDic:@{@"UToken":UToken,@"name":_namefield.text,@"type":type ,@"ID_type":zjtype,@"ID_number":_zhengjiannumfield.text,@"ID_imgurl":card_url?card_url:@" ",@"id":personid}];
            url = @"Action/upUserContacts/";
        }
        else{
            //本地添加联系人
           dic = [self getparametersWithDic:@{@"UToken":UToken,@"name":_namefield.text,@"type":type ,@"ID_type":zjtype,@"ID_number":_zhengjiannumfield.text,@"id_imgurl":card_url}];
            url = @"Action/addUserContacts/";
        }
    }
    //12306联系人
    else{
        
        type = [_leixingBtn.currentTitle isEqualToString:@"成人"]?@"1":@"2";
        if ([_leixingBtn.currentTitle isEqualToString:@"成人"]) {
            type = @"0";
        }else if ([_leixingBtn.currentTitle isEqualToString:@"儿童"]) {
            type = @"1";
        }else if ([_leixingBtn.currentTitle isEqualToString:@"学生"]) {
            type = @"2";
        }
        
        if ([_zhengjianlxbtn.currentTitle containsString:@"身份证"]) {
            zjtype = @"1";
        }else if ([_zhengjianlxbtn.currentTitle containsString:@"港澳通行证"]) {
            zjtype = @"C";
        }else if ([_zhengjianlxbtn.currentTitle containsString:@"台湾通行证"]) {
            zjtype = @"G";
        }else if ([_zhengjianlxbtn.currentTitle containsString:@"护照"]) {
            zjtype = @"B";
        }
        
        //12306添加联系人
        if (!self.preObjvalue) {
            account = @{@"trainAccount":LoginUserName,@"pass":LoginUserPassword,@"contacts":@[@{@"id":@"0",@"name":_namefield.text,@"sex":@"0",@"birthday":@"",@"country":@"CN",@"identyType":zjtype,@"personType":type,@"identy":_zhengjiannumfield.text,@"phone":@"",@"tel":@"",@"email":@"",@"address":@""}]};
            
        }
        //12306编辑联系人
        else{
            account = @{@"trainAccount":LoginUserName,@"pass":LoginUserPassword,@"contacts":@[@{@"id":@"1",@"name":_namefield.text,@"sex":@"0",@"birthday":@"",@"country":@"CN",@"identyType":zjtype,@"personType":type,@"identy":_zhengjiannumfield.text,@"phone":@"",@"tel":@"",@"email":@"",@"address":@""}]};
            
        }
        NSString *kkey = @"v66r9ogtcvtxv3v4xq3gog8fqdbhwmt0";
        
        NSString *desSTr = [[account mj_JSONString] desEncryptWithKey:kkey];
        NSDictionary *postPar = @{@"data":desSTr,@"accountversion":@"2"} ;
        url = @"open/new_addoredit/";
        
        [BHUD showLoading:@"加载中"];
        [[NetRequest shareRequest]requestWithUrl:@"http://trainorder.ws.hangtian123.com/cn_interface/trainAccount/contact/saveOrUpdate" parameters:[postPar mj_JSONString] isJsonpar:YES isPost:YES andComplain:^(id obj) {
            [BHUD dismissHud];
            NSString * errorMsg = obj[@"errorMsg"];
            if ([obj[@"returnCode"] integerValue] == 231000) {
                if (self.touchEvent) {
                    self.touchEvent(@"");
                    
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    POP;
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showHudWithString:errorMsg model:MBProgressHUDModeCustomView];
                });
            }
        } andError:^(id error) {
            NSLog(@"error-------%@",error);
        }];
        return;
    }
    
    [[Httprequest shareRequest] postObjectByParameters:dic andUrl:url showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            if (self.touchEvent) {
                self.touchEvent(@"");

            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                POP;
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showHudWithString:obj[@"msg"] model:MBProgressHUDModeCustomView];
            });
        }
    } andError:nil];
}

- (IBAction)chengkeleixing:(UIButton *)sender {
    
    [self.view endEditing:YES];
    NSArray *arr = @[@"成人",@"儿童",@"学生"];
    CBAlertView *view = [[CBAlertView alloc]initWithTitle:@"请选择乘客类型" actionsTitles:arr imgnames:nil showCancel:YES showSure:NO event:^(id value) {
        [sender setTitle:arr[[value integerValue]] forState:UIControlStateNormal];
    }];
    
    
}
- (IBAction)shenfenleixing:(UIButton *)sender {
    
    [self.view endEditing:YES];
    NSArray *arr = @[@"身份证",@"港澳通行证",@"台湾通行证",@"护照"];
    CBAlertView *view = [[CBAlertView alloc]initWithTitle:@"乘客类型" actionsTitles:arr imgnames:nil showCancel:YES showSure:NO event:^(id value) {
        [sender setTitle:arr[[value integerValue]] forState:UIControlStateNormal];
    }];
}

#pragma mark 删除
- (void)shanchuAct:(UIButton *)sender {
    [self.view endEditing:YES];

    if (!self.preObjvalue) {
        return;
    }
    Customer *cus = self.preObjvalue;
    NSString *url = @"Action/delUserContacts/";
    id postDic = [self getparametersWithDic:@{@"UToken":UToken,@"id":cus.person_id}];
    if (_is12306Edit&&_isLook) {
        NSString *LoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"zh12306"];
        NSString *LoginUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"mm12306"];
        url = @"Action/deluser/";
        postDic = [self getparametersWithDic:@{@"UToken":UToken,@"id":cus.person_id,@"trainAccount":LoginUserName,@"pass":LoginUserPassword}];
    }
    
    [[Httprequest shareRequest] postObjectByParameters:postDic andUrl:url showLoading:YES showMsg:YES isFullUrk:NO andComplain:^(id obj) {
        if ([obj[@"code"] integerValue] == 1) {
            if (self.touchEvent) {
                self.touchEvent(@"");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                POP;
            });
        }
    } andError:nil];
}

#pragma mark - 选取照片
- (IBAction)changeHeadIM:(id)sender {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:actioncancle];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开照相机拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            //拍照后的图片可以编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    [alertVC addAction:action1];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开本地相册
         [self LocalPhoto];
    }];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark  选择相册中的照片
- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //选择选中的图片可以编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 选择一张图片执行的函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    if ([type isEqualToString:@"public.image"]) {
        //先把图片转化为二进制
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data = UIImageJPEGRepresentation(image, 0.2);
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        choosedData = data;
        choosedImage = image;
        
        [self changeHeadimg];
    
    }
}

-(void)changeHeadimg{
    //    person/changeHeadImg.action
    //fileImage
    [[Httprequest shareRequest] postImageByUrl:@"Index/upImg/" withParameters:nil andImageData:choosedData imageKey:@"fileImage" andComplain:^(id obj) {
        if ([obj[@"code"] integerValue]==1) {
            card_url = obj[@"data"][@"filePath"];
            [self.addimageBtn setImage:choosedImage forState:UIControlStateNormal];
            
        }
    } andError:^(id error) {
        
    }];
}

@end
