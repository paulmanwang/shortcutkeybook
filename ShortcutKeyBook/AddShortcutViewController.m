//
//  AddShortcutViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AddShortcutViewController.h"
#import "AddShortcutTableViewCell.h"
#import "LoginViewController.h"
#import "SoftwareManager.h"
#import "LoginManager.h"
#import "ShortcutkeyItem.h"
#import "WLCToastView.h"

@interface AddShortcutViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *addTableViewCell;
@property (strong, nonatomic) UIBarButtonItem *saveButtonItem;
@property (strong, nonatomic) IBOutlet UITableViewCell *softwareNameTableViewCell;
@property (assign, nonatomic) NSUInteger dataCount;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *softwareNameLabel;

@property (strong, nonatomic) NSMutableArray *shortcutList;

@end

@implementation AddShortcutViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shortcutList = [NSMutableArray new];
        self.dataCount = 3;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configTitleView];
    self.saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitBtnClicked)];
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddShortcutTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddShortcutTableViewCell"];
    self.tableView.sectionHeaderHeight = 2;
    [self initDataSource];
}

- (void)initDataSource
{
    [self.shortcutList removeAllObjects];
    ShortcutkeyItem *item1 = [ShortcutkeyItem new];
    ShortcutkeyItem *item2 = [ShortcutkeyItem new];
    ShortcutkeyItem *item3 = [ShortcutkeyItem new];
    [self.shortcutList addObject:item1];
    [self.shortcutList addObject:item2];
    [self.shortcutList addObject:item3];
}

// 不能达到目的
//2016-07-10 21:21:16.758 ShortcutKeyBook[16035:333149] 请填写正确的内容
//2016-07-10 21:21:16.758 ShortcutKeyBook[16035:333149] 请填写正确的内容
//2016-07-10 21:21:16.758 ShortcutKeyBook[16035:333149] 请填写正确的内容
//2016-07-10 21:21:16.759 ShortcutKeyBook[16035:333149] 请填写正确的内容
- (void)traverseSubviews:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            NSLog(@"请填写正确的内容");
            return;
        }
        [self traverseSubviews:subView];
    }
}

- (void)onSubmitBtnClicked
{
    NSLog(@"提交");
    if (self.softwareNameLabel.text.length == 0) {
        NSLog(@"请填写正确的软件名称");
        [self.view toastWithMessage:@"请填写正确的软件名称"];
        return;
    }
    
    if (self.softwareNameLabel.text.length > 20) {
        NSLog(@"软件名称不能超过20个字符");
        [self.view toastWithMessage:@"软件名称不能超过20个字符"];
        return;
    }
    
    for (ShortcutkeyItem *item in self.shortcutList) {
        if ((item.shortcutKeyName.length == 0 && item.shortcutKeyDetail.length > 0)
            ||(item.shortcutKeyName.length > 0 && item.shortcutKeyDetail == 0)){
            NSLog(@"请填写正确的快捷键信息");
            [self.view toastWithMessage:@"请填写正确的快捷键信息"];
            return;
        }
    }
    
    NSMutableArray *addedShortcuts = [NSMutableArray array];
    for (ShortcutkeyItem *item in self.shortcutList) {
        if (item.shortcutKeyName.length > 0) {
            NSMutableDictionary *info = [NSMutableDictionary new];
            info[@"name"] = [item.shortcutKeyName stringByEncodingURIComponent];
            info[@"detail"] = [item.shortcutKeyDetail stringByEncodingURIComponent];
            [addedShortcuts addObject:info];
        }
    }
    
    NSString *account = nil;
    if ([LoginManager sharedInstance].logged) {
        account = [LoginManager sharedInstance].currentUserInfo.username;
    } else {
        account = @"wlcunknownwlc";
    }
    NSString *softwareName = [self.softwareNameLabel.text stringByEncodingURIComponent];
    [[SoftwareManager sharedInstance] createSoftwareWithName:softwareName shortcutKeys:addedShortcuts account:account completionHandler:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"添加成功");
            [self.view toastWithMessage:@"发布成功"];
            self.softwareNameLabel.text = @"";
            [self initDataSource];
            [self.tableView reloadData];
        } else {
            NSLog(@"添加失败");
            [self.view toastWithMessage:@"发布失败"];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([LoginManager sharedInstance].logged) {
        self.tableView.tableHeaderView = nil;
    } else {
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    titleLabel.text = @"创建新的快捷键";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return self.shortcutList.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.softwareNameTableViewCell;
    }
    else if (indexPath.section == 2) {
        return self.addTableViewCell;
    }
    else {
        AddShortcutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddShortcutTableViewCell"];
        ShortcutkeyItem *item = self.shortcutList[indexPath.row];
        [cell fillData:item];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 44;
    } else {
        return [AddShortcutTableViewCell cellHeight];
    }
}

- (IBAction)onAddButtonClicked:(id)sender
{
    [self.tableView beginUpdates];
    NSInteger count = self.shortcutList.count;
    [self.shortcutList addObject:[ShortcutkeyItem new]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (IBAction)onGotoLoginBtnClicked:(id)sender
{
    LoginViewController *loginViewController = [LoginViewController new];
    [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
}

@end
