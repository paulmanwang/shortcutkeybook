//
//  Constants.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define HOST @"121.40.60.250"

#define RNCryptorPassword @"wlc20112413015++"

#define kAddShortcutKeySuccess @"kAddShortcutKeySuccess"
#define kWordButtonClicked @"kWordButtonClicked"

#define DECLARA_SHARED_INSTANCE \
+ (instancetype)sharedInstance;

#define IMPLEMENTATE_SHARED_INSTANCE(ObjClass) \
+ (instancetype)sharedInstance { \
    static ObjClass *obj = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        obj = [[ObjClass alloc] init]; \
    }); \
   return obj; \
}

#endif /* Constants_h */
