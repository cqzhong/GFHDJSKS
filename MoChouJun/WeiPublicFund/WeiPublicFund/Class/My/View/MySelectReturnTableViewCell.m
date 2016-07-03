//
//  MySelectReturnTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MySelectReturnTableViewCell.h"

@implementation MySelectReturnTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyInvestDic:(NSDictionary *)myInvestDic
{
    _myInvestDic = myInvestDic;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",[[_myInvestDic objectForKey:@"SupportAmount"] floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _myInvestMoneyLab.attributedText = atriText;
    
    _myInvestContentLab.text = [_myInvestDic objectForKey:@"Description"];
    _myInvestNumberLab.text = [NSString stringWithFormat:@"支持数量%@",[_myInvestDic objectForKey:@"Count"]];
    _myInvestDataLab.text = [_myInvestDic objectForKey:@"CreateDate"];
    
    if ([[_myInvestDic objectForKey:@"StatusId"] integerValue] == 2) {
        _stateLab.text = @"已回报";
        _stateLab.hidden = NO;
        _myInvestStateImageView.hidden = YES;
        self.userInteractionEnabled = NO;
    }else{
        _stateLab.hidden = YES;
        _myInvestStateImageView.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end