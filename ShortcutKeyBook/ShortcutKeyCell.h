//
//  ShortcutKeyCell.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortcutkeyItem.h"

@interface ShortcutKeyCell : UITableViewCell

+ (CGFloat)cellHeightWithData:(ShortcutkeyItem *)item;

- (void)fillData:(ShortcutkeyItem *)item;

@end
