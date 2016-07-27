//
//  MyFavorViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyFavorViewController.h"
#import "SoftwareManager.h"
#import "SoftwareCell.h"
#import "ShortcutKeyViewController.h"
#import "EmptyView.h"


@implementation MyFavorViewController

+ (instancetype)myFavorViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我收藏的快捷键";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.softwares = [[SoftwareManager sharedInstance] loadMyFavorSoftwares];
    [self performSelector:@selector(showEmptyView) withObject:nil afterDelay:0];
}

- (void)showEmptyView
{
    if (self.softwares.count == 0) {
        [EmptyView showOnView:self.view withText:@"您还没有收藏快捷键哦~"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.softwares[indexPath.row];
    BOOL ret = [[SoftwareManager sharedInstance] removeMyFavorSoftware:item];
    if (ret) {
        NSLog(@"删除收藏成功");
        self.softwares = [[SoftwareManager sharedInstance] loadMyFavorSoftwares];
        if (self.softwares.count == 0) {
            self.emptyView = [EmptyView showOnView:self.view withText:@"您还没有收藏快捷键哦~"];
        }
        else {
            [self.emptyView dismiss];
        }
        [self.tableView reloadData];
    }
    else {
        NSLog(@"删除收藏失败");
    }
}

@end
