//
//  ShortcutKeyCollectionViewCell.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoftwareCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)fillWithName:(NSString *)name iconImage:(UIImage *)iconImage;

@end
