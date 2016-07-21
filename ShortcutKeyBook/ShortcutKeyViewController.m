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

@interface ShortcutKeyViewController ()

@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (assign, nonatomic) SoftwareItem *softwareItem;
@property (copy, nonatomic) NSArray *shortcutKeys;
@property (assign, nonatomic) BOOL hasComment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

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
    [self.tableView registerNib:[UINib nibWithNibName:@"ShortcutKeyCell" bundle:nil] forCellReuseIdentifier:@"ShortcutKeyCell"];
    
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
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[SoftwareManager sharedInstance] queryAllShortcutKeysOfSoftware:self.softwareItem.softwareId completionHandler:^(NSError *error, NSArray *shortcutKeys) {
        if (!error) {
            self.shortcutKeys = shortcutKeys;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)onBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCommentBtnClicked:(id)sender
{
    UIViewController *viewController = nil;
    if (self.softwareItem.commentCount > 0) {
        viewController = [[CommentViewController alloc] initWithSoftwareId:self.softwareItem.softwareId];
    } else {
        viewController = [AddCommentViewController initWithSoftwareId:self.softwareItem.softwareId];
    }
    
    [self presentViewControllerWithNavi:viewController animated:YES completion:nil];
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

- (IBAction)onThumbUpBtnClicked:(id)sender
{
    BOOL hasThumbUp = [[SoftwareManager sharedInstance] softwareHasThumbUp:self.softwareItem];
    if (hasThumbUp) {
        [[SoftwareManager sharedInstance] removeThumbUpSoftware:self.softwareItem];
        [[SoftwareManager sharedInstance] thumbUpWithUp:NO softwareId:self.softwareItem.softwareId completionHandler:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"取消点赞成功");
            }
        }];
    }
    else {
        [[SoftwareManager sharedInstance] addThumbUpSoftware:self.softwareItem];
        [[SoftwareManager sharedInstance] thumbUpWithUp:YES softwareId:self.softwareItem.softwareId completionHandler:^(NSError *error, BOOL success) {
            if (success) {
                NSLog(@"点赞成功");
            }
        }];
    }

}

@end
