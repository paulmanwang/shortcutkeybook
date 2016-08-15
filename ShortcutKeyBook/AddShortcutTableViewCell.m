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

- (NSRange)selectedRange:(UITextField *)field
{
    //开始位置
    UITextPosition* beginning = field.beginningOfDocument;
    //光标选择区域
    UITextRange* selectedRange = field.selectedTextRange;
    //选择的开始位置
    UITextPosition* selectionStart = selectedRange.start;
    //选择的结束位置
    UITextPosition* selectionEnd = selectedRange.end;
    //选择的实际位置
    const NSInteger location = [field offsetFromPosition:beginning toPosition:selectionStart];
    //选择的长度
    const NSInteger length = [field offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

- (void)onWordButtonClicked:(NSNotification *)notification
{
    if ([self.nameTextField isFirstResponder]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *word = userInfo[@"word"];
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
    self.nameTextField.text = item.shortcutKeyName;
    self.detailTextFiled.text = item.shortcutKeyDetail;
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
