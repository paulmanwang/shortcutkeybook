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
@property (weak, nonatomic) IBOutlet UITextField *registerUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerNicknameTextField;

@property (weak, nonatomic) IBOutlet UITextField *loginUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;

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
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length > 0) {
        self.loginUserNameTextField.text = username;
    }
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

- (void)changeToLoginStatus
{
    self.tipsLabel.text = kRegisterTips;
    self.handleButton.titleLabel.text = @"登录";
    self.title = @"登录";
    self.pageStatus = PageStatusLogin;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)changeToRegesterStatus
{
    self.tipsLabel.text = kLoginTips;
    self.handleButton.titleLabel.text = @"注册";
    self.title = @"注册";
    self.pageStatus = PageStatusRegister;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat width = self.scrollView.frame.size.width;
        self.scrollView.contentOffset = CGPointMake(width, 0);
    }];
}

- (void)onTap
{
    if (self.pageStatus == PageStatusLogin) {
        [self changeToRegesterStatus];
    }
    else {
        [self changeToLoginStatus];
    }
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveUserInfo
{
    UserInfo *userInfo = [LoginManager sharedInstance].currentUserInfo;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"kUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)login
{
    if ([self.loginUserNameTextField isFirstResponder]) {
        [self.loginUserNameTextField resignFirstResponder];
    }
    
    if ([self.loginPasswordTextField isFirstResponder]) {
        [self.loginPasswordTextField resignFirstResponder];
    }
    
    if (self.loginUserNameTextField.text.length == 0) {
        [self.view toastWithMessage:@"请输入用户名"];
        return;
    }
    
    if (self.loginPasswordTextField.text.length == 0) {
        [self.view toastWithMessage:@"请输入密码"];
        return;
    }
    
    NSString *username = self.loginUserNameTextField.text;
    NSString *pwd = self.loginPasswordTextField.text;
    [self.view showLoadingViewWithText:@"正在登录..."];
    [[LoginManager sharedInstance] loginWithUserName:username password:pwd completionHandler:^(NSError *error, LoginErrorType result) {
        [self.view dismissLoadingView];
        if (result == LoginErrorTypeSuccess) {
            [self dismiss];
            [self.view toastWithMessage:@"登录成功"];
            [self saveUserInfo];
        }
        else if (result == LoginErrorTypeInvalidPWD) {
            [self.view toastWithMessage:@"密码错误"];
        }
        else if (result == LoginErrorTypeUserNotFound) {
            [self.view toastWithMessage:@"该用户不存在"];
        }
        else {
            [self.view toastWithMessage:@"登录失败"];
        }
    }];
}

- (BOOL)checkRegisterUserName
{
    NSString *registerUserName = self.registerUserNameTextField.text;
    for (NSInteger i = 0; i < registerUserName.length; i++) {
        unichar letter = [registerUserName characterAtIndex:i];
        if (!(letter >= 'a' && letter <= 'z')
            && !(letter >= 'A' && letter <= 'Z')
            && !(letter >= '0' && letter <= '9')
            && letter != '.' && letter != '@') {
            return NO;
        }
    }
    
    return YES;
}

- (void)regiseter
{
    if ([self.registerUserNameTextField isFirstResponder]) {
        [self.registerUserNameTextField resignFirstResponder];
    }
    
    if ([self.registerPasswordTextField isFirstResponder]) {
        [self.registerPasswordTextField resignFirstResponder];
    }
    
    if ([self.registerNicknameTextField isFirstResponder]) {
        [self.registerNicknameTextField resignFirstResponder];
    }
    
    if (self.registerUserNameTextField.text.length == 0) {
        [self.view toastWithMessage:@"请输入用户名"];
        return;
    }
    
    if (self.registerPasswordTextField.text.length == 0) {
        [self.view toastWithMessage:@"请输入密码"];
        return;
    }
    
    if (self.registerNicknameTextField.text.length == 0) {
        [self.view toastWithMessage:@"输入昵称"];
        return;
    }
    
    if (![self checkRegisterUserName]) {
        [self.view toastWithMessage:@"用户名包含非法字符"];
        return;
    }
    
    NSString *username = self.registerUserNameTextField.text;
    NSString *pwd = self.registerPasswordTextField.text;
    NSString *nickname = self.registerNicknameTextField.text;
    [self.view showLoadingViewWithText:@"正在注册..."];
    [[LoginManager sharedInstance] registerWithUserName:username password:pwd nickname:nickname completionHandler:^(NSError *error, RegisterResult result) {
        [self.view dismissLoadingView];
        if (result == RegisterResultSuccess) {
            [self.view toastWithMessage:@"注册成功"];
            
            self.loginUserNameTextField.text = username;
            [self changeToLoginStatus];
        }
        else if (result == RegisterResultConflict) {
            [self.view toastWithMessage:@"该用户已存在"];
        }
        else {
            [self.view toastWithMessage:@"注册失败"];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
