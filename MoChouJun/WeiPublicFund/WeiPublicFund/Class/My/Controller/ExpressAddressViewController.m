//
//  ExpressAddressViewController.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/16.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ExpressAddressViewController.h"
#import "AddExpressAddressViewController.h"
#import "ExpressAddresseCell.h"
#import "AddExpressAddressViewController.h"
#import "Address.h"

@interface ExpressAddressViewController ()<UITableViewDataSource,UITableViewDelegate,ExpressAddresseCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *addressList;
@end

@implementation ExpressAddressViewController

- (void)viewDidLoad
{
    self.hideBottomBar = YES;
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    [self setupHeaderRefresh:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self headerRefreshloadData];
}

- (NSMutableArray *)addressList
{
    if (!_addressList)
    {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}

#pragma mark - Override
- (void)headerRefreshloadData
{
    [self requestExpressAddressList];
}

#pragma mark - Request 
- (void)requestExpressAddressList
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"Address/Get" parameters:@{@"PageIndex":@1,@"PageSize":@100} result:^(NSArray *arr, int status, NSString *msg)
    {
        [_tableView.mj_header endRefreshing];
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            
            [self.addressList removeAllObjects];
            [_addressList addObjectsFromArray:arr];
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
        
        if(_addressList.count == 0)
        {
            self.hideNoMsg = NO;
        }
        else
        {
            self.hideNoMsg = YES;
        }
    } convertClassName:@"Address" key:@"DataSet"];
}

#pragma mark - Private
- (void)setupNavi
{
    self.title = @"收货地址管理";
    [self backBarItem];
    [self setupBarButtomItemWithTitle:@"添加" target:self action:@selector(addExpressAddress) leftOrRight:NO];
}

- (void)setupTableView
{
    self.tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"ExpressAddresseCell" bundle:nil] forCellReuseIdentifier:@"ExpressAddresseCell"];
}

- (void)addExpressAddress
{
    AddExpressAddressViewController *vc = [[AddExpressAddressViewController alloc] init];
//    vc.showBackItem = YES;
    vc.type = @"添加";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ExpressAddresseCellDelegate
- (void)expressAddresseCellOptionDefaultAddress:(ExpressAddresseCell *)cell
{
    if (cell.address.statusId == 2) {
        return;
    }
    
    [self.httpUtil requestDic4MethodName:@"Address/SetDefault" parameters:@{@"Id":@(cell.address.Id)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            Address *address = _addressList[0];
            address.statusId = 1;
            
            cell.address.statusId = 2;
            NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
            [_addressList removeObjectAtIndex:indexPath.section];
            [_addressList insertObject:cell.address atIndex:0];
            [MBProgressHUD showSuccess:@"默认地址设置成功啦~(<)~" toView:self.view];
            [_tableView reloadData];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _addressList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressAddresseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressAddresseCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.address = _addressList[indexPath.section];
    cell.addressEditBtn.tag = indexPath.section;
    [cell.addressEditBtn addTarget:self action:@selector(addressEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteAddressBtn.tag = indexPath.section;
    [cell.deleteAddressBtn addTarget:self action:@selector(deleteAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

//   编辑地址
- (void)addressEditBtnClick:(UIButton *)sender
{
    //传值 跳转编辑
    AddExpressAddressViewController *vc = [[AddExpressAddressViewController alloc]init];
    vc.address = _addressList[sender.tag];
    vc.type = @"修改";
    [self.navigationController pushViewController:vc animated:YES];
}

//   删除地址
- (void)deleteAddressBtnClick:(UIButton *)sender
{
    Address *address = _addressList[sender.tag];
    
    [self.httpUtil requestDic4MethodName:@"Address/Delete" parameters:@{@"Id":@(address.Id)} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
             [_addressList removeObject:address];
             [_tableView reloadData];
             if(_addressList.count == 0)
             {
                 self.hideNoMsg = NO;
             }
             else
             {
                 self.hideNoMsg = YES;
             }
         }
         else
         {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //回调
    if ([self.delegate respondsToSelector:@selector(optionExpressAddress:)])
    {
        [self.delegate optionExpressAddress:_addressList[indexPath.section]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end