//
//  ShortcutKeyCell.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ShortcutKeyCell.h"

@interface  ShortcutKeyCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation ShortcutKeyCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)cellHeight
{
    return 40.0f;
}

- (void)fillData:(ShortcutkeyItem *)item
{
    self.nameLabel.text = item.shortcutKeyName;
    self.detailLabel.text = item.shortcutKeyDetail;
}

@end
