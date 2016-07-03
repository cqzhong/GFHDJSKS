//
//  SupportProjectTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportProjectTableViewCell.h"
#import "SupportProjectCollectionViewCell.h"
#import "BaseNavigationController.h"
#import <MWPhotoBrowser.h>
#import "SupportReturn.h"
#import "User.h"

@interface SupportProjectTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *supportAmountLab;


@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLab;


@property (weak, nonatomic) IBOutlet UILabel *suportCommitLabel;
@end
static CGFloat const kContentMargin = 12.0;
@implementation SupportProjectTableViewCell

- (void)awakeFromNib
{
//    _supportCollectionView.delegate = self;
//    _supportCollectionView.dataSource = self;
//    [_supportCollectionView registerNib:[UINib nibWithNibName:@"SupportProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SupportProjectCollectionViewCell"];
}

- (void)setProjectUerId:(NSInteger)projectUerId
{
    _projectUerId = projectUerId;
    if (_projectUerId == [[User shareUser].Id integerValue]){
        _supportBtn.hidden = YES;
        _supportLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - _supportLabel.size.width, _supportLabel.origin.y, _supportLabel.size.width, _supportLabel.size.height);
    }else{
        _supportBtn.hidden = NO;
        _supportLabel.frame = CGRectMake(SCREEN_WIDTH - 235, _supportLabel.origin.y, _supportLabel.size.width, _supportLabel.size.height);
    }
}

- (void)setProjectStates:(NSInteger)projectStates
{
    _projectStates = projectStates;
    
    if (_cellStyle == SupportProjectCellStyleDetail)
    {
        if (_projectStates != 0)
        {
            _supportBtn.enabled = NO;
        }
        else
        {
            _supportBtn.enabled = YES;
        }
    }
}

- (void)setSupport:(SupportReturn *)support
{
    _support = support;// 17 11
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",_support.supportAmount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _supportAmountLab.attributedText = atriText;
    
    NSString *supportedText = [NSString stringWithFormat:@"已获%zd次支持",_support.supportCount];
    _supportLabel.text = supportedText;
    if (_support.maxNumber == 0)
    {
        _numberLab.text = @"数量不限";
        _numberLab.textColor = [UIColor colorWithHexString:@"#7F7F7F"];
    }
    else
    {
        NSString *numberTextStr;
        if (_support.maxNumber - _support.supportCount >= 100) {
            numberTextStr = [NSString stringWithFormat:@"剩余%ld份",_support.maxNumber - _support.supportCount];
        }else{
            numberTextStr = [NSString stringWithFormat:@"仅剩%ld份",_support.maxNumber - _support.supportCount];
        }
        
        NSMutableAttributedString * supportTotalText = [[NSMutableAttributedString alloc] initWithString:numberTextStr];
        [supportTotalText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF0000"] range:NSMakeRange(2, supportTotalText.length - 3)];
        _numberLab.attributedText = supportTotalText;
    }
    
    
//    _descLabel.attributedText = descText;
    
    [self setLabStyle:_support.Description];
    
    
    if (_cellStyle == SupportProjectCellStyleReturn)
    {
        BOOL canSupport = _support.StatusId == 1;
        _supportBtn.userInteractionEnabled = canSupport;
        //回报方式状态  0删除 1等待回报  2回报中 3 回报结束
        if (canSupport)
        {
            [_supportBtn setTitle:@"立即支持" forState:UIControlStateNormal];
        }
        else
        {
            _supportBtn.enabled = NO;
            [_supportBtn setTitle:_support.showStatus forState:UIControlStateNormal];
        }
    }
    
    if (_support.imageArr.count)
    {
//        [_supportCollectionView reloadData];
        id image = _support.imageArr[0];
        _supportImageView.contentMode = UIViewContentModeScaleAspectFill;
        _supportImageView.clipsToBounds = YES;
        if ([image isKindOfClass:[NSString class]])
        {
            [NetWorkingUtil setImage:_supportImageView url:image defaultIconName:@"returnDetailsImage"];
        }
        else if ([image isKindOfClass:[UIImage class]])
        {
            _supportImageView.image = image;
        }
    }else{
        _supportImageView.image = [UIImage imageNamed:@"returnDetailsImage"];
    }
    
    if(_support.repayDays != 0)
    {
        NSString *commintText = @"众筹承诺：众筹成功内发货";
        NSMutableAttributedString *commintTotalText = [[NSMutableAttributedString alloc] initWithString:commintText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#7F7F7F"]}];
        NSAttributedString *repayDaysText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd天",_support.repayDays] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
        [commintTotalText insertAttributedString:repayDaysText atIndex:commintText.length - 3];
        _suportCommitLabel.attributedText = commintTotalText;
        _suportCommitLabel.hidden = NO;
    }
    else
    {
        _suportCommitLabel.hidden = YES;
    }

    [self updateViewFrame];
}

- (void)setLabStyle:(NSString *)returnContentStr
{
    if (SCREEN_WIDTH == 320) {
        
        if (returnContentStr.length > 32) {
            
            NSMutableAttributedString *descText = [[NSMutableAttributedString alloc] initWithString:[[returnContentStr substringToIndex:25] stringByAppendingString:@"..."] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#3E3E3E"],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            [descText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#7F7F7F"] range:NSMakeRange(0, 5)];
            
            _descLabel.attributedText = descText;
            
            _moreBtn.hidden = NO;
        }else{
            _descLabel.text = returnContentStr;
            _moreBtn.hidden = YES;
        }
    }else if (SCREEN_WIDTH == 375){
        if (returnContentStr.length > 45) {
            
            NSMutableAttributedString *descText = [[NSMutableAttributedString alloc] initWithString:[[returnContentStr substringToIndex:35] stringByAppendingString:@"..."] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#3E3E3E"],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            [descText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#7F7F7F"] range:NSMakeRange(0, 5)];
            
            _descLabel.attributedText = descText;
            
            _moreBtn.hidden = NO;
        }else{
            _descLabel.text = returnContentStr;
            _moreBtn.hidden = YES;
        }
    }else{
        _descLabel.text = returnContentStr;
        _moreBtn.hidden = YES;
    }
    
}

- (void)updateViewFrame
{
//    CGFloat height = 40.0;
    _descLabel.height = [_support textHeight];
//    height += _support.textHeight;
    
//    if (_cellStyle == SupportProjectCellStylePay)
//    {
//        _supportBtn.hidden = YES;
//        _supportLabel.frame = CGRectOffset(_supportLabel.frame, _supportBtn.width, 0);
//    }
    
//    if (_support.imageArr.count)
//    {
//        height += 22.0;// 空隙
//        _supportCollectionView.top = height;
//        _supportCollectionView.hidden = NO;
//        height += 65;
//    }
//    else
//    {
//        _supportCollectionView.hidden = YES;
//    }
//    
//    if(_support.repayDays != 0)
//    {
//        height += kContentMargin;// 空隙
//        _suportCommitLabel.top = height;
//        height += 11;
//    }
//    
//    height += kContentMargin;
}

#pragma mark - Action

- (IBAction)supportAction {
    if (_cellStyle != SupportProjectCellStyleReturn)
    {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(supportProjectCellReturnPeople:)])
    {
        [self.delegate supportProjectCellReturnPeople:self];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSUInteger)numberRowCount
{
    NSUInteger count = (NSUInteger)(SCREEN_WIDTH - kContentMargin * 2 + kContentMargin)/(65 + kContentMargin);
    if (_support.imageArr.count <= count)
    {
        return _support.imageArr.count;
    }
    else
    {
        return  count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberRowCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SupportProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupportProjectCollectionViewCell" forIndexPath:indexPath];
    id image = _support.imageArr[indexPath.row];
    
    if ([image isKindOfClass:[NSString class]])
    {
        [NetWorkingUtil setImage:cell.supportProjectImageView url:image defaultIconName:@"comment_默认"];
    }
    else if ([image isKindOfClass:[UIImage class]])
    {
        cell.supportProjectImageView.image = image;
    }
    
    if (_support.imageArr.count > 3) {
        if (indexPath.row == 3) {
            cell.moreImageBtn.hidden = NO;
            [cell.moreImageBtn setTitle:[NSString stringWithFormat:@" %lu",(unsigned long)_support.imageArr.count] forState:UIControlStateNormal];
        }else{
            cell.moreImageBtn.hidden = YES;
        }
    }
    else
    {
        cell.moreImageBtn.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 查看图片 //删除功能
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController *vc =  (UIViewController *)self.delegate;
    [vc presentViewController:nc animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _support.imageArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    id image = _support.imageArr[index];
    if ([image isKindOfClass:[NSString class]])
    {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:image]];
        return photo;
        
    }else if ([image isKindOfClass:[UIImage class]])
    {
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    id image = _support.imageArr[index];
    if ([image isKindOfClass:[NSString class]])
    {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:image]];
        return photo;
        
    }else if ([image isKindOfClass:[UIImage class]])
    {
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        return photo;
    }
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}
@end