//
//  SupportReturn.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/15.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportReturn : NSObject
//项目ID
@property (assign, nonatomic) NSInteger crowdFundId;

//回报ID 统一后使用的是 Id
@property (assign, nonatomic) NSInteger Id;
@property (assign, nonatomic) NSInteger repayId;

// 回报的状态
@property (assign, nonatomic) NSInteger StatusId;
@property (copy, nonatomic) NSString *showStatus;

//回报介绍
@property (copy, nonatomic) NSString *Description;//Description //Description
//Description  文字的高度
@property (assign, nonatomic) CGFloat textHeight;

//回报金额
@property (assign, nonatomic) double supportAmount;

//图片数据 直接使用 imageArr（已处理）
@property (copy, nonatomic) NSString *images;
@property (strong, nonatomic) NSArray *imageArr;

//该回报方式最大支持人数 若为0则无限制
@property (assign, nonatomic) NSInteger maxNumber;
//该回报方式已支持人数
@property (assign, nonatomic) NSInteger supportCount;

//  是否有地址
@property (nonatomic,assign) NSInteger switchNum;
@property (nonatomic,assign) NSInteger isExpressed;

@property (nonatomic,strong)NSString *createDate;

@property (nonatomic,assign) NSInteger pieceCount;

//当前用户账户余额 (用户下一步支付)
@property (assign, nonatomic) double balance;

//回报期限
@property (assign, nonatomic) NSInteger repayDays;

@property (assign, nonatomic) BOOL supportAble;

@property (strong, nonatomic) NSArray *list;// 支持的人的列表

// ===========扩展=============
//支持项目时的contentHeight
@property (assign, nonatomic) CGFloat contentHeight;

//回报详情页面的 contentHeight
@property (assign, nonatomic) BOOL openState;

// 回报页面内容高度
@property (assign, nonatomic) CGFloat returnContentHeight;
@end