//
//  CommentReturnedCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/10.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "CommentReturnedCell.h"
#import "CommentsObj.h"
#import "NetWorkingUtil.h"
#import "NSString+Adding.h"
#import "UIButton+WebCache.h"
@interface CommentReturnedCell()
@property (strong, nonatomic) CommentsObj*data;
@property (weak, nonatomic) IBOutlet UILabel *commentUserNameLab;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLab;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLab;
@property (weak, nonatomic) IBOutlet UIButton *replyCommentIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;
@end
@implementation CommentReturnedCell

- (void)awakeFromNib
{
    _replyCommentIconBtn.layer.cornerRadius = 17.5f;
    _replyCommentIconBtn.layer.masksToBounds = YES;
//    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setData:(CommentsObj *)data
{
    _data = data;
    _commentUserNameLab.text = _data.commentNickname;
    _commentTimeLab.text = _data.createDate;
    _commentContentLab.text = [NSString decodeString:_data.commentMsg];
    [_replyCommentIconBtn sd_setImageWithURL:[NSURL URLWithString:_data.commentAvatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_默认"]];
    
    NSString *headerStr = [NSString stringWithFormat:@"%@:",_data.replyNickname];//424242  AFAFAF
    NSMutableAttributedString *replyMeg = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",headerStr,[NSString decodeString:_data.replyMsg]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AFAFAF"]}];
    [replyMeg setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#424242"]} range:NSMakeRange(0, headerStr.length)];
    _replyTimeLabel.text = _data.modifyDate;
    _replyContentLab.attributedText =replyMeg;
}

- (IBAction)iconClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commentReturnedCellClikeIcon:comment:)])
    {
        [self.delegate commentReturnedCellClikeIcon:self comment:_data];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextFillRect(context, rect);
    
    //上分割线，
    
    //CGContextSetStrokeColorWithColor(context, COLORWHITE.CGColor);
    
    //CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithHexString:@"#EFEFF4"].CGColor);
    
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height, rect.size.width,1));
    
}

@end