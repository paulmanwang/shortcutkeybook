//
//  NSObject+Networking.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/1.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Networking)

// 类别的运行时
- (void)getWithProtocalName:(NSString *)protocalName
                    paramString:(NSString *)paramsString
              completionHandler:(void(^)(NSError *error, id bodyData))completionHandler;

- (void)postWithProtocalName:(NSString *)protocalName
                  parameters:(NSDictionary *)parameters
           completionHandler:(void(^)(NSError *error, id bodyData))completionHandler;

@end
