//
//  AccountManageViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AccountManageViewController.h"
#import "AccountManageTableViewCell.h"
#import "BankCard.h"

@interface AccountManageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *accountManageTableView;
@property (nonatomic,strong)NSArray *accountMutableArr;
@end

@implementation AccountManageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavi];
    [self setTableView];
    [self getAccountDataInfo];
}

- (void)setTableView
{
    [_accountManageTableView registerNib:[UINib nibWithNibName:@"AccountManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountManageTableViewCell"];
}

- (void)setNavi
{
    self.title = @"银行卡管理";
    [self backBarItem];
}

#pragma mark - Request
- (void)getAccountDataInfo
{
    [self.httpUtil requestArr4MethodName:@"Account/BankcardList" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _accountMutableArr = arr;
            if (_accountMutableArr.count == 0) {
                self.hideNoMsg = NO;
            }else{
                self.hideNoMsg = YES;
                [_accountManageTableView reloadData];
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } convertClassName:@"BankCard" key:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _accountMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AccountManageTableViewCell";
    AccountManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AccountManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bankCard = [_accountMutableArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.delgate) return;
    BankCard *bankCard = _accountMutableArr[indexPath.row];
    if ([self.delgate respondsToSelector:@selector(optionBankCard:)])
    {
        [self.delgate optionBankCard:bankCard];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end