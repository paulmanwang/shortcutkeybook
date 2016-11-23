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
#import "MJRefresh/MJRefresh.h"

@interface SoftwareListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (copy, nonatomic) NSArray *softwares;
@property (assign, nonatomic) BOOL isLoadingData;
@property (strong, nonatomic) NSMutableDictionary *letterDic;
@property (strong, nonatomic) NSMutableArray *letterArray;

@end

@implementation SoftwareListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"快捷键";
        self.letterDic = [NSMutableDictionary new];
        self.letterArray = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSoftwareNumChanged:) name:kSoftwareNumChanged object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configTitleView];
    UIColor *blueColor = [UIColor colorWithRed:25/255.0 green:160/255.0 blue:220/255.0 alpha:1.0];
    self.searchBar.barTintColor = blueColor;
    
    // 去掉searchbar的一像素黑线
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = blueColor.CGColor;
    
    // 去掉navigationbar的一像素黑线
    UINavigationBar *bar = self.navigationController.navigationBar;
    for (UIView *subView in bar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            for (UIView *childView in subView.subviews) {
                if ([childView isKindOfClass:[UIImageView class]]) {
                    [childView removeFromSuperview];
                }
            }
        }
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kSoftwareCell"];
    [self addRefreshHeader];

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

#pragma mark - Notification

- (void)onSoftwareNumChanged:(NSNotification *)notification
{
    [self refreshData];
}

#pragma mark - Private

- (void)addRefreshHeader
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            [self.tableView.mj_header beginRefreshing];
            [self refreshData];
        }
    }];
}

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
            [self updateUI];
        }
    }];
}

- (void)updateUI
{
    // 分类算法
    [self.letterDic removeAllObjects];
    [self.letterArray removeAllObjects];
    
    for (SoftwareItem *item in self.softwares) {
        NSString *name = [item.softwareName transformToChinise];
        NSString *firstLetter = [name substringToIndex:1];
        if (self.letterDic[firstLetter] == nil) {
            self.letterDic[firstLetter] = [NSMutableArray new];
        }
        [self.letterDic[firstLetter] addObject:item];
    }
    
    [self.letterArray addObjectsFromArray:self.letterDic.allKeys];
    [self.letterArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *letter1 = (NSString *)obj1;
        NSString *letter2 = (NSString *)obj2;
        return [letter1 characterAtIndex:0] > [letter2 characterAtIndex:0];
    }];
    
    [self.tableView reloadData];
}

- (void)timeout
{
    if (self.isLoadingData) {
        [self.view showLoadingViewWithText:@"正在加载数据..."];
    }
}

- (void)refreshData
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    [[SoftwareManager sharedInstance] queryAllSoftwaresWithCompletionHandler:^(NSError *error, NSArray *softwares) {
        [self.tableView.mj_header endRefreshing];
        self.isLoadingData = NO;
        [self.view dismissLoadingView];
        if (!error) {
            self.softwares = softwares;
            [self updateUI];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.letterDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.letterArray[section];
    return ((NSArray *)self.letterDic[key]).count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.letterArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.letterArray[indexPath.section];
    NSArray *softwares = (NSArray *)self.letterDic[key];
    SoftwareItem *item = softwares[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSoftwareCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = kAppTextColor;
    cell.textLabel.text = item.softwareName;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letterArray;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.letterArray[section];
    label.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:label];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.letterArray[indexPath.section];
    NSArray *softwares = (NSArray *)self.letterDic[key];
    SoftwareItem *item = softwares[indexPath.row];
    ShortcutKeyViewController *vc = [[ShortcutKeyViewController alloc] initWithSoftwareItem:item shouldShowEditButton:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    SoftwareSearchViewController *searchViewController = [SoftwareSearchViewController softwareSearchViewController];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

@end
