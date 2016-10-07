//
//  UIViewController+WLC.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UIViewController+WLC.h"
#import <objc/runtime.h>

@implementation UIViewController (WLC)

- (void)presentViewControllerWithNavi:(UIViewController *)controller animated:(BOOL)animated completion:(void(^)(void))completion
{
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_close_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBtnClicked)];
    
    [self presentViewController:naviController animated:animated completion:completion];
}

- (void)setAnimated:(BOOL)animated
{
    NSNumber *number = animated ? @1 : @0;
    objc_setAssociatedObject(self, @"animated", number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)onCloseBtnClicked
{
    [self dismiss];
}

- (void)dismiss
{
    NSNumber *animated = objc_getAssociatedObject(self, @"animated");
    [self.navigationController dismissViewControllerAnimated:(animated.integerValue == 1) completion:nil];
}

@end
