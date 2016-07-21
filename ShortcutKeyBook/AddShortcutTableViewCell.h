//
//  AddShortcutTableViewCell.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortcutkeyItem.h"

@interface AddShortcutTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)fillData:(ShortcutkeyItem *)item;

@end
