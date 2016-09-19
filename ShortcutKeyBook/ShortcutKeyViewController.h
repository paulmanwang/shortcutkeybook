//
//  ShortcutKeyViewController.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/18.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoftwareItem.h"

@interface ShortcutKeyViewController : UIViewController

- (instancetype)initWithSoftwareItem:(SoftwareItem *)item shouldShowEditButton:(BOOL)show;

@end
