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
    [super awakeFromNib];
    self.nameLabel.textColor = kAppTextColor;
    self.detailLabel.textColor = kAppTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)cellHeightWithData:(ShortcutkeyItem *)item
{
    CGFloat maxWidth = 142.0f;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize nameLabelSize = [item.shortcutKeyName boundingRectWithSize:maxSize
                            options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:font}
                            context:nil].size;
    
    maxWidth = [UIScreen mainScreen].bounds.size.width - 142 - 37;
    maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize detailLabelSize =  [item.shortcutKeyDetail boundingRectWithSize:maxSize
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:font}
                                                                 context:nil].size;
    
    if (nameLabelSize.height > 21 || detailLabelSize.height > 21) {
        return 60;
    } else {
        return 40;
    }
}

- (void)fillData:(ShortcutkeyItem *)item
{
    self.nameLabel.text = item.shortcutKeyName;
    self.detailLabel.text = item.shortcutKeyDetail;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
}

@end
