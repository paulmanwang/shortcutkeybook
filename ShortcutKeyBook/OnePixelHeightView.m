//
//  OnePixelHeightView.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/15.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "OnePixelHeightView.h"

@implementation OnePixelHeightView

- (void)awakeFromNib
{
    CGFloat onePixel = 1.0f/[UIScreen mainScreen].scale;
    
    self.height = onePixel;
    
    if (self.tag < 0) {
        self.top -= onePixel*([UIScreen mainScreen].scale-1);
    }
    else if (self.tag > 0)
    {
        self.top += onePixel*([UIScreen mainScreen].scale-1);
    }
    
    BOOL heightConstraintExist = NO;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = onePixel;
            heightConstraintExist = YES;
            break ;
        }
    }
    if (!heightConstraintExist) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:onePixel]];
    }
}


@end
