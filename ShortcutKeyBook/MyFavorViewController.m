//
//  MyFavorViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyFavorViewController.h"
#import "SoftwareManager.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"
#import "EmptyView.h"

@interface MyFavorViewController ()

@property (copy, nonatomic) NSArray *favorSoftwares;

@end

@implementation MyFavorViewController

+ (instancetype)myFavorViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我收藏的快捷键";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.favorSoftwares = [[SoftwareManager sharedInstance] loadMyFavorSoftwares];
    [self performSelector:@selector(showEmptyView) withObject:nil afterDelay:0];
}

- (void)showEmptyView
{
    if (self.favorSoftwares.count == 0) {
        [EmptyView showOnView:self.view withText:@"您还没有收藏快捷键哦~"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favorSoftwares.count;
}

//每个UICollectionView展示的内容.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SoftwareCell" forIndexPath:indexPath];
    
    SoftwareItem *item = self.favorSoftwares[indexPath.row];
    [cell fillWithName:item.softwareName iconImage:nil];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.favorSoftwares[indexPath.row];
    ShortcutKeyViewController *vc = [[ShortcutKeyViewController alloc] initWithSoftwareItem:item];
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
}


@end
