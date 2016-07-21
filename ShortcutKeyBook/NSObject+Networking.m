//
//  NSObject+Networking.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/1.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "NSObject+Networking.h"
#import <AFNetworking/AFNetworking.h>
#import "XMLDictionary.h"

@implementation NSObject (Networking)

- (void)requestWithProtocalName:(NSString *)protocalName
                   paramString:(NSString *)paramString
              completionHandler:(void(^)(NSError *error, id bodyData))completionHandler
{
    NSString *url = nil;
    if (paramString) {
        url = [NSString stringWithFormat:@"http://%@/%@.php?%@", HOST, protocalName, paramString];
    } else {
        url = [NSString stringWithFormat:@"http://%@/%@.php", HOST, protocalName];
    }
    
    NSURL *testUrl = [NSURL URLWithString:url];
    NSLog(@"testUrl = %@", testUrl);

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithXMLData:responseObject];
        NSLog(@"respone result = %@", dic);
        if (completionHandler) {
            completionHandler(nil, dic[@"body"]);
        }
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error = %@", error);
             if (completionHandler) {
                 completionHandler(error, nil);
             }
         }];
}

- (void)postWithProtocalName:(NSString *)protocalName
                  parameters:(NSDictionary *)parameters
           completionHandler:(void(^)(NSError *error, id bodyData))completionHandler
{
    NSString *URLString = [NSString stringWithFormat:@"http://%@/%@.php", HOST, protocalName];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithXMLData:responseObject];
        if (completionHandler) {
            completionHandler(nil, dic[@"body"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        if (completionHandler) {
            completionHandler(error, nil);
        }
    }];
}

@end
