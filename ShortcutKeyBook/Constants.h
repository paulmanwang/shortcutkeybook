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

#define UMAppKey    @"5770b2dbe0f55a5f640013e0"
#define WXAppId     @"wx6d75e9579450d27d"
#define WXAppSecret @"285ea8906cae9e3977ecc43de4231383"
#define JSPatchAppKey @"41764ef38b2d53c7"

#define kSoftwareNumChanged  @"kSoftwareNumChanged"
#define kEditSoftwareSuccess @"kEditSoftwareSuccess"
#define kWordButtonClicked   @"kWordButtonClicked"
#define kTopBarHeight       64
#define kTabBarHeight       49

#define kAppBackgroudColor [UIColor colorWithRed:20/255.0 green:150/255.0 blue:213/255.0 alpha:1.0]
#define kAppTextColor [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

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
