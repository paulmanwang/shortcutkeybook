//
//  UILabel+WLC.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/11.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UILabel+WLC.h"

@implementation UILabel (WLC)

- (CGSize)textSizeLimitedToMaxSize:(CGSize)maxSize
{
    return [self.text boundingRectWithSize:maxSize
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:self.font}
                                   context:nil].size;
}

- (CGSize)textSizeLimitedToMaxWidth:(CGFloat)maxWidth
{
    return [self textSizeLimitedToMaxSize:CGSizeMake(maxWidth, MAXFLOAT)];
}

@end
