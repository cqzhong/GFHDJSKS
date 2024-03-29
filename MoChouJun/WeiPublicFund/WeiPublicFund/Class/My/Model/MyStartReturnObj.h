//
//  MyStartReturnObj.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/11.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyStartReturnObj : NSObject

/// 项目Id
@property (nonatomic,assign)int crowdFundId;
@property (nonatomic,assign)int Id;

/// 众筹名称
@property (nonatomic,strong)NSString *name;

/// 项目内容
@property (nonatomic,strong)NSString *content;

/// 剩余时间
@property (nonatomic,strong)NSString *remainTime;

/// 已支持人数
@property (nonatomic,assign)int supportedCount;

/// 还能上传的图片数量
@property (nonatomic,assign)int imgCount;

/// 有效期
@property (nonatomic,assign)int dueDays;

/// 目标金额
@property (nonatomic,strong)NSString *targetAmount;

/// 已筹金额
@property (nonatomic,strong)NSString *raisedAmount;

/// 进度，0筹资中  1成功   2失败  3删除  // 筹资中  成功 失败 撤回
@property (nonatomic,assign)int statusId;

/// 创建日期
@property (nonatomic,strong)NSString *createDate;

/// 回报个数
@property (nonatomic,assign)NSUInteger repayWayCount;
@property (nonatomic,assign)NSUInteger repayCount;

@property (nonatomic,strong)NSString *showStatus;
@end
