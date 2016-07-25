//
//  WLCCommentView.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/23.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLCCommentView;

@protocol  WLCCommentViewDelegate<NSObject>

- (void)wlcCommentViewDidClicked:(WLCCommentView *)view;

@end

@interface WLCCommentView : UIView

@property (weak, nonatomic) id<WLCCommentViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *commentImageView;
@property (strong, nonatomic) UILabel *numberLabel;

@end
