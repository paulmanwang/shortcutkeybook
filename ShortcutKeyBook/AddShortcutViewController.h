//
//  AddShortcutViewController.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoftwareItem.h"
#import "ShortcutkeyItem.h"

@interface AddShortcutViewController : UIViewController

- (void)setSoftwareItem:(SoftwareItem *)item shortcutkeyList:(NSArray *)shortcutkeyList;

@end
