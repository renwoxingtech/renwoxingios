//
//  ChooseSeatView.m
//  CommonProject
//
//  Created by 任我行 on 2017/10/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChooseSeatView.h"
#define Margin 8
@interface ChooseSeatView(){
    BOOL _isSelect;
}

@property(nonatomic,strong)NSArray * seatTypeArray;
@property(nonatomic,strong)NSArray * TwoTypeImageSelectArray;
@property(nonatomic,strong)NSArray * TwoTypeImageArray;
@property(nonatomic,weak) UIView * seatType_View;
@property(nonatomic,strong)NSArray * OneTypeImageArray;
@property(nonatomic,strong)NSArray * OneTypeImageSelectArray;

@property(nonatomic,strong)NSArray * SanTypeImageArray;
@property(nonatomic,strong)NSArray * SanTypeImageSelectArray;
@property(nonatomic,strong)NSMutableArray * chooseTypeArrayMu;
@property(nonatomic,strong)NSMutableArray * tagBtnArrayMu;
@property(nonatomic,strong)NSMutableArray <UIButton*> * selectArrayMu;
@end

@implementation ChooseSeatView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelect = NO;
        self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:9 / 255.0 blue:31 / 255.0 alpha:0.5];
        _chooseTypeArrayMu = [NSMutableArray array];
        _tagBtnArrayMu = [NSMutableArray array];
        _selectArrayMu = [NSMutableArray array];
        _seatTypeArray = @[@"靠窗",@"过道",@"靠窗"];
        _TwoTypeImageSelectArray = @[@"Azuo_blue_icon",@"Bzuo_blue_icon",@"czuo_blue_icon",@"Dzuo_blue_icon",@"Fzuo_blue_icon"];
        _TwoTypeImageArray = @[@"Azuo_icon",@"Bzuo_icon",@"Czuo_icon",@"Dzuo_icon",@"Fzuo_icon"];
        _OneTypeImageSelectArray = @[@"Azuo_blue_icon",@"czuo_blue_icon",@"Dzuo_blue_icon",@"Fzuo_blue_icon"];
        _OneTypeImageArray = @[@"Azuo_icon",@"Czuo_icon",@"Dzuo_icon",@"Fzuo_icon"];
        _SanTypeImageSelectArray = @[@"Azuo_blue_icon",@"czuo_blue_icon",@"Fzuo_blue_icon"];
        _SanTypeImageArray = @[@"Azuo_icon",@"Czuo_icon",@"Fzuo_icon"];
//        [self creatView];
       
    }
    return self;
}

- (void)getCustomerArray:(NSArray *)customerArray seatString:(NSString *)seatString{
    self.customerArray = customerArray;
    self.seatType = seatString;
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT - 176)];
    topView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:9 / 255.0 blue:31 / 255.0 alpha:0.5];
    [self addSubview:topView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)];
    tap.numberOfTapsRequired = 1;
    [topView addGestureRecognizer:tap];
    
    UIView * seatTypeView = [[UIView alloc]initWithFrame:CGRectMake(0,SHEIGHT - 176, SWIDTH, 176 )];
    
    seatTypeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:seatTypeView];
    
    UIView * ifView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWIDTH, 49)];
    ifView.backgroundColor = [UIColor colorWithRed:9 / 255.0 green:20 / 255.0 blue:29 / 255.0 alpha:0.9];
    [seatTypeView addSubview:ifView];
    
    UIButton * false_Btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 50, ifView.height)];
    [false_Btn setTitle:@"取消" forState:UIControlStateNormal];
    [false_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    false_Btn.titleLabel.font = [UIFont mysystemFontOfSize:17];
    [false_Btn addTarget:self action:@selector(clickView) forControlEvents:UIControlEventTouchUpInside];
    [ifView addSubview:false_Btn];
    
    UIButton * true_Btn = [[UIButton alloc]initWithFrame:CGRectMake(SWIDTH - 15 - false_Btn.width,0 , false_Btn.width, ifView.height)];
    [true_Btn setTitle:@"确定" forState:UIControlStateNormal];
    [true_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    true_Btn.titleLabel.font = [UIFont mysystemFontOfSize:17];
    [true_Btn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    [ifView addSubview:true_Btn];
    
    
    
    UILabel * chooseSeat_Label = [[UILabel alloc]initWithFrame:CGRectMake(self.centerX - 100, 0, 200, ifView.height)];
    chooseSeat_Label.text = @"选择坐席";
    chooseSeat_Label.textAlignment = NSTextAlignmentCenter;
    chooseSeat_Label.textColor = [UIColor whiteColor];
    chooseSeat_Label.font = [UIFont mysystemFontOfSize:17];
    [ifView addSubview:chooseSeat_Label];
    
    UIView * explain_View = [[UIView alloc]initWithFrame:CGRectMake(0, ifView.bottom, SWIDTH, 45)];
    [seatTypeView addSubview:explain_View];
    
    UILabel * show_Label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SWIDTH - 30, explain_View.height)];
    show_Label.text = @"优先按指定座席出票,若指定座席无票,将转购其他座席";
    show_Label.font = [UIFont mysystemFontOfSize:14];
    show_Label.textColor = qiColor;
    [explain_View addSubview:show_Label];
    
    UIView * line_View = [[UIView alloc]initWithFrame:CGRectMake(0, show_Label.bottom - 1, SWIDTH, 1)];
    line_View.backgroundColor = E5Color;
    [explain_View addSubview:line_View];
    
    UIView * seatType_View = [[UIView alloc]init];
    self.seatType_View = seatType_View;
    [seatTypeView addSubview:seatType_View];
    
    NSInteger i = 2;//乘客数量
    NSInteger HeightView = 29;
    NSInteger j = 1;//座位类型
    CGFloat TwoHeight = 39;
    if ([self.seatType isEqualToString:@"二等座"]) {
        j = 2;
    }
    else if ([self.seatType isEqualToString:@"一等座"]){
        j = 1;
    }
    else{
        j = 0;
    }
    if (self.customerArray.count <= 1) {
        i = 1;
    }
    else {
        i = 2;
    }
    
    if (j == 2) {
        if (i == 1) {
            seatType_View.frame = CGRectMake((SWIDTH - 311)/ 2, 18 + explain_View.bottom,311, HeightView );
        }
        else{
            seatType_View.frame = CGRectMake((SWIDTH - 311)/ 2, 7 + explain_View.bottom, 311, 68);
        }
        
        for (int i = 0 ; i < 8 ; i++) {
            
            if (i == 0 ) {
                [self creatWithLabelFrame:CGRectMake(0,0,30,HeightView) withnumber:0];
            }
            else if (i == 1 || i == 2 || i == 3) {
                UIButton *button = [[UIButton alloc]init];
                button.frame = CGRectMake(30 + Margin * i + 33 * (i - 1), 0, 33, HeightView);
                button.tag = 101 + i;
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[i - 1]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [seatType_View addSubview:button];
            }
            else if (i == 4){
                
                [self creatWithLabelFrame:CGRectMake(30 + Margin * i + 33 * (i - 1), 0, 30, HeightView) withnumber:1];
                
            }
            else if (i == 5 || i == 6){
                
                UIButton *button = [[UIButton alloc]init];
                button.frame = CGRectMake( 30 + Margin * i + 33 * (i - 1) - 3, 0, 33, HeightView);
                button.tag = 101 + i;
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[i - 2]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [seatType_View addSubview:button];
                
            }
            else{
                [self creatWithLabelFrame:CGRectMake(30 + Margin * i + 33 * (i - 1) - 3, 0, 30, HeightView) withnumber:2];
            }
        }
        
        if (i == 2) {
            
            
            
            for (int i = 0 ; i < 8 ; i++) {
                
                if (i == 0 ) {
                    [self creatWithLabelFrame:CGRectMake(0,TwoHeight,30,HeightView) withnumber:0];
                    continue;
                }
                else if (i == 1 || i == 2 || i == 3) {
                    UIButton *button = [[UIButton alloc]init];
                    button.frame = CGRectMake(30 + Margin * i + 33 * (i - 1), TwoHeight, 33, HeightView);
                    button.tag = 201 + i;
                    [button setImage:[UIImage imageNamed:_TwoTypeImageArray[i - 1]] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [seatType_View addSubview:button];
                }
                else if (i == 4){
                    
                    [self creatWithLabelFrame:CGRectMake(30 + Margin * i + 33 * (i - 1), TwoHeight, 30, HeightView) withnumber:1];
                    
                }
                else if (i == 5 || i == 6){
                    
                    UIButton *button = [[UIButton alloc]init];
                    button.frame = CGRectMake( 30 + Margin * i + 33 * (i - 1) - 3, TwoHeight, 33, HeightView);
                    button.tag = 201 + i;
                    [button setImage:[UIImage imageNamed:_TwoTypeImageArray[i - 2]] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [seatType_View addSubview:button];
                    
                }
                else{
                    [self creatWithLabelFrame:CGRectMake(30 + Margin * i + 33 * (i - 1) - 3, TwoHeight, 30, HeightView) withnumber:2];
                }
            }
        }
        
    }
    else if (j == 1){
        if (i == 1) {
            seatType_View.frame = CGRectMake((SWIDTH - 270)/ 2, 18 + explain_View.bottom,270, HeightView );
        }
        else{
            seatType_View.frame = CGRectMake((SWIDTH - 270)/ 2, 7 + explain_View.bottom, 270, 68);
        }
        for (int i = 0 ; i < 7; i++) {
            
            if (i == 0) {
                [self creatWithLabelFrame:CGRectMake(0, 0, 30, HeightView) withnumber:0];
            }
            else if (i == 1 || i == 2){
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), 0, 33, HeightView)];
                button.tag = 101 + i;
                [button setImage:[UIImage imageNamed:_OneTypeImageArray[i - 1]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [seatType_View addSubview:button];
            }
            else if (i == 3){
                [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), 0, 33, HeightView) withnumber:1];
            }
            else if (i == 4 || i == 5){
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, 0, 33, HeightView)];
                button.tag = 101 + i;
                [button setImage:[UIImage imageNamed:_OneTypeImageArray[i - 2]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [seatType_View addSubview:button];
            }
            else{
                [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, 0, 33, HeightView) withnumber:2];
            }
            
        }
        if (i == 2) {
            
            for (int i = 0 ; i < 7; i++) {
                
                if (i == 0) {
                    [self creatWithLabelFrame:CGRectMake(0, TwoHeight, 30, TwoHeight) withnumber:0];
                }
                else if (i == 1 || i == 2){
                    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), TwoHeight, 33, TwoHeight)];
                    button.tag = 201 + i;
                    [button setImage:[UIImage imageNamed:_OneTypeImageArray[i - 1]] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [seatType_View addSubview:button];
                }
                else if (i == 3){
                    [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), TwoHeight, 33, TwoHeight) withnumber:1];
                }
                else if (i == 4 || i == 5){
                    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, TwoHeight, 33, TwoHeight)];
                    button.tag = 201 + i;
                    [button setImage:[UIImage imageNamed:_OneTypeImageArray[i - 2]] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [seatType_View addSubview:button];
                }
                else{
                    [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, TwoHeight, 33, TwoHeight) withnumber:2];
                }
            }
            
            
        }
        
        
    }
    
    else {
        if (i == 1) {
            seatType_View.frame = CGRectMake((SWIDTH - 229)/ 2, 18 + explain_View.bottom,229, HeightView );
        }
        else{
            seatType_View.frame = CGRectMake((SWIDTH - 229)/ 2, 7 + explain_View.bottom, 229, 68);
        }
        for (int i = 0 ; i < 6; i++) {
            
            if (i == 0) {
                [self creatWithLabelFrame:CGRectMake(0, 0, 30, HeightView) withnumber:0];
            }
            else if (i == 1 || i == 2){
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), 0, 33, HeightView)];
                button.tag = 101 + i;
                [button setImage:[UIImage imageNamed:_SanTypeImageArray[i - 1]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [seatType_View addSubview:button];
            }
            else if (i == 3){
                [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), 0, 33, HeightView) withnumber:1];
            }
            else if (i == 4 ){
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, 0, 33, HeightView)];
                button.tag = 101 + i;
                [button setImage:[UIImage imageNamed:_SanTypeImageArray[i - 2]] forState:UIControlStateNormal];
                 [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [seatType_View addSubview:button];
            }
            else{
                [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, 0, 33, HeightView) withnumber:2];
            }
            
        }
        if (i == 2) {
            
            for (int i = 0 ; i < 6; i++) {
                
                if (i == 0) {
                    [self creatWithLabelFrame:CGRectMake(0, TwoHeight, 30, TwoHeight) withnumber:0];
                }
                else if (i == 1 || i == 2){
                    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), TwoHeight, 33, TwoHeight)];
                    button.tag = 201 + i;
                    [button setImage:[UIImage imageNamed:_SanTypeImageArray[i - 1]] forState:UIControlStateNormal];
                     [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [seatType_View addSubview:button];
                }
                else if (i == 3){
                    [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1), TwoHeight, 33, TwoHeight) withnumber:1];
                }
                else if (i == 4){
                    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, TwoHeight, 33, TwoHeight)];
                    button.tag = 201 + i;
                    [button setImage:[UIImage imageNamed:_SanTypeImageArray[i - 2]] forState:UIControlStateNormal];
                     [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [seatType_View addSubview:button];
                }
                else{
                    [self creatWithLabelFrame:CGRectMake(30 + 8 * i + 33 * (i - 1) - 3, TwoHeight, 33, TwoHeight) withnumber:2];
                }
            }
            
            
        }
        
        
    }
}

- (void)clickBtn:(UIButton *)button{
//    _isSelect = !_isSelect;
    NSString * chooseType = nil;
    if ([self.seatType isEqualToString:@"二等座"]) {
        
        if (button.tag == 102 ) {
   
            chooseType = @"1A";
        }
        else if (button.tag == 202){
            chooseType = @"2A";
        }
        else if (button.tag == 103){
      
            chooseType = @"1B";
        }
        else if (button.tag == 203){
            chooseType = @"2B";
        }
        else if (button.tag == 104){
        
            chooseType = @"1C";
        }
        else if (button.tag == 204){
            chooseType = @"2C";
        }
        else if (button.tag == 106){
          
            chooseType = @"1D";
        }
        else if (button.tag == 206){
            chooseType = @"2D";
        }
        else if (button.tag == 107){
            chooseType = @"1F";
        }
        else{
  
            chooseType = @"2F";
        }
        
    }
    else if ([self.seatType isEqualToString:@"一等座"]){
        if (button.tag == 102) {
 
            chooseType = @"1A";
        }
        else if (button.tag == 102){
            chooseType = @"2A";
        }
        else if (button.tag == 103){

            chooseType = @"1C";
        }
        else if (button.tag == 203){
            chooseType = @"2C";
        }
        else if (button.tag == 105){

            chooseType = @"1D";
        }
        else if (button.tag == 205){
            chooseType = @"2D";
        }
        else if (button.tag == 206){
            chooseType = @"1F";
        }
        else {

            chooseType = @"2F";
        }
        
    }
    else{
        if (button.tag == 102) {
      
            chooseType = @"1A";
        }
        else if (button.tag == 202){
            chooseType = @"2A";
        }
        else if (button.tag == 103){
       
            chooseType = @"1C";
        }
        else if (button.tag == 203){
            chooseType = @"1C";
        }
        else if (button.tag == 105){
            chooseType = @"1F";
        }
        
        else {
   
            chooseType = @"2F";
        }
        
    }
    
    if (self.chooseTypeArrayMu.count < self.customerArray.count ) {
        
        NSString * typeSeatString = @"";
        for (NSString * typeSreat in _chooseTypeArrayMu) {
            if ([chooseType isEqualToString:typeSreat]) {
                typeSeatString = [NSString stringWithFormat:@"%@",typeSreat];
            }
        }
        if ([chooseType isEqualToString:typeSeatString]) {
            button.userInteractionEnabled = !button.userInteractionEnabled;
            [_selectArrayMu addObject:button];
            [_chooseTypeArrayMu removeObject:chooseType];
            [_tagBtnArrayMu removeObject:@(button.tag)];
        }
        else{
            button.userInteractionEnabled = YES;
            
            [_chooseTypeArrayMu addObject:chooseType];
            [_tagBtnArrayMu addObject:@(button.tag)];
            NSLog(@"点过的YES-%@,%@,tag - %ld %@",chooseType,_chooseTypeArrayMu,(long)button.tag,_tagBtnArrayMu);
        }
    }
    else{
        if (_chooseTypeArrayMu.count > 0 ) {
            [_chooseTypeArrayMu removeObject:chooseType];
        }
        if (_tagBtnArrayMu.count > 0) {
            [_tagBtnArrayMu removeObject:@(button.tag)];
        }
        NSLog(@"点过的NO-%@,%@,tag - %ld %@",chooseType,_chooseTypeArrayMu,(long)button.tag,_tagBtnArrayMu);
        
        button.userInteractionEnabled = NO;
        [_selectArrayMu addObject:button];
    }

    


    
if (button.userInteractionEnabled) {
    if ([self.seatType isEqualToString:@"二等座"]) {
        
        if (button.tag == 102 || button.tag == 202) {
            [button setImage:[UIImage imageNamed:_TwoTypeImageSelectArray[0]] forState:UIControlStateNormal];

        }
        else if (button.tag == 103 || button.tag == 203){
            [button setImage:[UIImage imageNamed:_TwoTypeImageSelectArray[1]] forState:UIControlStateNormal];

        }
        else if (button.tag == 104 || button.tag == 204){
            [button setImage:[UIImage imageNamed:_TwoTypeImageSelectArray[2]] forState:UIControlStateNormal];

        }
        else if (button.tag == 106 || button.tag == 206){
            [button setImage:[UIImage imageNamed:_TwoTypeImageSelectArray[3]] forState:UIControlStateNormal];

        }
        else{
            [button setImage:[UIImage imageNamed:_TwoTypeImageSelectArray[4]] forState:UIControlStateNormal];

        }
        
    }
    else if ([self.seatType isEqualToString:@"一等座"]){
        if (button.tag == 102 || button.tag == 202) {
            [button setImage:[UIImage imageNamed:_OneTypeImageSelectArray[0]] forState:UIControlStateNormal];

        }
        else if (button.tag == 103 || button.tag == 203){
            [button setImage:[UIImage imageNamed:_OneTypeImageSelectArray[1]] forState:UIControlStateNormal];

        }
        else if (button.tag == 105 || button.tag == 205){
            [button setImage:[UIImage imageNamed:_OneTypeImageSelectArray[2]] forState:UIControlStateNormal];

        }
        else {
            [button setImage:[UIImage imageNamed:_OneTypeImageSelectArray[3]] forState:UIControlStateNormal];

        }
        
    }
    else{
        if (button.tag == 102 || button.tag == 202) {
            [button setImage:[UIImage imageNamed:_SanTypeImageSelectArray[0]] forState:UIControlStateNormal];

        }
        else if (button.tag == 103 || button.tag == 203){
            [button setImage:[UIImage imageNamed:_SanTypeImageSelectArray[1]] forState:UIControlStateNormal];

        }
        else {
            [button setImage:[UIImage imageNamed:_SanTypeImageSelectArray[2]] forState:UIControlStateNormal];

        }
    }
}
    else{
        if ([self.seatType isEqualToString:@"二等座"]) {
            
            if (button.tag == 102 || button.tag == 202) {
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[0]] forState:UIControlStateNormal];

            }
            else if (button.tag == 103 || button.tag == 203){
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[1]] forState:UIControlStateNormal];
  
            }
            else if (button.tag == 104 || button.tag == 204){
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[2]] forState:UIControlStateNormal];
         
            }
            else if (button.tag == 106 || button.tag == 206){
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[3]] forState:UIControlStateNormal];
             
            }
            else{
                [button setImage:[UIImage imageNamed:_TwoTypeImageArray[4]] forState:UIControlStateNormal];
               
            }
            
        }
        else if ([self.seatType isEqualToString:@"一等座"]){
            if (button.tag == 102 || button.tag == 202) {
                [button setImage:[UIImage imageNamed:_OneTypeImageArray[0]] forState:UIControlStateNormal];
             
            }
            else if (button.tag == 103 || button.tag == 203){
                [button setImage:[UIImage imageNamed:_OneTypeImageArray[1]] forState:UIControlStateNormal];
              
            }
            else if (button.tag == 105 || button.tag == 205){
                [button setImage:[UIImage imageNamed:_OneTypeImageArray[2]] forState:UIControlStateNormal];
              
            }
            else {
                [button setImage:[UIImage imageNamed:_OneTypeImageArray[3]] forState:UIControlStateNormal];
              
            }
            
        }
        else{
            if (button.tag == 102 || button.tag == 202) {
                [button setImage:[UIImage imageNamed:_SanTypeImageArray[0]] forState:UIControlStateNormal];
                
            }
            else if (button.tag == 103 || button.tag == 203){
                [button setImage:[UIImage imageNamed:_SanTypeImageArray[1]] forState:UIControlStateNormal];
                
            }
            else {
                [button setImage:[UIImage imageNamed:_SanTypeImageArray[2]] forState:UIControlStateNormal];
             
            }
            
        }
    }
    
//    if (self.chooseTypeArrayMu.count <= self.customerArray.count) {
        if (_selectArrayMu.count > 0) {
            for (UIButton * buttonOld in _selectArrayMu) {
                buttonOld.userInteractionEnabled = YES;
//                _isSelect = NO;
            }
            [_selectArrayMu removeAllObjects];
        }
//    }
    return;
}

#pragma mark 点击屏幕
- (void)clickView{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:nil];
}

#pragma mark 点击确定
- (void)clickSure:(UIButton *)button{
    if (_chooseTypeArrayMu.count < _customerArray.count) {
        [MBProgressHUD showHudWithString:@"请按照乘车人个数选择对应的席位!" model:MBProgressHUDModeCustomView];
    }
    else{
        if (self.chooseSeatBlock) {
            self.chooseSeatBlock(_chooseTypeArrayMu.copy, _tagBtnArrayMu.copy);
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:nil];
    }
}

- (void)creatWithLabelFrame:(CGRect)frame withnumber:(NSInteger)number{
    
    UILabel * kaoCLabel = [[UILabel alloc]initWithFrame:frame];
    kaoCLabel.text = _seatTypeArray[number];
    kaoCLabel.textColor = qiColor;
    kaoCLabel.font = [UIFont mysystemFontOfSize:13];
    kaoCLabel.textAlignment = NSTextAlignmentCenter;
    [self.seatType_View addSubview:kaoCLabel];
}
     
- (UIViewController *)viewController

{
    
    UIResponder * next = [self nextResponder];
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    }
    
   return nil;
    
}
@end
