//
//  AddCommentViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/5.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AddCommentViewController.h"
#import "SoftwareManager.h"
#import "LoginManager.h"
#import "LoginViewController.h"

@interface AddCommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) SoftwareItem *softwareItem;
@property (weak, nonatomic) IBOutlet UIView *loginTipsView;

@end

@implementation AddCommentViewController

+ (instancetype)initWithSoftwareItem:(SoftwareItem *)item
{
    AddCommentViewController *vc = [AddCommentViewController new];
    vc.softwareItem = item;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加评论";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmit)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([LoginManager sharedInstance].logged) {
        self.loginTipsView.hidden = YES;
    } else {
        self.loginTipsView.hidden = NO;
    }
}

- (void)onSubmit
{
    NSString *content = self.textField.text;
    if (content.length == 0 || [content isEqualToString:@"输入评价内容"]) {
        [self.view toastWithMessage:@"请填写评论内容"];
        return;
    }
    
    NSString *createAccount = @"wlcunknownwlc";
    if ([LoginManager sharedInstance].logged) {
        createAccount = [LoginManager sharedInstance].currentUserInfo.username;
    }
    
    [[SoftwareManager sharedInstance] addCommentWithSoftwareId:self.softwareItem.softwareId createAccout:createAccount content:content completionHanlder:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"添加评论成功");
            self.softwareItem.commentCount += 1;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"添加评论失败");
        }
    }];
}

- (IBAction)onLoginBtnClicked:(id)sender
{
    LoginViewController *loginViewController = [LoginViewController new];
    [self presentViewControllerWithNavi:loginViewController animated:YES completion:nil];
}

@end
