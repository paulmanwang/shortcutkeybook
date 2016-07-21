//
//  UIButton+WLC.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/11.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UIButton+WLC.h"

@implementation UIButton (WLC)

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
}

- (NSString *)title
{
    return [self titleForState:UIControlStateNormal];
}

@end
