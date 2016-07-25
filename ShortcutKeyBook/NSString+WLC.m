//
//  NSString+JSON.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/5.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "NSString+WLC.h"

@implementation NSString (WLC)

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

// 用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，如果需要去掉音标，
// 则继续使用kCFStringTransformStripCombiningMarks方法即可。
- (NSString *)transformToChinise
{
    if (self.length == 0) {
        return nil;
    }
    
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

- (BOOL)isPureLetter
{
    if (self == nil) {
        return NO;
    }
    
    if ([self isEqualToString:@""]) {
        return YES;
    }
    
    for (NSInteger i = 0; i < self.length; i++) {
        unichar letter = [self characterAtIndex:i];
        if (!(letter >= 'a' && letter <= 'z')
            && !(letter >= 'A' && letter <= 'Z')) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isPureNumber
{
    if (self.length == 0) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.length; i++) {
        unichar letter = [self characterAtIndex:i];
        if (!(letter >= '0' && letter <= '9')) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)prefixIsNumber
{
    if (self.length == 0) {
        return NO;
    }
    
    unichar firstLetter = [self characterAtIndex:0];
    if (firstLetter >= '0' && firstLetter <= '9') {
        return YES;
    }
    
    return NO;
}

- (BOOL)isPureLetterAndNumber
{
    if (self.length == 0) {
        return YES;
    }
    
    for (NSInteger i = 0; i < self.length; i++) {
        unichar letter = [self characterAtIndex:i];
        if (!(letter >= 'a' && letter <= 'z')
            && !(letter >= 'A' && letter <= 'Z')
            && !(letter >= '0' && letter <= '9')
            && letter != '.') {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isLetterBeforeNumer
{
    if (self.length == 0) {
        return NO;
    }
    
    if (![self isPureLetterAndNumber] || [self prefixIsNumber]) {
        return NO;
    }
    
    // 找到第一个数字的下标
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.length; i++) {
        unichar letter = [self characterAtIndex:i];
        if (letter >= '0' && letter <= '9') {
            index = i;
            break;
        }
    }
    
    if (index == -1) {
        return YES;
    }
    
    for (NSInteger i = index+1; i < self.length; i++) {
        unichar letter = [self characterAtIndex:i];
        if (!(letter >= '0' && letter <= '9') && letter != '.') {
            return  NO;
        }
    }
    
    return YES;
}

@end
