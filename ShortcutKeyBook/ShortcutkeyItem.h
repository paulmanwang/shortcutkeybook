//
//  ShortcutkeyItem.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/2.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutkeyItem : NSObject

@property (assign, nonatomic) NSInteger shortcutKeyId;

@property (copy, nonatomic) NSString *shortcutKeyName;

@property (copy, nonatomic) NSString *shortcutKeyDetail;

- (instancetype)initWithJsonData:(NSDictionary *)jsonData;

@end
