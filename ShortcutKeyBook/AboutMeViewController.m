//
//  AboutMeViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AddShortcutViewController.h"
#import "LoginViewController.h"
#import "MyFavorViewController.h"
#import "MyCreatedViewController.h"
#import "LoginManager.h"
#import "UMengFeedback/UMFeedback.h"
#import "SoftwareInfoViewController.h"
#import "UMSocial.h"

typedef NS_ENUM(NSUInteger, AMCellType){
    AMCellTypeMyCreatedShortcuts = 0,
    AMCellTypeFavorShortcuts,
    AMCellTypeRecommand,
    AMCellTypeFeedback,
    AMCellTypeAbout
};

@interface AboutMeViewController ()<UITabBarDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) NSArray *sections;

@end

@implementation AboutMeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerImageView.layer.cornerRadius = 38;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.sections = @[@[@"我创建的快捷键", @"我收藏的快捷键"],
                      @[@"推荐APP给好友"],
                      @[@"用户反馈", @"关于"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear width = %f", self.tableView.frame.size.width);
    [self updateLoginState];
}

//2016-06-24 08:49:01.082 ShortcutKeyBook[10728:518783] viewWillAppear width = 320.000000
//2016-06-24 08:49:01.086 ShortcutKeyBook[10728:518783] viewWillLayoutSubviews width = 320.000000
//2016-06-24 08:49:01.099 ShortcutKeyBook[10728:518783] viewDidAppear width = 375.000000

//2016-06-24 08:50:48.627 ShortcutKeyBook[10775:520948] viewWillAppear width = 375.000000
//2016-06-24 08:50:48.630 ShortcutKeyBook[10775:520948] viewWillLayoutSubviews width = 375.000000
//2016-06-24 08:50:48.635 ShortcutKeyBook[10775:520948] viewWillLayoutSubviews width = 375.000000
//2016-06-24 08:50:48.644 ShortcutKeyBook[10775:520948] viewDidAppear width = 375.000000

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews width = %f", self.tableView.frame.size.width);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear width = %f", self.tableView.frame.size.width);
}


#pragma mark - Private

- (void)cleanUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserInfo"];
}

- (void)updateLoginState
{
    LoginManager *loginManager = [LoginManager sharedInstance];
    if (loginManager.logged) {
        NSLog(@"已登录");
        [self.loginButton setTitle:@"退出登录"];
       if (loginManager.currentUserInfo.nickname.length > 0) {
            self.usernameLabel.text = loginManager.currentUserInfo.nickname;
        } else {
            self.usernameLabel.text = loginManager.currentUserInfo.username;
        }
        self.headerImageView.image = [UIImage imageNamed:@"chaiquan"];
    } else {
        NSLog(@"未登录");
        self.usernameLabel.text = @"未登录";
        [self.loginButton setTitle:@"点击登录"];
        self.headerImageView.image = [UIImage imageNamed:@"default_header"];
    }
}

- (AMCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        count += ((NSArray *)self.sections[i]).count;
    }
    return count + indexPath.row;
}

- (void)shareApp
{
    // 设置分享标
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"快捷键大全";
    // 设置分享类型，类型包括UMSocialWXMessageTypeImage、UMSocialWXMessageTypeText、UMSocialWXMessageTypeApp以及其他
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    // 不设置type的时候才生效
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"https://itunes.apple.com/us/app/kuai-jie-jian-da-quan/id1126204786?l=zh&ls=1&mt=8"; // 这里填写为应用地址
    
    UIImage *appImage = [UIImage imageNamed:@"108x108"];
    NSString *content = @"我正在使用《快捷键大全》，挺不错的应用，你也来试试吧！";
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:content shareImage:appImage shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline] delegate:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.sections[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = kAppTextColor;
    AMCellType cellTye = [self cellTypeForIndexPath:indexPath];
    switch (cellTye) {
        case AMCellTypeMyCreatedShortcuts: {
            cell.imageView.image = [UIImage imageNamed:@"create"];
            cell.textLabel.text = @"我创建的快捷键";
            break;
        }
        case AMCellTypeFavorShortcuts: {
            cell.imageView.image = [UIImage imageNamed:@"favor"];
            cell.textLabel.text = @"我收藏的快捷键";
            break;
        }
        case AMCellTypeRecommand: {
            cell.imageView.image = [UIImage imageNamed:@"recommend"];
            cell.textLabel.text = @"推荐APP给好友";
            break;
        }
        case AMCellTypeFeedback: {
            cell.imageView.image = [UIImage imageNamed:@"feedback"];
            cell.textLabel.text = @"用户反馈";
            break;
        }
        case AMCellTypeAbout: {
            cell.imageView.image = [UIImage imageNamed:@"about"];
            cell.textLabel.text = @"关于";
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

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
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMCellType cellTye = [self cellTypeForIndexPath:indexPath];
    switch (cellTye) {
        case AMCellTypeMyCreatedShortcuts: {
            if (![LoginManager sharedInstance].logged) {
                LoginViewController *loginViewController = [LoginViewController new];
                [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
                return;
            }
            MyCreatedViewController *vc = [MyCreatedViewController myCreatedViewController];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case AMCellTypeFavorShortcuts: {
            MyFavorViewController *vc = [MyFavorViewController myFavorViewController];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case AMCellTypeRecommand: {
            [self shareApp];
            break;
        }
        case AMCellTypeFeedback: {
            [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
            break;
        }
        case AMCellTypeAbout: {
            SoftwareInfoViewController *vc = [SoftwareInfoViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Button action

- (IBAction)onLoginButtonClicked:(id)sender
{
    if ([LoginManager sharedInstance].logged) {
        [LoginManager sharedInstance].logged = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *username = [LoginManager sharedInstance].currentUserInfo.username;
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
            [self cleanUserInfo];
            [self.view toastWithMessage:@"退出登录成功"];
            [self updateLoginState];
        });
    }
    else {
        LoginViewController *loginViewController = [LoginViewController new];
        [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
    }
}

@end
