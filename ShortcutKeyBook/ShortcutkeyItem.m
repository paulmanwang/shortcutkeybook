//
//  ShortcutkeyItem.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/2.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ShortcutkeyItem.h"

@implementation ShortcutkeyItem

- (instancetype)initWithJsonData:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        self.shortcutKeyId = ((NSNumber *)jsonData[@"id"]).integerValue;
        self.shortcutKeyName = [jsonData[@"name"] stringByDecodingURIComponent];
        self.shortcutKeyDetail = [jsonData[@"detail"] stringByDecodingURIComponent];
    }
    
    return self;
}

@end
