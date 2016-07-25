//
//  SoftwareManager.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/1.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoftwareItem.h"

@interface SoftwareManager : NSObject

DECLARA_SHARED_INSTANCE

#pragma mark - software

- (NSArray *)loadMyFavorSoftwares;

- (BOOL)addMyFavorSoftware:(SoftwareItem *)item;

- (BOOL)softwareHasThumbUp:(SoftwareItem *)item;

- (BOOL)addThumbUpSoftware:(SoftwareItem *)item;

- (BOOL)removeThumbUpSoftware:(SoftwareItem *)item;

- (void)thumbUpWithUp:(BOOL)up softwareId:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, BOOL success))completionHandler;

- (void)queryAllSoftwaresWithCompletionHandler:(void(^)(NSError *error, NSArray *softwares))completionHandler;

- (void)queryAllShortcutKeysOfSoftware:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, NSArray *shortcutKeys))completionHandler;

- (void)queryAllMyCreatedSoftwaresWithAccount:(NSString *)account completionHandler:(void(^)(NSError *error, NSArray *softwares))completionHandler;

- (void)createSoftwareWithName:(NSString *)name shortcutKeys:(NSArray *)shortcutKeys account:(NSString *)account completionHandler:(void(^)(NSError *error, BOOL success))completionHandler;

- (void)searchSoftwaresWithKeyword:(NSString *)keyword completionHandler:(void(^)(NSError *error, NSArray *softwares))completionHandler;

#pragma mar - comment

- (void)queryallCommentsOfSoftware:(NSInteger)softwareId completionHandler:(void(^)(NSError *error, NSArray *comments))completionHandler;

- (void)addCommentWithSoftwareId:(NSInteger)softwareId createAccout:(NSString *)createAccout content:(NSString *)content completionHanlder:(void(^)(NSError *error, BOOL success))completionHandler;

@end
