//
//  UIView+WLC.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UIView+WLC.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import <objc/runtime.h>
#import "WLCToastView.h"

@implementation UIView (WLC)

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setTop:(CGFloat)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, @"MBProgressHUD", hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)hud
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, @"MBProgressHUD");
    return hud;
}

- (void)showLoadingView
{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
//    hud.labelText = @"正在加载";
//    [hud show:NO];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"正在加载...";
    [self addSubview:hud];
    [hud show:NO];
    [self setHud:hud];
}

- (void)dismissLoadingView
{
    MBProgressHUD *hud = [self hud];
    [hud hide:NO];
}

+ (instancetype)viewWithNib:(NSString *)nib owner:(id)owner
{
    return [[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil][0];
}

- (void)toastWithMessage:(NSString *)message
{
    [WLCToastView toastWithMessage:message onView:self];
}

@end
