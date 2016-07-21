//
//  NSString+JSON.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/5.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

- (NSDictionary *)toJsonData;

+ (NSString *)stringWithJsonData:(NSDictionary *)jsonData;

@end
