//
//  RegisterViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/23.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginManager.h"
#import "WLCToastView.h"

static  NSString * const kLoginTips = @"已有账号？去登录";
static  NSString * const kRegisterTips = @"没有账号？去注册";

typedef NS_ENUM(NSUInteger, PageStatus)
{
    PageStatusLogin = 0,
    PageStatusRegister
};

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *handleButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *loginContainerView;
@property (strong, nonatomic) IBOutlet UIView *registerContainerView;
@property (weak, nonatomic) IBOutlet UITextField *registerUserNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *registerNicknameLabel;

@property (weak, nonatomic) IBOutlet UITextField *loginUserNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordLabel;

@property (assign, nonatomic) PageStatus pageStatus;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    self.handleButton.layer.cornerRadius = 8;
    self.pageStatus = PageStatusLogin;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.tipsLabel addGestureRecognizer:tapGesture];
}

//2016-06-24 00:33:34.164 ShortcutKeyBook[10204:498560] view width = 265.000000
//2016-06-24 00:33:34.168 ShortcutKeyBook[10204:498560] lay width = 265.000000
//2016-06-24 00:33:34.177 ShortcutKeyBook[10204:498560] lay width = 320.000000
//2016-06-24 00:33:34.183 ShortcutKeyBook[10204:498560] lay width = 320.000000
// 对比一下非autolayout模式

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"view width = %f", self.scrollView.frame.size.width);
    // [self layoutSubView]; 无效，
    
    // 延迟一个runloop执行就是对的了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutSubView];
    });
}

- (void)viewWillLayoutSubviews // 调用时机问题，貌似做动画的时候也调用了
{
    [super viewWillLayoutSubviews];
    // [self layoutSubView];
}

- (void)layoutSubView
{
    NSLog(@"layoutSubView width = %f", self.scrollView.frame.size.width);
    
    [self.loginContainerView removeFromSuperview];
    [self.registerContainerView removeFromSuperview];
    
    CGFloat width = self.scrollView.width;
    CGFloat height = self.scrollView.height;
    
    self.scrollView.contentSize = CGSizeMake(width * 2, height);
    // 点击按钮，会调用viewWillLayoutSubviews
    // self.scrollView.contentOffset = CGPointMake(0, 0);
    
    self.loginContainerView.frame = CGRectMake(0, 0, width, height);
    [self.scrollView addSubview:self.loginContainerView];
    
    self.registerContainerView.frame = CGRectMake(width, 0, width, height);
    [self.scrollView addSubview:self.registerContainerView];
}

- (void)onTap
{
    if (self.pageStatus == PageStatusLogin) {
        self.tipsLabel.text = kLoginTips;
        self.handleButton.titleLabel.text = @"注册";
        self.title = @"注册";
        self.pageStatus = PageStatusRegister;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat width = self.scrollView.frame.size.width;
            self.scrollView.contentOffset = CGPointMake(width, 0);
        }];
    }
    else {
        self.tipsLabel.text = kRegisterTips;
        self.handleButton.titleLabel.text = @"登录";
        self.title = @"登录";
        self.pageStatus = PageStatusLogin;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)login
{
    NSString *username = self.loginUserNameLabel.text;
    NSString *pwd = self.loginPasswordLabel.text;
    [[LoginManager sharedInstance] loginWithUserName:username password:pwd completionHandler:^(NSError *error, LoginErrorType result) {
        if (result == LoginErrorTypeSuccess) {
            [self dismiss];
            [self.view toastWithMessage:@"登录成功"];
            NSLog(@"登录成功");
        }
        else if (result == LoginErrorTypeInvalidPWD) {
            NSLog(@"密码错误");
            [self.view toastWithMessage:@"密码错误"];
        }
        else if (result == LoginErrorTypeUserNotFound) {
            NSLog(@"该用户不存在");
            [self.view toastWithMessage:@"该用户不存在"];
        }
        else {
            NSLog(@"登录失败");
            [self.view toastWithMessage:@"登录失败"];
        }
    }];
}

- (void)regiseter
{
    NSString *username = self.registerUserNameLabel.text;
    NSString *pwd = self.registerUserNameLabel.text;
    NSString *nickname = self.registerNicknameLabel.text;
    [[LoginManager sharedInstance] registerWithUserName:username password:pwd nickname:nickname completionHandler:^(NSError *error, RegisterResult result) {
        if (result == RegisterResultSuccess) {
            NSLog(@"注册成功");
        }
        else if (result == RegisterResultConflict) {
            NSLog(@"该用户已存在");
        }
        else {
            NSLog(@"注册失败");
        }
    }];
}

- (IBAction)onLoginBtnClicked:(id)sender
{
    if (self.pageStatus == PageStatusLogin) {
        [self login];
    }
    else {
        [self regiseter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
