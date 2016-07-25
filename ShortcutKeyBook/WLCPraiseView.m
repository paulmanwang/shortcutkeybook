//
//  WLCPraiseView.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/23.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCPraiseView.h"

@implementation WLCPraiseView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"praise"];
    [self addSubview:imageView];
    self.praiseImageView = imageView;
    
    UIColor *blueColor = [UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19, 3, 15, 8)];
    label.font = [UIFont systemFontOfSize:8.0f];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = blueColor;
    label.text = @"100";
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
    if ([self.delegate respondsToSelector:@selector(wlcPraiseViewDidClicked:)]) {
        [self.delegate wlcPraiseViewDidClicked:self];
    }
}

@end
