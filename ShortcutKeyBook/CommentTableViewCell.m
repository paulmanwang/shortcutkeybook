//
//  TableViewCell.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/24.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface  CommentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headerImageView.layer.cornerRadius = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithContent:(NSString *)content
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 89;
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine)
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.height + 72 + 2; // 额外多加1个像素界面才会显示正常，这里应该有个BUG。(原因:cell的contentview高度要比cell高度少一个点) // 我去这里有多加2才能正常
}

- (void)fillData:(CommentItem *)comment
{
    self.contentLabel.text = comment.content;
    if ([comment.createAccount isEqualToString:@"wlcunknownwlc"]) {
        self.nicknameLabel.text = @"匿名用户";
    } else {
        self.nicknameLabel.text = comment.createAccount;
    }
    self.timeLabel.text = comment.addTime;
}

@end
