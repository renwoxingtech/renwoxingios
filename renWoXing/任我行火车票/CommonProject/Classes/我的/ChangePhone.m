//
//  ChangePhone.m
//  CommonProject
//
//  Created by mac on 2017/1/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChangePhone.h"

@interface ChangePhone ()

@end

@implementation ChangePhone

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)sjh:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _phoneField.hidden = NO;
    _phoneField.secureTextEntry = YES;
    if (btn.height>30) {
        [_phoneField becomeFirstResponder];
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.height = 15;
            btn.titleLabel.font = Font(13);
        }];
    }
}

- (IBAction)sure:(id)sender {
    if (self.phoneField.text.length<1) {
        return;
    }
    BaseViewController *base = (BaseViewController *)[self getVCInBoard:nil ID:@"ChangePhone2"];
    base.preObjvalue = self.phoneField.text;
    PUSH(base);
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_phoneField.text.length<1) {
        
        
        if (_phoneBtn.height<30) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                _phoneBtn.height = 44;
                _phoneBtn.titleLabel.font = Font(15);
            }];
        }
    }

    if (_phoneField.text.length>4 ) {
        
        _wcbtn.backgroundColor = BlueColor;
    }else{
        _wcbtn.backgroundColor = [UIColor lightGrayColor];
        
    }
    
}
@end
