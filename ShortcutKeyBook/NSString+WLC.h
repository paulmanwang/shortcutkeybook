//
//  NSString+JSON.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/5.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WLC)

- (id)toJsonData;

+ (NSString *)stringWithJsonData:(NSDictionary *)jsonData;

- (NSString *)transformToChinise;

// 判断字符串是否为纯英文
- (BOOL)isPureLetter;

// 判断为纯数字
- (BOOL)isPureNumber;

// 判断首字母是否为数字
- (BOOL)prefixIsNumber;

// 只包括字母和数字
- (BOOL)isPureLetterAndNumber;

// 形如“xcode 2.3”的字符串
- (BOOL)isLetterBeforeNumer;

+ (NSString *)stringWithInteger:(NSInteger)integer;

@end
