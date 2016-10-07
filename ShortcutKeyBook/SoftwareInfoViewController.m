//
//  SoftwareInfoViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/30.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SoftwareInfoViewController.h"

@interface SoftwareInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (assign, nonatomic) CGPoint beginPoint;

@property (strong, nonatomic) NSArray *softwareInfos;
@property (assign, nonatomic) NSInteger importedIndex;
@property (weak, nonatomic) IBOutlet UIButton *importButton;

@end

@implementation SoftwareInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.softwareInfos = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于";
    self.importButton.hidden = YES;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"version:%@", appVersion];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        self.importButton.hidden = NO;
    }
}

- (void)importSingleSoftware
{
    NSString *softwareInfo = self.softwareInfos[self.importedIndex];
    NSArray *components = [softwareInfo componentsSeparatedByString:@"\n"];
    NSString *softwareName = components[0];
    
    NSMutableArray *addedShortcuts = [NSMutableArray array];
    for (NSInteger i = 1; i < components.count; i++) {
        NSString *shortcutInfo = components[i];
        if (shortcutInfo.length > 0) {
            NSArray *shortcutComponents = [shortcutInfo componentsSeparatedByString:@"||"];
            NSString *shortcutDetail = shortcutComponents[0];
            NSString *shortcutName = shortcutComponents[1];
            
            NSMutableDictionary *info = [NSMutableDictionary new];
            info[@"name"] = [shortcutName stringByEncodingURIComponent];
            info[@"detail"] = [shortcutDetail stringByEncodingURIComponent];
            [addedShortcuts addObject:info];
        }
    }
    
    // 插入软件信息
    NSString *account = nil;
    if ([LoginManager sharedInstance].logged) {
        account = [LoginManager sharedInstance].currentUserInfo.username;
    } else {
        account = @"15019224279";
    }
    softwareName = [softwareName stringByEncodingURIComponent];

    [[SoftwareManager sharedInstance] createSoftwareWithName:softwareName shortcutKeys:addedShortcuts account:account completionHandler:^(NSError *error, BOOL success) {
        self.importedIndex++;
        if (self.importedIndex < self.softwareInfos.count) {
            [self importSingleSoftware];
            
            if (error) {
                NSLog(@"%@导入失败", softwareName);
            }
            else {
                NSLog(@"%@导入成功", softwareName);
            }
        }
        else {
            self.importButton.enabled = YES;
            self.importButton.hidden = YES;
        }
    }];
}

- (IBAction)onImportButtonClicked:(id)sender
{
    self.importButton.enabled = NO;
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shortcut" ofType:@"txt"] encoding:NSUTF8StringEncoding error: &error];
    self.softwareInfos = [textFileContents componentsSeparatedByString:@"&&&&&&\n"];
    
    self.importedIndex = 0;
    [self importSingleSoftware];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/*
NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
CFShow(infoDictionary);
// app名称
NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
// app版本
NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
// app build版本
NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];

//手机序列号
NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
NSLog(@"手机序列号: %@",identifierNumber);
//手机别名： 用户定义的名称
NSString* userPhoneName = [[UIDevice currentDevice] name];
NSLog(@"手机别名: %@", userPhoneName);
//设备名称
NSString* deviceName = [[UIDevice currentDevice] systemName];
NSLog(@"设备名称: %@",deviceName );
//手机系统版本
NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
NSLog(@"手机系统版本: %@", phoneVersion);
//手机型号
NSString* phoneModel = [[UIDevice currentDevice] model];
NSLog(@"手机型号: %@",phoneModel );
//地方型号  （国际化区域名称）
NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
NSLog(@"国际化区域名称: %@",localPhoneModel );

NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
// 当前应用名称
NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
NSLog(@"当前应用名称：%@",appCurName);
// 当前应用软件版本  比如：1.0.1
NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
NSLog(@"当前应用软件版本:%@",appCurVersion);
// 当前应用版本号码   int类型
NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
NSLog(@"当前应用版本号码：%@",appCurVersionNum);
*/
@end
