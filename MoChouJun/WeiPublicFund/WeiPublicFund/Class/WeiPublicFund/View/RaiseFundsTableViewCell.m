//
//  RaiseFundsTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/6.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "RaiseFundsTableViewCell.h"
#import "UIButton+EMWebCache.h"

@implementation RaiseFundsTableViewCell

- (void)awakeFromNib {
    // Initialization code

    _raiseFundUserIconBtn.layer.cornerRadius = 17.5f;
    _raiseFundUserIconBtn.layer.masksToBounds = YES;
}

- (void)setRaiseFundDic:(NSDictionary *)raiseFundDic
{
    _raiseFundDic = raiseFundDic;
    
    [_raiseFundUserIconBtn sd_setImageWithURL:[NSURL URLWithString:[raiseFundDic objectForKey:@"Avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    
    NSString *nickNameStr = IsStrEmpty([raiseFundDic objectForKey:@"NickName"])?[raiseFundDic objectForKey:@"UserName"]:[raiseFundDic objectForKey:@"NickName"];
    _userNameAddstateLab.text = [NSString stringWithFormat:@"%@   %@",nickNameStr,[raiseFundDic objectForKey:@"Title"]];
    NSInteger userNameLength = [nickNameStr length];
    NSMutableAttributedString *userStr = [[NSMutableAttributedString alloc]initWithString:_userNameAddstateLab.text];
    [userStr beginEditing];
    [userStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2EABE1"] range:NSMakeRange(userNameLength + 3, userStr.length - userNameLength - 3)];
    _userNameAddstateLab.attributedText = userStr;
    
//    _raiseReturnLab.text = [NSString stringWithFormat:@"%@",[_raiseFundDic objectForKey:@"Description"]];
//    NSMutableAttributedString *borrowStr = [[NSMutableAttributedString alloc]initWithString:_raiseReturnLab.text];
//    [borrowStr beginEditing];
//    [borrowStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6E6E6E"] range:NSMakeRange(0, 5)];
//    _raiseReturnLab.attributedText = borrowStr;
    
    _raiseStateTimeLab.text = [_raiseFundDic objectForKey:@"ShowTime"];
    
    _raiseReturnLab.text = [NSString stringWithFormat:@"%@",[_raiseFundDic objectForKey:@"Description"]];
//    [self setLabStyle:[NSString stringWithFormat:@"%@",[_raiseFundDic objectForKey:@"Description"]]];
}

- (void)setLabStyle:(NSString *)returnContentStr
{
    if (SCREEN_WIDTH == 320) {
        
        if (returnContentStr.length > 32) {
            
            _raiseReturnLab.text = [[returnContentStr substringToIndex:25] stringByAppendingString:@"..."];
            
            _moreBtn.hidden = NO;
        }else{
            _raiseReturnLab.text = returnContentStr;
            _moreBtn.hidden = YES;
        }
    }else if (SCREEN_WIDTH == 375){
        if (returnContentStr.length > 45) {
            
            _raiseReturnLab.text = [[returnContentStr substringToIndex:35] stringByAppendingString:@"..."];
            
            _moreBtn.hidden = NO;
        }else{
            _raiseReturnLab.text = returnContentStr;
            _moreBtn.hidden = YES;
        }
    }else{
        _raiseReturnLab.text = returnContentStr;
        _moreBtn.hidden = YES;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end