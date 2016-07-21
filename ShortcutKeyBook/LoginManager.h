//
//  LoginManager.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef NS_ENUM(NSInteger, RegisterResult)
{
    RegisterResultSuccess =  0,
    RegisterResultConflict = 1,
    RegisterResultFail     = 2
};

typedef NS_ENUM(NSInteger, LoginErrorType)
{
    LoginErrorTypeSuccess = 0,
    LoginErrorTypeUserNotFound = 1, // 用户不存在
    LoginErrorTypeInvalidPWD   = 2, // 密码错误
    LoginErrorTypeFail = 3 // 其他错误
};

typedef void(^LoginCompletionHandler)(NSError *error, LoginErrorType result);
typedef void(^RegisterCompletionHandler)(NSError *error, RegisterResult result);

@interface LoginManager : NSObject

DECLARA_SHARED_INSTANCE

@property (strong, nonatomic) UserInfo *currentUserInfo;
@property (assign, nonatomic) BOOL logged;

- (void)loginWithUserName:(NSString *)username password:(NSString *)password completionHandler:(LoginCompletionHandler)completionHandler;

- (void)registerWithUserName:(NSString *)username password:(NSString *)password nickname:(NSString *)nickname completionHandler:(RegisterCompletionHandler)completionHandler;

@end
