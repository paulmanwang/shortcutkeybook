//
//  EmptyView.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/7/16.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

+ (instancetype)showOnView:(UIView *)view withText:(NSString *)text;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
