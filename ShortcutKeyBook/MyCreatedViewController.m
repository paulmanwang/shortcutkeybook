//
//  MyCreatedViewController.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/6/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyCreatedViewController.h"
#import "SoftwareCell.h"
#import "SoftwareItem.h"
#import "SoftwareManager.h"
#import "LoginManager.h"
#import "ShortcutKeyViewController.h"
#import "EmptyView.h"

@implementation MyCreatedViewController

+ (instancetype)myCreatedViewController
{
    return [[self alloc] initWithNibName:@"BaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我创建的快捷键";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditSoftwareSuccess) name:kEditSoftwareSuccess object:nil];
    [self reloadData];
}

- (void)reloadData
{
    NSString *account = [LoginManager sharedInstance].currentUserInfo.username;
    
    [[SoftwareManager sharedInstance] queryAllMyCreatedSoftwaresWithAccount:account completionHandler:^(NSError *error, NSArray *softwares) {
        if (softwares.count > 0) {
            self.softwares = softwares;
            [self.tableView reloadData];
        } else {
            [EmptyView showOnView:self.view withText:@"您还没有创建过快捷键哦~"];
        }
    }];
}

- (void)onEditSoftwareSuccess
{
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)deleteSofware:(SoftwareItem *)item
{
    NSMutableArray *softwares = [NSMutableArray arrayWithArray:self.softwares];
    for (NSInteger i = 0; i < softwares.count; i++) {
        SoftwareItem *dstItem = softwares[i];
        if (item.softwareId == dstItem.softwareId) {
            [softwares removeObjectAtIndex:i];
            break;
        }
    }
    
    self.softwares = [NSArray arrayWithArray:softwares];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.softwares[indexPath.row];
    [[SoftwareManager sharedInstance] deleteMyCreatedSoftwareWithSoftwareId:item.softwareId completionHandler:^(NSError *error, BOOL success) {
        if (success) {
            [self.view toastWithMessage:@"删除成功"];
            [self deleteSofware:item];
            if (self.softwares.count == 0) {
                self.emptyView = [EmptyView showOnView:self.view withText:@"您还没有创建过快捷键哦~"];
            }
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSoftwareNumChanged object:self];
        }
        else {
            [self.view toastWithMessage:@"删除失败，请重试"];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoftwareItem *item = self.softwares[indexPath.row];
    ShortcutKeyViewController *vc = [[ShortcutKeyViewController alloc] initWithSoftwareItem:item shouldShowEditButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
