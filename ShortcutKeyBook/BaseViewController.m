//
//  BaseViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "BaseViewController.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SoftwareCell" bundle:nil] forCellWithReuseIdentifier:@"SoftwareCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SoftwareCell" forIndexPath:indexPath];
    NSString *softwareName = nil;
    if (indexPath.row == 0) {
        softwareName = @"word";
    }
    else if (indexPath.row == 1) {
        softwareName = @"ppt";
    }
    else if (indexPath.row == 2) {
        softwareName = @"excel";
    }
    else if (indexPath.row == 3) {
        softwareName = @"chrome";
    }
    else if (indexPath.row == 4) {
        softwareName = @"MB Air";
    }
    else if (indexPath.row == 5) {
        softwareName = @"windows";
    }
    else if (indexPath.row == 6) {
        softwareName = @"vim";
    }
    else if (indexPath.row == 7) {
        softwareName = @"IE";
    }
    else if (indexPath.row == 8) {
        softwareName = @"xcode";
    }
    else if (indexPath.row == 9) {
        softwareName = @"eclipse";
    }
    else if (indexPath.row == 10) {
        softwareName = @"QQ";
    }
    else {
        softwareName = @"未命名";
    }
    
    [cell fillWithName:softwareName iconImage:nil];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //选择事件全部用手势代替
    //    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navibar_back_btn"];
    //    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"navibar_back_btn"];
    //
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backItem;
    
    ShortcutKeyViewController *vc = [ShortcutKeyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [SoftwareCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

//
////设置cell的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

//设置cell的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


@end
