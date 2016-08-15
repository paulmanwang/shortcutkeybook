//
//  CommentItem.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/2.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "CommentItem.h"

@implementation CommentItem

- (instancetype)initWithJsonData:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        self.commentId = ((NSNumber *)jsonData[@"id"]).integerValue;
        self.createAccount = jsonData[@"create_account"];
        self.userNickname = jsonData[@"user_nickname"];
        self.content = jsonData[@"content"];
        self.addTime = jsonData[@"add_time"];
    }
    
    return self;
}

@end
