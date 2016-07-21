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
        self.softwareName = [jsonData[@"name"] stringByDecodingURIComponent];
        self.commentCount = ((NSNumber *)jsonData[@"comment_count"]).integerValue;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.softwareName = [aDecoder decodeObjectForKey:@"softwareName"];
        self.softwareId = ((NSNumber *)[aDecoder decodeObjectForKey:@"softwareId"]).integerValue;
        self.commentCount = ((NSNumber *)[aDecoder decodeObjectForKey:@"commentCount"]).integerValue;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.softwareId) forKey:@"softwareId"];
    [aCoder encodeObject:self.softwareName forKey:@"softwareName"];
    [aCoder encodeObject:@(self.commentCount) forKey:@"commentCount"];
}

@end
