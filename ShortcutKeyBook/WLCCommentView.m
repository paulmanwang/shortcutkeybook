//
//  WLCCommentView.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/23.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCCommentView.h"

@implementation WLCCommentView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 25)];
    imageView.image = [UIImage imageNamed:@"comment"];
    [self addSubview:imageView];
    self.commentImageView = imageView;
    
    UIColor *blueColor = [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 19, 15, 8)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = blueColor;
    label.font = [UIFont boldSystemFontOfSize:8.0f];
    label.text = @"999";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.numberLabel = label;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapGesture];
}

- (void)onTap
{
    NSLog(@"onTap");
    NSLog(@"number = %@", self.numberLabel.text);
    if ([self.delegate respondsToSelector:@selector(wlcCommentViewDidClicked:)]) {
        [self.delegate wlcCommentViewDidClicked:self];
    }
}

@end
