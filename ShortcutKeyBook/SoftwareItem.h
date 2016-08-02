//
//  SoftwareItem.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/2.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoftwareItem : NSObject

//"add_time" = "2016-06-26 03:24:40";
//"collect_count" = 0;
//"create_account" = laoya;
//detail = abc;
//id = 4;
//"like_count" = 0;
//logo = "";
//name = abc;
//"shared_count" = 0;

@property (assign, nonatomic) NSInteger softwareId;

@property (copy, nonatomic) NSString *createAccount; // to modify

@property (copy, nonatomic) NSString *softwareName;

@property (copy, nonatomic) NSString *detail;

@property (copy, nonatomic) NSString *logoPath;

@property (assign, nonatomic) NSUInteger likeCount;

@property (assign, nonatomic) NSUInteger sharedCount;

@property (assign, nonatomic) NSUInteger collectCount;

@property (assign, nonatomic) NSUInteger commentCount;

@property (assign, nonatomic) NSUInteger browseCount;

@property (copy, nonatomic) NSString *addTime;

- (instancetype)initWithJsonData:(NSDictionary *)jsonData;

@end
