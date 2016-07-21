//
//  NSString+JSON.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/5.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (NSDictionary *)toJsonData
{
    if (self.length == 0) {
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *serializeError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&serializeError];
    return dict;
}

+ (NSString *)stringWithJsonData:(NSDictionary *)jsonData
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
