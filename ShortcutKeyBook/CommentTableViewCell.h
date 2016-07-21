//
//  TableViewCell.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/24.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentItem.h"

@interface CommentTableViewCell : UITableViewCell

+ (CGFloat)cellHeightWithContent:(NSString *)content;

- (void)fillData:(CommentItem *)comment;

@end
