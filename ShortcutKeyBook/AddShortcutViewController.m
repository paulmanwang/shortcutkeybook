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

#define kWordBoardHeight 44.0f

@interface AddShortcutViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *addTableViewCell;
@property (strong, nonatomic) UIBarButtonItem *saveButtonItem;
@property (strong, nonatomic) IBOutlet UITableViewCell *softwareNameTableViewCell;
@property (assign, nonatomic) NSUInteger dataCount;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *softwareNameLabel;

@property (strong, nonatomic) NSMutableArray *shortcutList;
@property (strong, nonatomic) IBOutlet UIView *wordHeaderView;

@property (strong, nonatomic) SoftwareItem *originSoftwareItem;
@property (copy, nonatomic) NSArray *originShortcutkeyList;

@end

@implementation AddShortcutViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shortcutList = [NSMutableArray new];
        self.dataCount = 3;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)setSoftwareItem:(SoftwareItem *)item shortcutkeyList:(NSArray *)shortcutkeyList
{
    self.originSoftwareItem = item;
    self.originShortcutkeyList = [shortcutkeyList copy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configTitleView];
    self.saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitBtnClicked)];
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddShortcutTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddShortcutTableViewCell"];
    
    if (self.originSoftwareItem) {
        self.softwareNameLabel.text = self.originSoftwareItem.softwareName;
        [self.shortcutList addObjectsFromArray:self.originShortcutkeyList];
    }
    else {
        [self initDataSource];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - notification

- (void)onKeyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    
    if (self.originSoftwareItem) {
        self.tableView.height = self.view.height - kWordBoardHeight - keyboardHeight;
    }
    else {
        self.tableView.height = self.view.height + kTabBarHeight - kWordBoardHeight - keyboardHeight;
    }
}

- (void)onKeyboardWillHideNotification:(NSNotification *)notification
{
    self.tableView.height = self.view.height - kWordBoardHeight;
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private 

- (void)configTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    titleLabel.text = @"创建新的快捷键";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.navigationItem.titleView = titleLabel;
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

- (void)postNotification
{
    if (self.originSoftwareItem) {
        NSString *softwareName = self.softwareNameLabel.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:kEditSoftwareSuccess object:self userInfo:@{@"softwareName":softwareName}];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSoftwareNumChanged object:self];
    }
}

- (NSArray *)addedShortcutkeys
{
    NSMutableArray *addedShortcuts = [NSMutableArray array];
    for (ShortcutkeyItem *item in self.shortcutList) {
        if (item.shortcutKeyName.length > 0) {
            NSMutableDictionary *info = [NSMutableDictionary new];
            info[@"name"] = [item.shortcutKeyName stringByEncodingURIComponent];
            info[@"detail"] = [item.shortcutKeyDetail stringByEncodingURIComponent];
            [addedShortcuts addObject:info];
        }
    }
    
    return addedShortcuts;
}

- (void)editSoftware
{
    NSString *softwareName = self.softwareNameLabel.text;
    NSArray *addedShortcuts = [self addedShortcutkeys];
    [[SoftwareManager sharedInstance] editSoftwareWithId:self.originSoftwareItem.softwareId softwareName:softwareName shortcutkeys:addedShortcuts completionHandler:^(NSError *error, BOOL success) {
        [self.view dismissLoadingView];
        if (success) {
            [self postNotification];
            [self dismiss];
            [self.view toastWithMessage:@"编辑成功"];
        }
        else {
            [self.view toastWithMessage:@"编辑失败"];
        }
    }];
}

- (void)submitShortcutKey
{
    NSString *softwareName = self.softwareNameLabel.text;
    NSArray *addedShortcuts = [self addedShortcutkeys];

    NSString *account = nil;
    if ([LoginManager sharedInstance].logged) {
        account = [LoginManager sharedInstance].currentUserInfo.username;
    } else {
        account = @"wlcunknownwlc";
    }
    softwareName = [softwareName stringByEncodingURIComponent];
    
    [[SoftwareManager sharedInstance] createSoftwareWithName:softwareName shortcutKeys:addedShortcuts account:account autoAdd:NO completionHandler:^(NSError *error, BOOL success) {
        [self.view dismissLoadingView];
        if (success) {
            NSLog(@"添加成功");
            [self postNotification];
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return 0.5;
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

- (IBAction)onWordButtonClicked:(id)sender
{
    NSString *text = ((UIButton *)sender).title;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:text, @"word", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordButtonClicked object:self userInfo:dict];
}

- (void)onSubmitBtnClicked
{
    NSLog(@"提交");
    NSString *softwareName = self.softwareNameLabel.text;
    if (softwareName.length == 0) {
        NSLog(@"请填写正确的软件名称");
        [self.view toastWithMessage:@"请填写正确的软件名称"];
        return;
    }
    
    if (softwareName.length > 20) {
        NSLog(@"软件名称不能超过20个字符");
        [self.view toastWithMessage:@"软件名称不能超过20个字符"];
        return;
    }
    
    // 软件名称合法性检查
    BOOL prefixIsNumber = [softwareName prefixIsNumber];
    if (prefixIsNumber) {
        NSLog(@"首字母不能为数字");
        [self.view toastWithMessage:@"首字母不能为数字，请输入正确的软件名称"];
        return;
    }
    
    BOOL isPuttyLetter = [softwareName isPureLetterAndNumber];
    if (!isPuttyLetter) {
        NSLog(@"请输入英文字符或数字");
        [self.view toastWithMessage:@"软件名称只能包含数字和字母"];
        return;
    }
    
    BOOL validate = [softwareName isLetterBeforeNumer];
    if (!validate) {
        NSLog(@"不合法的软件名称格式");
        [self.view toastWithMessage:@"请输入正确的软件名称"];
        return;
    }
    
    if (self.shortcutList.count == 0) {
        [self.view toastWithMessage:@"请填写正确的快捷键信息"];
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
    
    if (![LoginManager sharedInstance].logged) {
        [self showAlertView];
        return;
    }
    
    if (self.originSoftwareItem) {
        [self.view showLoadingViewWithText:@"正在提交信息..."];
        [self editSoftware];
    }
    else {
        [self.view showLoadingViewWithText:@"正在提交信息..."];
        [self submitShortcutKey];
    }
}

#pragma mark - AlertView

- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，登录之后发布快捷键，让更多人知道您的贡献！！！" delegate:self cancelButtonTitle:@"继续发布" otherButtonTitles:@"去登录", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self submitShortcutKey];
    }
    else {
        LoginViewController *loginViewController = [LoginViewController new];
        [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
    }
}

@end
