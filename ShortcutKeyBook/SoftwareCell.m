//
//  ShortcutKeyCollectionViewCell.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SoftwareCell.h"

static const NSUInteger CellNumPerRow = 3;
static const CGFloat CellHoriDist = 10.0f;

@interface SoftwareCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation SoftwareCell

- (void)awakeFromNib
{
    // Initialization code
//    self.iconImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.iconImageView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.iconImageView.layer.shadowOpacity = 0.2;
//    self.iconImageView.layer.shadowRadius = 1;
}

+ (CGSize)cellSize
{
    static CGSize cellSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - (CellNumPerRow + 1) * CellHoriDist) / CellNumPerRow;
        cellSize = CGSizeMake(width, width);
    });
    
    return cellSize;
}

- (void)fillWithName:(NSString *)name iconImage:(UIImage *)iconImage
{
    self.nameLabel.text = name;
    //self.iconImageView.image = iconImage;
}

@end
