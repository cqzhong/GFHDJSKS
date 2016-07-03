//
//  AddProjectReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "AddProjectReturnViewController.h"
#import "StartImageEditCollectionViewCell.h"
#import "PSActionSheet.h"
#import "UIImage-Extensions.h"
#import "ELCImagePickerHeader.h"
#import <MWPhotoBrowser.h>
#import "BaseNavigationController.h"
#import "AXPopoverView.h"
#import "ProjectReturnViewController.h"
#import "ZHBPickerView.h"
#import "UpYun.h"
#import "SeeAllReturnViewController.h"
#import "NSDate+Helper.h"
#import "SuccessProjectViewController.h"

@interface UIImage (Seleced)
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,copy)  NSString *assetUrl;
@end

@implementation UIImage (Seleced)

- (void)setIsSelected:(BOOL)isSelected
{
    NSNumber *boolNumber = [NSNumber numberWithBool:isSelected];
    objc_setAssociatedObject(self, @selector(isSelected), boolNumber, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isSelected
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return [number boolValue];
}

- (void)setAssetUrl:(NSString *)assetUrl
{
    objc_setAssociatedObject(self, @selector(assetUrl), assetUrl, OBJC_ASSOCIATION_COPY);
}

- (NSString *)assetUrl
{
    return objc_getAssociatedObject(self, _cmd);
}
@end

@interface AddProjectReturnViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,MWPhotoBrowserDelegate,UITextFieldDelegate,ZHBPickerViewDelegate,ZHBPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *returnContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *returnPlaceHolderLab;
@property (weak, nonatomic) IBOutlet UICollectionView *returnContentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *returnContentLayout;
@property (weak, nonatomic) IBOutlet UITextField *returnAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *limitPeopleTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeAllReturnBtn;

@property (nonatomic , strong) UIImagePickerController *imagePicerController;

@property (nonatomic , strong) NSMutableArray *unSelectedImages;
@property (nonatomic , assign) BOOL isOptionAllImage;
@property (nonatomic , strong) UIImage *deleteImage;

@property (nonatomic , strong) NSMutableArray *haveImages;

@property (nonatomic,strong)ZHBPickerView *zhBPickerView;
@property (nonatomic,strong)NSMutableArray *dateArr;
@property (nonatomic,strong)NSMutableArray *dateNumArr;
@property (nonatomic,assign)BOOL zhBPickBool;
@property (nonatomic,strong)UIWindow *window;

@property (nonatomic,assign)NSInteger switchInteger;

@property (nonatomic,strong)NSString *imageUrl;
@end

@implementation AddProjectReturnViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (_editReturnDic) {
        self.title = @"编辑回报";
    }else{
        self.title = @"添加回报";
    }
    
    _isOptionAllImage = NO;
    _zhBPickBool = NO;
    _switchInteger = 0;
    _window = [[[UIApplication sharedApplication] windows] lastObject];
    [self setInfo];
    [self getDateInfo];
    
    [_returnAmountTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_limitPeopleTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    if ([_addType isEqual:@"AddReturn"]){
        _seeAllReturnBtn.hidden = NO;
    }
}

- (void)textDidChange:(UITextField *)textField
{
    if (textField == _returnAmountTextField)
    {
        if ([_returnAmountTextField.text intValue] > 100000) {
            _returnAmountTextField.text = @"100000";
            [MBProgressHUD showMessag:@"支持金额不要大于100000元" toView:self.view];
        }
        else if ([_returnAmountTextField.text integerValue] <= 0)
        {
            _returnAmountTextField.text = @"";
        }
        return;
    }
    if (textField == _limitPeopleTextField) {
        if ([_limitPeopleTextField.text intValue] >= 10000) {
            _limitPeopleTextField.text = @"9999";
        }
        return;
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray *)haveImages
{
    if (!_haveImages)
    {
        _haveImages = [NSMutableArray arrayWithCapacity:7];
        [_haveImages addObject:self.deleteImage];
        
    }
    return _haveImages;
}

- (NSMutableArray *)unSelectedImages
{
    if (!_unSelectedImages)
    {
        _unSelectedImages = [NSMutableArray arrayWithCapacity:7];
    }
    return _unSelectedImages;
}

- (NSMutableArray *)dateArr
{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

- (NSMutableArray *)dateNumArr
{
    if (!_dateNumArr) {
        _dateNumArr = [NSMutableArray array];
    }
    return _dateNumArr;
}

- (UIImage *)deleteImage
{
    if (!_deleteImage)
    {
        _deleteImage  = [UIImage imageNamed:@"uploadImageOne"];
    }
    return _deleteImage;
}

- (void)setEditReturnDic:(NSDictionary *)editReturnDic
{
    _editReturnDic = editReturnDic;
}

- (void)setInfo
{
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(saveBtnClick) leftOrRight:NO];
    [self setupBarButtomItemWithTitle:@" 取消" target:self action:@selector(backBtnClick) leftOrRight:YES];

    
    [_returnAmountTextField setValue:[UIColor colorWithHexString:@"#DEDFE0"] forKeyPath:@"_placeholderLabel.textColor"];
    [_limitPeopleTextField setValue:[UIColor colorWithHexString:@"#DEDFE0"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_returnContentCollectionView registerNib:[UINib nibWithNibName:@"StartImageEditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StartImageEditCollectionViewCell"];

    if (SCREEN_WIDTH == 375) {
        _returnContentLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30 - 10 * 2) / 3, 80);
    }else if (SCREEN_WIDTH == 414){
        _returnContentLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30 - 10 * 2) / 3, 90);
    }else{
        _returnContentLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30 - 10 * 2) / 3, 100);
    }
    
    _returnContentCollectionView.delegate = self;
    _returnContentCollectionView.dataSource = self;
    
    if (_editReturnDic)
    {
        _returnAmountTextField.text = [_editReturnDic objectForKey:@"SupportAmount"];
        _dateLab.text = [_editReturnDic objectForKey:@"Days"];
        if ([[_editReturnDic objectForKey:@"maxNumber"] integerValue] == 0) {
            _limitPeopleTextField.text = @"";
        }else{
            _limitPeopleTextField.text = [NSString stringWithFormat:@"%@",[_editReturnDic objectForKey:@"maxNumber"]];
        }
        if ([[_editReturnDic objectForKey:@"IsExpressed"] integerValue] == 1) {
            _switchBtn.on = YES;
        }
        _returnContentTextView.text = [_editReturnDic objectForKey:@"Description"];
        _returnPlaceHolderLab.hidden = YES;
        [self.haveImages removeAllObjects];
        NSArray *arr = [_editReturnDic objectForKey:@"ImgList"];
        [self.haveImages addObjectsFromArray:arr];
    
        if (self.haveImages.count == 0)
        {
            _returnContentCollectionView.hidden = YES;
            [self.haveImages addObject:self.deleteImage];
        }
        else
        {
            _returnContentCollectionView.hidden = NO;
            if (_haveImages.count < 6)
            {
                [self.haveImages addObject:self.deleteImage];
            }
            [_returnContentCollectionView reloadData];
        }
    }
}

- (void)backBtnClick
{
    [_zhBPickerView removeFromSuperview];
    if (!IsStrEmpty(_returnAmountTextField.text) || ![_dateLab.text isEqual:@"请选择"] || !IsStrEmpty(_limitPeopleTextField.text) || _switchInteger == 1 || !IsStrEmpty(_returnContentTextView.text) || _haveImages.count > 1) {
        if (_editReturnDic) {
            if (![_returnAmountTextField.text isEqual:[_editReturnDic objectForKey:@"SupportAmount"]] || ![_dateLab.text isEqual:[_editReturnDic objectForKey:@"Days"]] || [_limitPeopleTextField.text integerValue] != [[_editReturnDic objectForKey:@"maxNumber"] integerValue] || _switchInteger != [[_editReturnDic objectForKey:@"IsExpressed"] integerValue]  || ![_returnContentTextView.text isEqual:[_editReturnDic objectForKey:@"Description"]]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else{
        if (_editReturnDic){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([_type isEqual:@"Add"] || [_addType isEqual:@"AddReturn"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
        }
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (_editReturnDic)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if ([_addType isEqual:@"AddReturn"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSArray *childViewController = self.navigationController.childViewControllers;
                ProjectReturnViewController *vc =  childViewController[childViewController.count - 2];
                if (vc.detailArr.count)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                }
            }
        }
    }
}

- (void)saveBtnClick
{
    if ([_returnAmountTextField.text intValue] <= 0) {
        [MBProgressHUD showMessag:@"陛下,请您设定一个金额" toView:self.view];
        return;
    }
    
    if ([_dateLab.text isEqual:@"请选择"]) {
        [MBProgressHUD showMessag:@"陛下,请您设定截止日期" toView:self.view];
        return;
    }
    
    if (IsStrEmpty(_returnContentTextView.text)) {
        [MBProgressHUD showMessag:@"陛下,您想给什么回报,要写清楚哦" toView:self.view];
        return;
    }
    
    if (_haveImages.count == 1) {
        [MBProgressHUD showMessag:@"陛下,您还没有添加回报图片哦" toView:self.view];
        return;
    }
    
    [_haveImages removeLastObject];
    
    //   字符串截取
    NSString *dateStr = [_dateLab.text substringFromIndex:4];
    dateStr = [dateStr substringToIndex:dateStr.length - 2];

    NSDictionary *saveDic;
    
    NSInteger limitPeople = 0;
    if (IsStrEmpty(_limitPeopleTextField.text)) {
        limitPeople = 0;
    }else{
        limitPeople = [_limitPeopleTextField.text integerValue];
    }
    
    if (_haveImages.count)
    {
        saveDic = @{@"SupportAmount":_returnAmountTextField.text,
                    @"repayDays":dateStr,
                    @"Days":_dateLab.text,
                    @"maxNumber":@(limitPeople),
                    @"Description":_returnContentTextView.text,
                    @"IsExpressed":@(_switchInteger),
                    @"ImgList":_haveImages};
        
    }else
    {
        saveDic = @{@"SupportAmount":_returnAmountTextField.text,
                    @"repayDays":dateStr,
                    @"Days":_dateLab.text,
                    @"maxNumber":@(limitPeople),
                    @"Description":_returnContentTextView.text,
                    @"IsExpressed":@(_switchInteger),
                    @"ImgList":_haveImages};
    }
    
    if ([_addType isEqual:@"AddReturn"]) {
        [MBProgressHUD showStatus:nil toView:self.view];
        [self uploadPhoto];
    }else{
        if ([self.delegate respondsToSelector:@selector(addReturnSavedReturnUserInfo:isEdit:)]) {
            [self.delegate addReturnSavedReturnUserInfo:saveDic isEdit:_editReturnDic];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)saveReturnClick
{
    //   字符串截取
    NSString *dateStr = [_dateLab.text substringFromIndex:4];
    dateStr = [dateStr substringToIndex:dateStr.length - 2];
    
    NSInteger limitPeople = 0;
    if (IsStrEmpty(_limitPeopleTextField.text)) {
        limitPeople = 0;
    }else{
        limitPeople = [_limitPeopleTextField.text integerValue];
    }
    
    [self.httpUtil requestDic4MethodName:@"Repay/Add" parameters:@{@"CrowdFundId":@(_crowdFundId),@"SupportAmount":_returnAmountTextField.text,@"RepayDays":dateStr,@"MaxNumber":@(limitPeople),@"IsExpressed":@(_switchInteger),@"Description":_returnContentTextView.text,@"Images":_imageUrl} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
            SuccessProjectViewController *successProjectVC = [SuccessProjectViewController new];
            successProjectVC.type = @"start";
            successProjectVC.showStr = @"您已成功添加回报,快去分享给小伙伴们吧";
            successProjectVC.myTitle = @"成功添加回报";
            successProjectVC.projectId = _crowdFundId;
            successProjectVC.projectStr = _titleStr;
            successProjectVC.projectArr = _projectImageArr;
            successProjectVC.editType = _editType;
            [self.navigationController pushViewController:successProjectVC animated:YES];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}
//  开关变化
- (IBAction)switchChanged:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.isOn) {
        _switchInteger = 1;
    }else{
        _switchInteger = 0;
    }
}
//   选择截止日期
- (IBAction)selectDataClick:(id)sender {
    
    [_returnAmountTextField resignFirstResponder];
    [_limitPeopleTextField resignFirstResponder];
    
    if (_zhBPickBool == NO) {
        _zhBPickBool = YES;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        [_window addSubview:_zhBPickerView];
    }else{
        _zhBPickBool = NO;
        [_zhBPickerView removeFromSuperview];
    }
}

//  选择图片
- (IBAction)selectImageClick:(id)sender {
    
    if (_haveImages.count == 7) {
        [MBProgressHUD showMessag:@"现在最多只能发6张图片哦,阿么的空间耗不起呢" toView:self.view];
    }else{
        PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择",nil];
        [actionSheet showInView:self.view];
    }
}
//  限制人数
- (IBAction)limitPeopleClick:(id)sender {
    [AXPopoverView showLabelFromView:sender animated:YES duration:2.5 title:nil detail:@"每项回报可以设置限制人数上限,若不填写,则默认为不限制投资名额。" configuration:^(AXPopoverView *popoverView) {
        popoverView.preferredWidth = 130;
        popoverView.showsOnPopoverWindow = NO;
//        [popoverView registerScrollView:(UIScrollView *)self.view];
        popoverView.hideOnTouch = NO;
        popoverView.preferredArrowDirection = AXPopoverArrowDirectionTop;
        popoverView.translucentStyle = AXPopoverTranslucentLight;
        popoverView.contentView.backgroundColor = [UIColor whiteColor];
        popoverView.detailTextColor = [UIColor colorWithHexString:@"#2B2B2B"];
        popoverView.detailFont = [UIFont systemFontOfSize:14.0f];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (IsStrEmpty(textView.text)) {
        _returnPlaceHolderLab.hidden = NO;
    }else{
        _returnPlaceHolderLab.hidden = YES;
    }
    
    if (textView.text.length > 100)
    {
        textView.text = [textView.text substringToIndex:101];
        [MBProgressHUD showMessag:@"陛下,说明白就好,不用太罗嗦啦" toView:self.view];
    }
}

- (UIImagePickerController *)imagePicerController
{
    if (!_imagePicerController)
    {
        _imagePicerController = [[UIImagePickerController alloc]init];
        _imagePicerController.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
        _imagePicerController.navigationBar.barTintColor = NaviColor;
        [_imagePicerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
        _imagePicerController.delegate = self;
        _imagePicerController.allowsEditing = YES;
    }
    return _imagePicerController;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        // 判断是否能拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicerController.showsCameraControls = YES;//takePicture
            [self presentViewController:self.imagePicerController animated:YES completion:nil];
        }
        else
        {
            ULog(@"设备不支持");
        }
    }
    else if (buttonIndex == 1)
    {
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        //            elcPicker.navigationBar.titleTextAttributes
        elcPicker.navigationBar.tintColor = [UIColor whiteColor];
        elcPicker.navigationBar.barTintColor = NaviColor;
        elcPicker.maximumImagesCount = 1 - (_haveImages.count - 1); //Set the maximum number of images to select to 100
        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
        
        elcPicker.imagePickerDelegate = self;
        
        [self presentViewController:elcPicker animated:YES completion:nil];
    }
    
}

#pragma mark - ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    _returnContentCollectionView.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            UIImage *originalImage = [dict objectForKey:UIImagePickerControllerOriginalImage];
            if (originalImage)
            {
                UIImage* image= [UIImage fixOrientation:originalImage];
                NSURL *imageUrl = [dict objectForKey:UIImagePickerControllerReferenceURL];
                image.assetUrl = imageUrl.absoluteString;
                if (![self isAddedImage:image])
                {
                    [self.haveImages insertObject:image atIndex:0];
                }
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    [_returnContentCollectionView reloadData];
}

- (BOOL)isAddedImage:(UIImage *)image
{
    NSString *newAssetUrl = image.assetUrl;
    if (newAssetUrl.length <= 0) return NO;
    for (UIImage *addedImage in self.haveImages)
    {
        NSString *oldAssetUrl = addedImage.assetUrl;
        if (oldAssetUrl.length > 0)
        {
            if ([oldAssetUrl isEqualToString:newAssetUrl])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate & UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _returnContentCollectionView.hidden = NO;
    
    UIImage *optionImage = [UIImage fixOrientation:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    optionImage.isSelected = YES;
    if (_haveImages.count == 7)
    {
//        [_haveImages removeLastObject];
        [_haveImages insertObject:optionImage atIndex:0];
        _isOptionAllImage = YES;
    }
    else
    {
        [_haveImages insertObject:optionImage atIndex:0];
        _isOptionAllImage = NO;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    [_returnContentCollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.haveImages.count == 2) {
        return self.haveImages.count - 1;
    }
    return self.haveImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StartImageEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StartImageEditCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _haveImages.count-1 && !_isOptionAllImage)
    {
        cell.imageEditImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.deleteBtn.hidden = YES;
    }
    else
    {
        cell.imageEditImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.imageEditImageView.image = _haveImages[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isOptionAllImage && indexPath.row == _haveImages.count-1)
    {
        PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"选择照片",nil];
        [actionSheet showInView:self.view];
    }else{
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
        
        // Manipulate
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        // Present
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

//  删除选中图片
- (void)deleteBtnClick:(UIButton *)sender
{
    [_haveImages removeObjectAtIndex:sender.tag];

    [_returnContentCollectionView reloadData];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.haveImages.count-1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithImage:_haveImages[index]];
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    UIImage *image = _haveImages[index];
    image.isSelected = YES;
    MWPhoto *photo = [MWPhoto photoWithImage:_haveImages[index]];
    return photo;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

//  键盘return键
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int textValue = [textField.text intValue];
    if (textValue == 0)
    {
        textField.text = @"";
    }
    else
    {
        textField.text = [NSString stringWithFormat:@"%zd",textValue];
    }
}

- (void)getDateInfo
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        for (NSInteger i = 1; i <= 60; i ++) {
            NSString *str = [NSString stringWithFormat:@"众筹成功%ld天内",(long)i];
            NSString *strNum = [NSString stringWithFormat:@"%ld",(long)i];
            [self.dateArr addObject:str];
            [self.dateNumArr addObject:strNum];
        }
    });
}

//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (component == 0) {
        return _dateArr;
    }
    return nil;
}

- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    _zhBPickBool = NO;
    [_dateLab setTextColor:[UIColor colorWithHexString:@"#2B2B2B"]];
    _dateLab.text = content;
    if ([content isEqual:@""]) {
        _dateLab.text = _dateArr[6];
    }
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    _zhBPickBool = NO;
    [_zhBPickerView removeFromSuperview];
}

- (void)uploadPhoto{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"ndzphoto";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"T+uMJhbKzocOvPRzLWs2DlqNJOI=";
    __block UpYun *uy = [[UpYun alloc] init];
    
    dispatch_queue_t urls_queue = dispatch_queue_create("app.mochoujun.com", NULL);
    dispatch_async(urls_queue, ^{
        uy.successBlocker = ^(NSURLResponse *response, id responseData) {
            NSDictionary *dic = (NSDictionary *)responseData;
            
            _imageUrl = [NSString stringWithFormat:@"%@%@", @"http://img.niuduz.com/", dic[@"url"]];
            [self saveReturnClick];
        };
        uy.failBlocker = ^(NSError * error) {
            NSString *message = [error.userInfo objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            NSLog(@"error %@", message);
        };
        uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        };
        NSString *keyStr = [NSString stringWithFormat:@"%@/addReturnImage.jpg",[NSDate getNowDateString]];
        [uy uploadImage:_haveImages[0] savekey:keyStr];
    });
}
//   查看全部回报
- (IBAction)seeAllReturnBtnClick:(id)sender {
    SeeAllReturnViewController *seeAllReturnVC = [SeeAllReturnViewController new];
    seeAllReturnVC.crowdFundId = _crowdFundId;
    [self.navigationController pushViewController:seeAllReturnVC animated:YES];
}

@end