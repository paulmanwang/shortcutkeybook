//
//  UserInfo.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>

@property (assign, nonatomic) NSInteger userId;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nickname;

@end
