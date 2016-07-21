//
//  RootViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SoftwareListViewController.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"
#import "SoftwareSearchViewController.h"
#import "SoftwareManager.h"
#import "SoftwareItem.h"

@interface SoftwareListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (copy, nonatomic) NSArray *softwares;
@property (assign, nonatomic) BOOL isLoadingData;

@end

@implementation SoftwareListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"快捷键";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configTitleView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SoftwareCell" bundle:nil] forCellWithReuseIdentifier:@"SoftwareCell"];
    
    [self querySoftwares];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}

#pragma mark - Private

- (void)configTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    titleLabel.text = @"快捷键大全";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.navigationItem.titleView = titleLabel;
}

- (void)querySoftwares
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    self.isLoadingData = YES;
    [[SoftwareManager sharedInstance] queryAllSoftwaresWithCompletionHandler:^(NSError *error, NSArray *softwares) {
        self.isLoadingData = NO;
        [self.view dismissLoadingView];
        if (!error) {
            self.softwares = softwares;
            [self.collectionView reloadData];
        }
    }];
}

- (void)timeout
{
    if (self.isLoadingData) {
        [self.view showLoadingView];
    }
}

- (void)refreshData
{
    if (self.isLoadingData) {
        return;
    }
    
    self.isLoadingData = YES;
    [[SoftwareManager sharedInstance] queryAllSoftwaresWithCompletionHandler:^(NSError *error, NSArray *softwares) {
        self.isLoadingData = NO;
        [self.view dismissLoadingView];
        if (!error) {
            self.softwares = softwares;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

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
    //选择事件全部用手势代替
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navibar_back_btn"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"navibar_back_btn"];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
    
    SoftwareItem *item = self.softwares[indexPath.row];
    ShortcutKeyViewController *vc = [[ShortcutKeyViewController alloc] initWithSoftwareItem:item];
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

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    SoftwareSearchViewController *searchViewController = [SoftwareSearchViewController softwareSearchViewController];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

@end
