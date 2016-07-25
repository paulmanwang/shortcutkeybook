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
    self.nameTextField.delegate = self;
    self.detailTextFiled.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWordButtonClicked:) name:kWordButtonClicked object:nil];
}

- (void)onWordButtonClicked:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *word = userInfo[@"word"];
    if ([self.nameTextField isFirstResponder]) {
        self.nameTextField.text = [self.nameTextField.text stringByAppendingString:word];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
