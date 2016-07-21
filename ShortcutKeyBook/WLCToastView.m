//
//  SniffToastView.m
//  TimeCloud
//
//  Created by lichunwang on 16/5/10.
//  Copyright © 2016年 Xunlei. All rights reserved.
//

#import "WLCToastView.h"

@implementation WLCToastView

+ (void)toastWithMessage:(NSString *)message onView:(UIView *)view
{
    UITabBarController *tabBarViewController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *naviController = (UINavigationController *)tabBarViewController.selectedViewController;
    UIViewController *topViewController = naviController.visibleViewController;
    
    view = topViewController.view;
    WLCToastView *toastView = (WLCToastView *)[UIView viewWithNib:@"WLCToastView" owner:nil];
    
    toastView.toastButton.userInteractionEnabled = NO;
    toastView.toastButton.layer.cornerRadius = 5.0;
    toastView.toastButton.layer.masksToBounds = YES;
    [toastView.toastButton setTitle:message];
    
    toastView.frame = CGRectMake(0, 0, view.width, view.height);
    
    CGSize size = [toastView.toastButton.titleLabel textSizeLimitedToMaxWidth:view.width - 60];
    CGFloat toastButtonWidth = size.width + 16;
    toastView.toastButton.frame = CGRectMake((view.width - toastButtonWidth) / 2.0, view.height - 90, toastButtonWidth, 33.0f);
    
    [view addSubview:toastView];
    
    toastView.toastButton.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        toastView.toastButton.alpha = 1;
        
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                toastView.toastButton.alpha = 0;
            } completion:^(BOOL finished) {
                [toastView removeFromSuperview];
            }];
        });
        
    }];
}

@end
