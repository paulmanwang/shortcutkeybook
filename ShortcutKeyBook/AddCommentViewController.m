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
@property (assign, nonatomic) NSInteger softwareId;
@property (weak, nonatomic) IBOutlet UIView *loginTipsView;

@end

@implementation AddCommentViewController

+ (instancetype)initWithSoftwareId:(NSInteger)softwareId
{
    AddCommentViewController *vc = [AddCommentViewController new];
    vc.softwareId = softwareId;
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
    if (content.length == 0) {
        NSLog(@"请填写评论内容");
        return;
    }
    
    NSString *createAccount = nil;
    if ([LoginManager sharedInstance].logged) {
        createAccount = [LoginManager sharedInstance].currentUserInfo.username;
    } else {
        createAccount = @"wlcunknownwlc";
    }
    
    [[SoftwareManager sharedInstance] addCommentWithSoftwareId:self.softwareId createAccout:createAccount content:content completionHanlder:^(NSError *error, BOOL success) {
        if (success) {
            NSLog(@"添加评论成功");
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
