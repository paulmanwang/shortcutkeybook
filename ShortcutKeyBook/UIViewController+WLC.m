//
//  UIViewController+WLC.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UIViewController+WLC.h"

@implementation UIViewController (WLC)

- (void)presentViewControllerWithNavi:(UIViewController *)controller animated:(BOOL)animated completion:(void(^)(void))completion
{
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_close_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(onCloseBtnClicked)];
    
    [self presentViewController:naviController animated:animated completion:completion];
}

- (void)onCloseBtnClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
