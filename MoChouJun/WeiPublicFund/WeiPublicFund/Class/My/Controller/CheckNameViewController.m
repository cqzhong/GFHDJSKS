//
//  CheckNameViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/13.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "CheckNameViewController.h"
#import "User.h"

@interface CheckNameViewController ()

@end

@implementation CheckNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self backBarItem];
    
    _checkNameBtn.layer.cornerRadius = 5.0f;
    _checkNameBtn.userInteractionEnabled = NO;
    _checkNameBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [_checkNameBtn addTarget:self action:@selector(checkNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_realNameTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
//    [_realNameTextField becomeFirstResponder];
    [_idTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (!IsStrEmpty(_userStr) && !IsStrEmpty(_idStr)) {
        _idTextField.text = [NSString stringWithFormat:@"%@**********%@",[_idStr substringToIndex:3],[_idStr substringFromIndex:_idStr.length - 4]];
        _realNameTextField.text = _userStr;
        _idTextField.userInteractionEnabled = NO;
        _realNameTextField.userInteractionEnabled = NO;
        _checkNameBtn.hidden = YES;
    }else{
        _idTextField.userInteractionEnabled = YES;
        _realNameTextField.userInteractionEnabled = YES;
        _checkNameBtn.hidden = NO;
    }
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_realNameTextField.text)) {
        _checkNameBtn.userInteractionEnabled = NO;
        _checkNameBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }else if (IsStrEmpty(_idTextField.text)) {
        _checkNameBtn.userInteractionEnabled = NO;
        _checkNameBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }else if (!IsStrEmpty(_realNameTextField.text) && !IsStrEmpty(_idTextField.text)) {
        _checkNameBtn.userInteractionEnabled = YES;
        _checkNameBtn.backgroundColor = [UIColor colorWithHexString:@"#F3A742"];
    }
}

- (void)checkNameBtnClick:(UIButton *)sender
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Personal/RealNameAuth" parameters:@{@"RealName":_realNameTextField.text,@"IdNumber":_idTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 2 || status == 1) {
            User *user = [User shareUser];
            user.realName = _realNameTextField.text;
            [user saveUser];
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"陛下,您是有身份的人"];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
        }
    }];
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}
@end