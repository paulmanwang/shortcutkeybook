//
//  SoftwareItem.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/2.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SoftwareItem.h"

@implementation SoftwareItem

- (instancetype)initWithJsonData:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        self.softwareId = ((NSNumber *)jsonData[@"id"]).integerValue;
        self.createAccount = jsonData[@"create_account"];
        self.softwareName = [jsonData[@"name"] stringByDecodingURIComponent];
        self.commentCount = ((NSNumber *)jsonData[@"comment_count"]).integerValue;
        self.addTime = jsonData[@"add_time"];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.softwareName = [aDecoder decodeObjectForKey:@"softwareName"];
        self.createAccount = [aDecoder decodeObjectForKey:@"createAccount"];
        self.softwareId = [aDecoder decodeIntegerForKey:@"softwareId"];
        self.commentCount = [aDecoder decodeIntegerForKey:@"commentCount"];
        self.addTime = [aDecoder decodeObjectForKey:@"add_time"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.softwareId forKey:@"softwareId"];
    [aCoder encodeObject:self.createAccount forKey:@"createAccount"];
    [aCoder encodeObject:self.softwareName forKey:@"softwareName"];
    [aCoder encodeInteger:self.commentCount forKey:@"commentCount"];
    [aCoder encodeObject:self.addTime forKey:@"addTime"];
}

@end
