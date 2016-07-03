//
//  FirendDetailCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "FirendDetailCell.h"
#import "ProjectCollectionViewCell.h"
#import "Project.h"
@interface FirendDetailCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *contantLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray *images;
@end
@implementation FirendDetailCell

- (void)awakeFromNib
{
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"ProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProjectCollectionViewCell"];
    _imageCollectionView.userInteractionEnabled = NO;
}

- (void)setProject:(Project *)project
{
    _project = project;
    _contantLabel.text = _project.profile;
    _bottomLeftLabel.text = [NSString stringWithFormat:@"已筹￥%@",_project.raisedAmount];
    _bottomRightLabel.text = [NSString stringWithFormat:@"%zd次支持  %@",_project.supportedCount,_project.showStatus];
    _images = _project.images;//   这里有问题
    _titleLabel.text = _project.name;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count > 4 ? 4 : _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCollectionViewCell" forIndexPath:indexPath];
    [cell setImageUrl:[_images objectAtIndex:indexPath.row]];
    return  cell;
}

@end