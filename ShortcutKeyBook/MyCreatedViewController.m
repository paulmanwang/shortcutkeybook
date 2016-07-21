//
//  MyCreatedViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyCreatedViewController.h"
#import "SoftwareCell.h"
#import "SoftwareItem.h"
#import "SoftwareManager.h"
#import "LoginManager.h"
#import "ShortcutKeyViewController.h"
#import "EmptyView.h"

@interface MyCreatedViewController ()

@property (strong, nonatomic) NSArray *softwares;

@end

@implementation MyCreatedViewController

+ (instancetype)myCreatedViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我创建的快捷键";
    
    NSString *account = [LoginManager sharedInstance].currentUserInfo.username;
    [[SoftwareManager sharedInstance] queryAllMyCreatedSoftwaresWithAccount:account completionHandler:^(NSError *error, NSArray *softwares) {
        if (softwares.count > 0) {
            self.softwares = softwares;
            [self.collectionView reloadData];
        } else {
            [EmptyView showOnView:self.view withText:@"您还没有创建过快捷键哦~"];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.softwares.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SoftwareCell" forIndexPath:indexPath];
    SoftwareItem *item = self.softwares[indexPath.row];
    [cell fillWithName:item.softwareName iconImage:nil];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.softwares[indexPath.row];
    ShortcutKeyViewController *vc = [[ShortcutKeyViewController alloc] initWithSoftwareItem:item];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
