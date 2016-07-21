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
    EmptyView *emptyView = (EmptyView *)[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:nil options:nil][0];
    emptyView.center = view.center;
    emptyView.textLabel.text = text;
    [view addSubview:emptyView];
    
    return emptyView;
}

@end
