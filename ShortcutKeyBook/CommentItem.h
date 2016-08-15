//
//  CommentItem.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/2.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentItem : NSObject

@property (assign, nonatomic) NSInteger commentId;
@property (copy, nonatomic) NSString *addTime;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *createAccount;
@property (copy, nonatomic) NSString *userNickname;

- (instancetype)initWithJsonData:(NSDictionary *)jsonData;

@end
