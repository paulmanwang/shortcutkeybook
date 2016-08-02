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

@end

@implementation SoftwareInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"version:%@", appVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
