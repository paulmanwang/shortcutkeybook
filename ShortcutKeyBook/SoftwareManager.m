//
//  SoftwareManager.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/1.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SoftwareManager.h"
#import <AFNetworking/AFNetworking.h>
#import "XMLDictionary.h"
#import "SoftwareItem.h"
#import "ShortcutkeyItem.h"
#import "CommentItem.h"

@interface SoftwareManager ()

@property (strong, nonatomic) NSMutableArray *favorSoftwares;
@property (strong, nonatomic) NSMutableArray *thumbUpSoftwares;

@end

@implementation SoftwareManager

IMPLEMENTATE_SHARED_INSTANCE(SoftwareManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.favorSoftwares = [NSMutableArray array];
        self.thumbUpSoftwares = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Favor Software

- (NSString *)favorSoftwareFilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/Preferences/favor_softwares.plist"];
}

- (NSArray *)loadMyFavorSoftwares
{
    [self.favorSoftwares removeAllObjects];
    
    NSString *path = [self favorSoftwareFilePath];
    NSArray *softwares = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self.favorSoftwares addObjectsFromArray:softwares];
    return self.favorSoftwares;
}

- (BOOL)addMyFavorSoftware:(SoftwareItem *)item
{
    [self loadMyFavorSoftwares];
    for (SoftwareItem *existedItem in self.favorSoftwares) {
        if (existedItem.softwareId == item.softwareId) {
            return YES;
        }
    }
    
    NSString *path = [self favorSoftwareFilePath];
    [self.favorSoftwares addObject:item];
    return [NSKeyedArchiver archiveRootObject:self.favorSoftwares toFile:path];
}

- (BOOL)removeMyFavorSoftware:(SoftwareItem *)item
{
    [self loadMyFavorSoftwares];
    
    SoftwareItem *destItem = nil;
    for (SoftwareItem *existedItem in self.favorSoftwares) {
        if (existedItem.softwareId == item.softwareId) {
            destItem = existedItem;
            break;
        }
    }
    
    [self.favorSoftwares removeObject:destItem];
    NSString *path = [self favorSoftwareFilePath];
    return [NSKeyedArchiver archiveRootObject:self.favorSoftwares toFile:path];
}

#pragma mark - GoodCommentSoftwares

- (NSString *)goodCommentSoftwareFilePath
{
      return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/Preferences/goodcomment_softwares.plist"];
}

- (NSArray *)loadThumbUpSoftwares
{
    [self.thumbUpSoftwares removeAllObjects];
    
    NSString *path = [self goodCommentSoftwareFilePath];
    NSArray *softwares = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self.thumbUpSoftwares addObjectsFromArray:softwares];
    return self.thumbUpSoftwares;
}

- (BOOL)addThumbUpSoftware:(SoftwareItem *)item
{
    for (SoftwareItem *existedItem in self.thumbUpSoftwares) {
        if (existedItem.softwareId == item.softwareId) {
            return YES;
        }
    }
    
    [self loadThumbUpSoftwares];
    [self.thumbUpSoftwares addObject:item];
    NSString *path = [self goodCommentSoftwareFilePath];
    return [NSKeyedArchiver archiveRootObject:self.thumbUpSoftwares toFile:path];
}

- (BOOL)removeThumbUpSoftware:(SoftwareItem *)item
{
    [self loadThumbUpSoftwares];
    for (NSInteger i = 0; i < self.thumbUpSoftwares.count; i++) {
        SoftwareItem *existItem = self.thumbUpSoftwares[i];
        if (item.softwareId == existItem.softwareId) {
            [self.thumbUpSoftwares removeObject:existItem];
            break;
        }
    }
    
    NSString *path = [self goodCommentSoftwareFilePath];
    return [NSKeyedArchiver archiveRootObject:self.thumbUpSoftwares toFile:path];
}

- (BOOL)softwareHasThumbUp:(SoftwareItem *)item
{
    [self loadThumbUpSoftwares];
    for (SoftwareItem *exsitItem in self.thumbUpSoftwares) {
        if (exsitItem.softwareId == item.softwareId) {
            return YES;
        }
    }
    
    return NO;
}

- (void)thumbUpWithUp:(BOOL)up softwareId:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, BOOL success))completionHandler
{
    NSInteger num = up ? 1 : -1;
    NSString *paramString = [NSString stringWithFormat:@"software_id=%li&num=%li", softwareId, num];
    [self getWithProtocalName:@"thumbup" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"thumbup resultString = %@", resultString);
        if (!completionHandler) {
            return;
        }
        
        if (error) {
            completionHandler(error, NO);
            return;
        }
        
        if ([resultString containsString:@"200:OK"]) {
            completionHandler(nil, YES);
        } else {
            NSError *error = [NSError errorWithDomain:@"server error" code:-1 userInfo:@{@"msg":resultString}];
            completionHandler(error, NO);
        }
    }];
}

#pragma mark - software

- (void)queryAllSoftwaresWithCompletionHandler:(void(^)(NSError *error, NSArray *softwares))completionHandler
{
    [self getWithProtocalName:@"getallsoftware" paramString:nil completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"getallsoftware resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, nil);
            }
            return;
        }
        
        NSArray *softwareList = [resultString toJsonData];
        NSMutableArray *results = [NSMutableArray new];
        for (NSInteger i = 0; i < softwareList.count; i++) {
            NSDictionary *info = softwareList[i];
            SoftwareItem *item = [[SoftwareItem alloc] initWithJsonData:info];
            [results addObject:item];
        }
        
        if (completionHandler) {
            completionHandler(nil, results);
        }
    }];
}

- (void)searchSoftwaresWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSError *error, NSArray *softwares))completionHandler
{
    NSString *paramString = [NSString stringWithFormat:@"keyword=%@", [keyword stringByEncodingURIComponent]];
    [self getWithProtocalName:@"search" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"searchSoftwares resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, nil);
            }
            return;
        }
        
        NSArray *softwareList = [resultString toJsonData];
        NSMutableArray *results = [NSMutableArray new];
        for (NSInteger i = 0; i < softwareList.count; i++) {
            NSDictionary *info = softwareList[i];
            SoftwareItem *item = [[SoftwareItem alloc] initWithJsonData:info];
            [results addObject:item];
        }
        
        if (completionHandler) {
            completionHandler(nil, results);
        }
    }];
}

- (void)updateBrowseNumWithSoftwareId:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, BOOL success))completionHandler
{
    NSString *paramString = [NSString stringWithFormat:@"software_id=%li", softwareId];
    [self getWithProtocalName:@"updateBrowseNum" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"updateBrowseNum resultString = %@", resultString);
        if (!completionHandler) {
            return;
        }
        
        if (error) {
            completionHandler(error, NO);
            return;
        }
        
        if ([resultString containsString:@"200:OK"]) {
            completionHandler(nil, YES);
        } else {
            NSError *error = [NSError errorWithDomain:@"server error" code:-1 userInfo:@{@"msg":resultString}];
            completionHandler(error, NO);
        }
    }];
}

- (void)queryAllShortcutKeysOfSoftware:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, NSArray *shortcutKeys))completionHandler
{
    NSString *paramString = [NSString stringWithFormat:@"software_id=%li", softwareId];
    [self getWithProtocalName:@"getallshortcut" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"getallsoftware resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, nil);
            }
            return;
        }
        
        NSArray *softwareList = [resultString toJsonData];
        NSMutableArray *results = [NSMutableArray new];
        for (NSInteger i = 0; i < softwareList.count; i++) {
            NSDictionary *info = softwareList[i];
            ShortcutkeyItem *item = [[ShortcutkeyItem alloc] initWithJsonData:info];
            [results addObject:item];
        }
        
        if (completionHandler) {
            completionHandler(nil, results);
        }
    }];
}

- (void)queryAllMyCreatedSoftwaresWithAccount:(NSString *)account completionHandler:(void(^)(NSError *error, NSArray *softwares))completionHandler
{
    NSString *paramString = [NSString stringWithFormat:@"create_account=%@", account];
    [self getWithProtocalName:@"getmysoftware" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"getmysoftware resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, nil);
            }
            return;
        }
        
        NSArray *softwareList = [resultString toJsonData];
        NSMutableArray *results = [NSMutableArray new];
        for (NSInteger i = 0; i < softwareList.count; i++) {
            NSDictionary *info = softwareList[i];
            SoftwareItem *item = [[SoftwareItem alloc] initWithJsonData:info];
            [results addObject:item];
        }
        
        if (completionHandler) {
            completionHandler(nil, results);
        }
    }];
}

- (void)deleteMyCreatedSoftwareWithSoftwareId:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, BOOL success))completionHandler
{
    NSString *paramString = [NSString stringWithFormat:@"software_id=%li", softwareId];
    [self getWithProtocalName:@"deletemysoftware" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"deletemysoftware resultString = %@", resultString);
        if (!completionHandler) {
            return;
        }
        
        if (error) {
            completionHandler(error, NO);
            return;
        }
        
        if ([resultString containsString:@"200:OK"]) {
            completionHandler(nil, YES);
        } else {
            NSError *error = [NSError errorWithDomain:@"server error" code:-1 userInfo:@{@"msg":resultString}];
            completionHandler(error, NO);
        }
    }];
}

- (void)editSoftwareWithId:(NSInteger)softwareId softwareName:(NSString *)softwareName shortcutkeys:(NSArray *)shortcutkeys completionHandler:(void(^)(NSError *error, BOOL success))completionHandler
{
    // 将数组转换为字符串
    NSMutableDictionary *info = [NSMutableDictionary new];
    info[@"shortcutkeys"] = shortcutkeys;
    
    NSString *shortcutString = [NSString stringWithJsonData:info];
    NSRange range;
    range.location = 16;
    range.length = shortcutString.length - range.location - 1;
    NSString *subString = [shortcutString substringWithRange:range];
    
    NSDictionary *parameters = @{
                                 @"software_id":@(softwareId),
                                 @"software_name":softwareName,
                                 @"shortcutkeys": subString
                                 };
    
    [self postWithProtocalName:@"editsoftware" parameters:parameters completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"editsoftware resultString = %@", resultString);
        if (!completionHandler) {
            return;
        }
        if (error) {
            completionHandler(error, NO);
        }
        
        if ([resultString isEqualToString:@"200:OK"]) {
            completionHandler(nil, YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

- (void)createSoftwareWithName:(NSString *)name shortcutKeys:(NSArray *)shortcutKeys account:(NSString *)account completionHandler:(void(^)(NSError *error, BOOL success))completionHandler
{
    // 将数组转换为字符串
    NSMutableDictionary *info = [NSMutableDictionary new];
    info[@"shortcutkeys"] = shortcutKeys;
    
    NSString *shortcutString = [NSString stringWithJsonData:info];
    NSLog(@"shortcutString = %@", shortcutString);
    NSRange range;
    range.location = 16;
    range.length = shortcutString.length - range.location - 1;
    NSString *subString = [shortcutString substringWithRange:range];
    NSLog(@"subString = %@", subString);
    
    NSDictionary *parameters = @{
        @"name":name,
        @"create_account":account,
        @"detail":@"miaoshu",
        @"logo":@"",
        @"shortcutkeys": subString
    };
    
    [self postWithProtocalName:@"addonesoftware" parameters:parameters completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"createSoftwareWithName resultString = %@", resultString);
        if (!completionHandler) {
            return;
        }
        if (error) {
            completionHandler(error, NO);
        }
        
        if ([resultString isEqualToString:@"200:OK"]) {
            completionHandler(nil, YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

#pragma mark - comment

- (void)queryallCommentsOfSoftware:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, NSArray *comments))completionHandler
{
    NSString *paramString = [NSString stringWithFormat:@"software_id=%li", softwareId];
    [self getWithProtocalName:@"getallcomment" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"getallcomment resultString = %@", resultString);
        if (error) {
            if (completionHandler) {
                completionHandler(error, nil);
            }
            return;
        }
        
        NSArray *softwareList = [resultString toJsonData];
        NSMutableArray *results = [NSMutableArray new];
        for (NSInteger i = 0; i < softwareList.count; i++) {
            NSDictionary *info = softwareList[i];
            CommentItem *item = [[CommentItem alloc] initWithJsonData:info];
            [results addObject:item];
        }
        
        if (completionHandler) {
            completionHandler(nil, results);
        }
    }];
}

- (void)addCommentWithSoftwareId:(NSInteger)softwareId createAccout:(NSString *)createAccout content:(NSString *)content completionHanlder:(void(^)(NSError *error, BOOL success))completionHandler
{
    NSString *encodeContent = [content stringByEncodingURIComponent];
    NSString *paramString = [NSString stringWithFormat:@"software_id=%li&create_account=%@&content=%@", softwareId, createAccout, encodeContent];
    [self getWithProtocalName:@"addonecomment" paramString:paramString completionHandler:^(NSError *error, id bodyData) {
        NSString *resultString = (NSString *)bodyData;
        NSLog(@"addcomment resultString = %@", resultString);
        if (!completionHandler) {
            return;
        }
        
        if (error) {
            completionHandler(error, NO);
            return;
        }
        
        if ([resultString containsString:@"200:OK"]) {
            completionHandler(nil, YES);
        } else {
            NSError *error = [NSError errorWithDomain:@"server error" code:-1 userInfo:@{@"msg":resultString}];
            completionHandler(error, NO);
        }
    }];
}

@end
