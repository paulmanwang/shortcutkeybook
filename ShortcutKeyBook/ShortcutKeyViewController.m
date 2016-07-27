//
//  ShortcutKeyViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ShortcutKeyViewController.h"
#import "ShortcutKeyCell.h"
#import "CommentViewController.h"
#import "SoftwareManager.h"
#import "AddCommentViewController.h"
#import "WLCToastView.h"
#import "WLCPraiseView.h"
#import "WLCCommentView.h"
#import "LoginViewController.h"
#import "UMSocial.h"

@interface ShortcutKeyViewController ()<WLCPraiseViewDelegate, WLCCommentViewDelegate, UMSocialUIDelegate>

@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (assign, nonatomic) SoftwareItem *softwareItem;
@property (copy, nonatomic) NSArray *shortcutKeys;
@property (assign, nonatomic) BOOL hasComment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *usedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet WLCPraiseView *praiseView;
@property (weak, nonatomic) IBOutlet WLCCommentView *commentView;

@end

@implementation ShortcutKeyViewController

- (instancetype)initWithSoftwareItem:(SoftwareItem *)item
{
    self = [super init];
    if (self) {
        self.softwareItem = item;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@快捷键", self.softwareItem.softwareName];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShortcutKeyCell" bundle:nil] forCellReuseIdentifier:@"ShortcutKeyCell"];
    
    self.praiseView.delegate = self;
    self.commentView.delegate = self;
    
    /*
     The back indicator image is shown beside the back button.
     The back indicator transition mask image is used as a mask for content during push and pop transitions
     Note: These properties must both be set if you want to customize the back indicator image.
     */
//    @property(nullable,nonatomic,strong) UIImage *backIndicatorImage NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
//    @property(nullable,nonatomic,strong) UIImage *backIndicatorTransitionMaskImage NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED;
//
//    
//    UIImage *backImage = [UIImage imageNamed:@"navibar_back_btn"];
//    self.navigationController.navigationBar.backIndicatorImage = backImage;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage;
//    
//    // self.navigationItem.hidesBackButton = YES; // 隐藏按钮之后，箭头也不见了
//    self.backItem = [[UIBarButtonItem alloc] initWithTitle:@"呵呵" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
//    self.navigationItem.backBarButtonItem = self.backItem;
    
    if ([self.softwareItem.createAccount isEqualToString:@"wlcunknownwlc"]) {
        self.authorLabel.text = @"匿名用户";
    } else {
        self.authorLabel.text = self.softwareItem.createAccount;
    }
    
    NSArray *subStrings = [self.softwareItem.addTime componentsSeparatedByString:@" "];
    self.timeLabel.text = subStrings[0];
    
    [[SoftwareManager sharedInstance] queryAllShortcutKeysOfSoftware:self.softwareItem.softwareId completionHandler:^(NSError *error, NSArray *shortcutKeys) {
        if (!error) {
            self.shortcutKeys = shortcutKeys;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger praiseCount = self.softwareItem.likeCount;
    if (praiseCount == 0) {
        self.praiseView.numberLabel.hidden = YES;
    }
    else {
        self.praiseView.numberLabel.hidden = NO;
        self.praiseView.numberLabel.text = [NSString stringWithInteger:praiseCount];
    }
    
    NSInteger commentCount = self.softwareItem.commentCount;
    if (commentCount == 0) {
        self.commentView.numberLabel.hidden = YES;
    }
    else {
        self.commentView.numberLabel.hidden = NO;
        self.commentView.numberLabel.text = [NSString stringWithInteger:commentCount];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (BOOL)checkFavor
{
    NSArray *favorSoftwares = [[SoftwareManager sharedInstance] loadMyFavorSoftwares];
    for (SoftwareItem *favorItem in favorSoftwares) {
        if (favorItem.softwareId == self.softwareItem.softwareId) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shortcutKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShortcutkeyItem *item = self.shortcutKeys[indexPath.row];
    ShortcutKeyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShortcutKeyCell"];
    [cell fillData:item];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShortcutKeyCell cellHeight];
}

#pragma mark - Button actions

- (IBAction)onShareBtnClicked:(id)sender
{
    [self share];
}

- (IBAction)onBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onFavorButtonClicked:(id)sender
{
    BOOL ret = [[SoftwareManager sharedInstance] addMyFavorSoftware:self.softwareItem];
    if (ret) {
        NSLog(@"收藏成功");
        [self.view toastWithMessage:@"收藏成功"];
    } else {
        NSLog(@"收藏失败");
    }
}

#pragma mark - WLCPraiseViewDelegate

// 匿名用户也可以点赞
- (void)wlcPraiseViewDidClicked:(WLCPraiseView *)view
{
    BOOL hasThumbUp = [[SoftwareManager sharedInstance] softwareHasThumbUp:self.softwareItem];
    if (hasThumbUp) {
        [[SoftwareManager sharedInstance] thumbUpWithUp:NO softwareId:self.softwareItem.softwareId completionHandler:^(NSError *error, BOOL success) {
            if (success) {
                [[SoftwareManager sharedInstance] removeThumbUpSoftware:self.softwareItem];
                NSLog(@"取消点赞成功");
                self.softwareItem.likeCount -= 1;
                if (self.softwareItem.likeCount == 0) {
                    self.praiseView.numberLabel.hidden = YES;
                }
                self.praiseView.numberLabel.text = [NSString stringWithInteger:self.softwareItem.likeCount];
            }
        }];
    }
    else {
        [[SoftwareManager sharedInstance] thumbUpWithUp:YES softwareId:self.softwareItem.softwareId completionHandler:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"点赞成功");
                [[SoftwareManager sharedInstance] addThumbUpSoftware:self.softwareItem];
                self.softwareItem.likeCount += 1;
                self.praiseView.numberLabel.hidden = NO;
                self.praiseView.numberLabel.text = [NSString stringWithInteger:self.softwareItem.likeCount];
            }
        }];
    }
}

#pragma mark - WLCCommentViewDelegate

// 评论之前，请先登录
- (void)wlcCommentViewDidClicked:(WLCCommentView *)view
{
    UIViewController *viewController = nil;
    if (self.softwareItem.commentCount > 0) {
        viewController = [[CommentViewController alloc] initWithSoftwareItem:self.softwareItem];
    } else {
        if (![LoginManager sharedInstance].logged) {
            LoginViewController *loginViewController = [LoginViewController new];
            [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
            return;
        }
        
        viewController = [AddCommentViewController initWithSoftwareItem:self.softwareItem];
    }
    
    [self presentViewControllerWithNavi:viewController animated:YES completion:nil];
}

#pragma mark - Share

- (void)share
{
    // 设置分享标
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"xcode快捷键";
    // 设置分享类型，类型包括UMSocialWXMessageTypeImage、UMSocialWXMessageTypeText、UMSocialWXMessageTypeApp
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    // 不设置type的时候才生效
    // UMSocialData.defaultData().extConfig.wechatSessionData.url = "http://baidu.com" // 不填写默认跳转到了UMeng首页
    
    UIImage *appImage = [UIImage imageNamed:@""];
    NSString *content = @"总结的非常全面，很实用";
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:content shareImage:appImage shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline] delegate:self];
}

// 如果选择“留在微信”，不会有回调；如果选择“返回双龙戏珠”会有回调。
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"share to sns name is %@", response.data);
    }
}

@end
