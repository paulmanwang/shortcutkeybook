//
//  SniffToastView.h
//  TimeCloud
//
//  Created by lichunwang on 16/5/10.
//  Copyright © 2016年 Xunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLCToastView : UIView

@property (weak, nonatomic) IBOutlet UIButton *toastButton;

+ (void)toastWithMessage:(NSString *)message onView:(UIView *)view;

@end
