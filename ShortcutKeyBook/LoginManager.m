//
//  LoginManager.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "LoginManager.h"
#import "RNCryptor/RNCryptor.h"

@import RNCryptor;

@implementation LoginManager

IMPLEMENTATE_SHARED_INSTANCE(LoginManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentUserInfo = [UserInfo new];
    }
    
    return self;
}

- (NSString *)encryptPassword:(NSString *)password
{
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNCryptor encryptData:data password:RNCryptorPassword];
    
    return [encryptedData base64EncodedStringWithOptions:0];
}

- (void)loginWithUserName:(NSString *)username password:(NSString *)password completionHandler:(LoginCompletionHandler)completionHandler
{
    NSString *cipherPassword = [self encryptPassword:password];
    cipherPassword = [cipherPassword stringByEncodingURIComponent];
    
    NSString *paramsString = [NSString stringWithFormat:@"account=%@&password=%@",
                     username, cipherPassword];
    
    [self getWithProtocalName:@"login" paramString:paramsString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"login resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, LoginErrorTypeFail);
            }
            return;
        }
        
        LoginErrorType errorType = LoginErrorTypeFail;
        if ([resultString containsString:@"\"200\":\"OK\""]) {
            errorType = LoginErrorTypeSuccess;
            NSDictionary *info = [resultString toJsonData];
            self.logged = YES;
            self.currentUserInfo.userId = ((NSNumber *)info[@"id"]).integerValue;
            self.currentUserInfo.username = info[@"account"];
            self.currentUserInfo.nickname = info[@"nickname"];
        }
        else if ([resultString isEqualToString:@"406:Not Acceptable"]) {
            errorType = LoginErrorTypeInvalidPWD;
        }
        else if ([resultString isEqualToString:@"404:Not Found"]) {
            errorType = LoginErrorTypeUserNotFound;
        }
        
        if (completionHandler) {
            completionHandler(nil, errorType);
        }
    }];
}

- (void)registerWithUserName:(NSString *)username password:(NSString *)password nickname:(NSString *)nickname completionHandler:(RegisterCompletionHandler)completionHandler
{
    NSString *cipherPassword = [self encryptPassword:password];
    cipherPassword = [cipherPassword stringByEncodingURIComponent];
    NSString *encodedNickname = [nickname stringByEncodingURIComponent];
    NSString *paramString = [NSString stringWithFormat:@"account=%@&password=%@&nickname=%@",
                     username, cipherPassword, encodedNickname];
    
    [self getWithProtocalName:@"register" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"register resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, RegisterResultFail);
            }
            return;
        }
        
        RegisterResult result = RegisterResultFail;
        if ([resultString isEqualToString:@"200:OK"]) {
            result = RegisterResultSuccess;
        }
        else if ([resultString isEqualToString:@"409:Conflict"]) {
            result = RegisterResultConflict;
        }
        
        if (completionHandler) {
            completionHandler(nil, result);
        }
    }];
}


@end
