//
//  BankCard.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/2/18.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "BankCard.h"

@implementation BankCard
- (void)setAccountNum:(NSString *)accountNum
{
    _accountNum = accountNum;
    if (_accountNum.length > 10)
    {
        _transformAccountNum = [NSString stringWithFormat:@"**** **** **** %@",[accountNum substringFromIndex:accountNum.length - 4] ];
    }
    
}
@end