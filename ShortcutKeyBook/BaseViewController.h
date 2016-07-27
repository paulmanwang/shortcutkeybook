//
//  BaseViewController.h
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyView.h"

@interface BaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *softwares;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) EmptyView *emptyView;

@end
