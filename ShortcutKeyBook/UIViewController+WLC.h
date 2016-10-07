//
//  UIViewController+WLC.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WLC)

- (void)presentViewControllerWithNavi:(UIViewController *)controller animated:(BOOL)animated completion:(void(^)(void))completion;

- (void)dismiss;

@end
