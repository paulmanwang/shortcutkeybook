//
//  EmptyView.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/16.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

+ (instancetype)showOnView:(UIView *)view withText:(NSString *)text
{
    NSLog(@"superview = %@", view.superview);
    NSLog(@"view = %@", view);
    EmptyView *emptyView = (EmptyView *)[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:nil options:nil][0];
    emptyView.center = CGPointMake(view.width/2.0, view.height/2.0);
    emptyView.textLabel.text = text;
    [view addSubview:emptyView];
    
    return emptyView;
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
