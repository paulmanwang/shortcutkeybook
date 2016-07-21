//
//  AddShortcutTableViewCell.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AddShortcutTableViewCell.h"

@interface AddShortcutTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextFiled;

@property (strong, nonatomic) ShortcutkeyItem *shortcutKeyItem;

@end

@implementation AddShortcutTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.nameTextField.text = @"";
    self.detailTextFiled.text = @"";
}

+ (CGFloat)cellHeight
{
    return 60.0f;
}

- (void)fillData:(ShortcutkeyItem *)item
{
    self.shortcutKeyItem = item;
}

- (IBAction)nameTextFiledEditingChanged:(id)sender
{
    self.shortcutKeyItem.shortcutKeyName = self.nameTextField.text;
}

- (IBAction)detailTextFiledEditingChanged:(id)sender
{
    self.shortcutKeyItem.shortcutKeyDetail = self.detailTextFiled.text;
}

@end
