//
//  UIView+WLC.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WLC)

- (void)setWidth:(CGFloat)width;
- (CGFloat)width;

- (void)setHeight:(CGFloat)height;
- (CGFloat)height;

- (void)setLeft:(CGFloat)left;
- (CGFloat)left;

- (void)setRight:(CGFloat)right;
- (CGFloat)right;

- (void)setTop:(CGFloat)top;
- (CGFloat)top;

- (void)showLoadingViewWithText:(NSString *)text;
- (void)dismissLoadingView;

- (void)toastWithMessage:(NSString *)message;

+ (instancetype)viewWithNib:(NSString *)nib owner:(id)owner;

@end
