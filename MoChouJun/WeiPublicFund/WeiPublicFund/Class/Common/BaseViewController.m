//
//  BaseViewController.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "BaseViewController.h"
#import "PSBarButtonItem.h"
#import "MobClick.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hideNaviBar = NO;
    _hideBottomBar = NO;
    self.screenLayout = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
    _refershState = RefershStateUp;

}

#pragma mark - Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    // 启动 手势pop
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super  viewWillDisappear:animated];
     [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Public
- (UIBarButtonItem*)backBarItem
{
    PSBarButtonItem *backItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleBack target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    return backItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)setupBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [PSBarButtonItem itemWithTitle:title barStyle:PSNavItemStyleDone target:target action:action];
    if (isLeft)
    {
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = item;
    }
    return item;
}

- (UIBarButtonItem *)setupBarButtomItemWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImaegName target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [PSBarButtonItem itemWithImageName:normalImageName highLightImageName:highImageName selectedImageName:selectedImaegName target:target action:action];
    if (isLeft)
    {
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = item;
    }
    return item;
}

#pragma mark - Setter & Getter
- (void)setHideNaviBar:(BOOL)hideNaviBar
{
    _hideNaviBar = hideNaviBar;
    if (_hideNaviBar)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)setHideBottomBar:(BOOL)hideBottomBar
{
    _hideBottomBar = hideBottomBar;
    if (_hideBottomBar)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
}

- (void)setScreenLayout:(BOOL)screenLayout
{
    _screenLayout = screenLayout;
    
    if (_screenLayout)
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NetWorkingUtil *)httpUtil
{
    if (!_httpUtil) {
        _httpUtil = [NetWorkingUtil netWorkingUtil];
    }
    return _httpUtil;
}

- (void)setupHeaderRefresh:(UITableView *)tableView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshloadData)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"拉拉阿么就有啦\(^o^)/~" forState:MJRefreshStateIdle];
    [header setTitle:@"刷得好疼，快放开阿么 ::>_<:: " forState:MJRefreshStatePulling];
    [header setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
    tableView.mj_header = header;
}

- (void)setupFooterRefresh:(UITableView *)tableView
{
//    MJRefreshAutoNormalFooter
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshloadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    // 设置文字
    [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateIdle];
    [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStatePulling];
    [footer setTitle:@"阿么正在努力刷刷刷" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经没有更多啦" forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = footer;
}

- (void)setupRefreshWithTableView:(UITableView *)tableView
{
    [self setupHeaderRefresh:tableView];
    [self setupFooterRefresh:tableView];
}

- (void)headerRefreshloadData
{
    
}

- (void)footerRefreshloadData
{
    
}

- (void)setHideNoMsg:(BOOL)hideNoMsg
{
    _hideNoMsg = hideNoMsg;
    if (!self.noMsgView.superview)
    {
        [self.view addSubview:_noMsgView];
    }
    _noMsgView.hidden = _hideNoMsg;
}

- (NoMsgView *)noMsgView
{
    if (!_noMsgView)
    {
        _noMsgView =  [[[NSBundle mainBundle] loadNibNamed:@"NoMsgView" owner:self options:nil] firstObject];
        _noMsgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _noMsgView.centerX = self.view.center.x;
    }
    
    return _noMsgView;
}
@end